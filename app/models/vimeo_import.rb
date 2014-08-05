# == Schema Information
#
# Table name: vimeo_imports
#
#  id         :integer          not null, primary key
#  vimeo_id   :string(255)
#  wistia_id  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VimeoImport < ActiveRecord::Base
  attr_accessible :vimeo_id, :wistia_id

  attr_accessor :url
end
