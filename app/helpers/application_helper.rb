module ApplicationHelper
	# I18n macros
	# def t( key, options={} )
	#   I18n.t( key, options )
	# end

	# ページごとの完全なタイトルを返します。
	def full_title( page_title )
		base_title = I18n.t( 'app.title' )
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

end
