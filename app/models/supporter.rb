# == Schema Information
#
# Table name: supporters
#
#  id         :bigint(8)        not null, primary key
#  type       :integer
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Supporter < ApplicationRecord
  extend Enumerize
  validates :type, presence: true
  validates :image, presence: true
  mount_uploader :image, ImageUploader
  enumerize :type, in: { kyousann: 0, kouenn: 1 }
  self.inheritance_column = :_type_disabled

  class << self
    def kyousann
      where(type: :kyousann)
    end

    def kouenn
      where(type: :kouenn)
    end
  end
end