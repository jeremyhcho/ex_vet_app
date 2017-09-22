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

  before_save :ensure_formatted_name

  has_many :sessions
  has_many :companies_users
  has_many :managed_companies, class_name: 'Company', foreign_key: :owner_id
  has_many :authorized_companies,
           through: :companies_users,
           source: :company

  def accessible_companies
    managed_companies | authorized_companies
  end

  def ensure_formatted_name
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end

  def full_name
    "#{first_name} #{last_name}"
  end

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

  def password_reset_token
    @password_reset_token ||= (
      Rails.cache.fetch(password_reset_token_cache_key, expires_in: 24.hours) do
        Digest::SHA256.hexdigest(SecureRandom.base64)
      end
    )
  end

  def password_reset_token_cache_key
    "password_reset_token:#{id}"
  end
end
