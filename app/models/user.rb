# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  profile_picture :string
#  status          :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_reader :password

  validates :email, presence: true
  validates_uniqueness_of :email, message: 'Oops, this email has already been registered!'
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :sessions

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return unless user
    user.password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def serialize(opts = {})
    Users::ShowSerializer.new(self, opts).serializable_hash
  end
end
