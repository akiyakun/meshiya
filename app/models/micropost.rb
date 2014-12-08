class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order( 'created_at DESC' ) }

	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

	has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }#,
		# storage: :azure1,
		# storage: :azure_storage,
		# default_url: "/images/:style/missing.png"

	# ファイルの拡張子を指定（これがないとエラーが発生する）
	validates_attachment :image,
		content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
	# validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
	# validates_attachment :avatar, presence: true,
	# 	content_type: { content_type: ["image/jpg", "image/png"] },
	# 	size: { less_than: 2.megabytes }

	def to_azure_url( style )
		image.url( style )
	end
end
