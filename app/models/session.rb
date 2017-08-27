# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Session < ActiveRecord::Base
  validates :token, presence: true

  belongs_to :user

  after_initialize :ensure_token

  private

  def self.generate_token
    SecureRandom.base64
  end

  def ensure_token
    self.token ||= self.class.generate_token
  end
end
