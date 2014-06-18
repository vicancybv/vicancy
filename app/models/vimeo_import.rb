class VimeoImport < ActiveRecord::Base
  attr_accessible :vimeo_id, :wistia_id

  attr_accessor :url
end
