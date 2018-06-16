# == Schema Information
#
# Table name: upload_files
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  history_id :integer
#

class UploadFile < ApplicationRecord
  belongs_to :history, touch: true
  mount_uploader :file, FileUploader
end
