class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order( 'created_at DESC' ) }

	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

	validates_presence_of :image

	has_attached_file :image,
		styles: { original: "800x600", medium: "200x200", thumb: "100x100" },
		convert_options: {
			all: [ "-strip" ],
			original: [ "-define", "jpeg:size=800x600" ],
			medium: [ "-define", "jpeg:size=200x200" ],
			thumb: [ "-define", "jpeg:size=100x100" ]
		}
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

end
