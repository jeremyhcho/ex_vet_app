# == Schema Information
#
# Table name: sessions
#
#  id          :integer          not null, primary key
#  token       :string           not null
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  remember_me :string
#

class Session < ActiveRecord::Base
  validates :token, presence: true

  belongs_to :user

  after_initialize :generate_token

  before_create :hash_remember_me, :hash_token

  def generate_token
    self.token ||= SecureRandom.base64
  end

  private

  def hash_token
    self.token = Digest::SHA256.hexdigest(token)
  end

  def hash_remember_me
    return unless remember_me
    self.remember_me = Digest::SHA256.hexdigest(remember_me)
  end
end
