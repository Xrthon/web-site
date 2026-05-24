class Session < ApplicationRecord
  belongs_to :user

  before_validation :generate_session_data, on: :create

  validates :session_token_hash, presence: true, uniqueness: true
  validates :expires_at, presence: true

  attr_reader :raw_session_token

  private

  def generate_session_data
    raw_token = SecureRandom.hex(32)

    @raw_session_token = raw_token

    self.session_token_hash ||= Digest::SHA256.hexdigest(raw_token)

    self.expires_at ||= 30.days.from_now

    self.last_activity_at ||= Time.current
  end
end