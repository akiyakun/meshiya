module Paperclip
  module Storage
    module AzureStorage
      def self.extended base
        begin
          require 'waz-blobs'
        rescue LoadError => e
          e.message << " (You may need to install the waz-storage gem)"
          raise e
        end

        base.instance_eval do
          @azure_credentials = @options[:azure_credentials] # parse_credentials(@options[:azure_credentials])
          @container         = @options[:azure_container] || @azure_credentials[:azure_container]
          @account_name      = @azure_credentials[:account_name]
          @azure_host_alias  = @options[:azure_host_alias]
          @url               = ":azure_host_alias"

          WAZ::Storage::Base.establish_connection!(
            account_name: @azure_credentials[:account_name],
              access_key:   @azure_credentials[:access_key])
        end

        Paperclip.interpolates(:azure_path_url) do |attachment, style|
          "https://#{attachment.account_name}.blob.core.windows.net/#{attachment.container_name}/#{attachment.path(style).gsub(%r{^/}, "")}"
        end
        Paperclip.interpolates(:azure_domain_url) do |attachment, style|
          "https://#{attachment.account_name}.blob.core.windows.net/#{attachment.container_name}/#{attachment.path(style).gsub(%r{^/}, "")}"
        end
      end

      def custom_url(style = default_style, ssl = false)
        ssl ? self.url(style).gsub('http', 'https') : self.url(style)
      end

      def account_name
        @account_name
      end

      def container_name
        @container
      end

      def azure_host_alias
        @azure_host_alias
      end

      def parse_credentials creds
        @azure_credentials
      end

      def exists?(style = default_style)
        # Note: コピペ元ではWAZ::Blobs::Container.find(container_name)[path(style)] を利用しているが、これは毎回リクエストを発行してしまうのであまり賢くないのでは？と思う
        # 一方original_filenameだけで判断すると実際にはファイルのアップロードが失敗しているのにtrueを返してしまう可能性がありそう
        # この部分は要改善っぽい
        !!original_filename
      end

      # Returns representation of the data of the file assigned to the given
      # style, in the format most representative of the current storage.
      def to_file style = default_style
        return @queued_for_write[style] if @queued_for_write[style]
        if exists?(style)
          file = Tempfile.new(path(style))
          file.write(WAZ::Blobs::Container.find(container_name)[path(style)].value)
          file.rewind
          file
        end
        return file
      end

      def flush_writes #:nodoc:
        target_container = WAZ::Blobs::Container.find(container_name)
        @queued_for_write.each do |style, file|
          begin
            Rails.logger.debug( 'save' )
            log("saving to Azure #{path(style)}")
            target_container.store(
               path(style),
               file.read,
               instance_read(:content_type),
               {:x_ms_blob_cache_control=>"max-age=315360000, public"} )
          rescue
            log("error saving to Azure #{path(style)}")
            ## If container doesn't exist we create it
            if target_container.blank?
              WAZ::Blobs::Container.create(container_name).public_access = "blob"
              log("retryng saving to Azure #{path(style)}")
              retry
            end
          end
        end
        @queued_for_write = {}
      end

      def flush_deletes #:nodoc:
        target_container = WAZ::Blobs::Container.find(container_name)
        @queued_for_delete.each do |path|
          begin
            log("deleting #{path}")
            target_container[path].destroy!
          rescue
            log("error deleting #{path}")
          end
        end
        @queued_for_delete = []
      end
    end
  end

end
