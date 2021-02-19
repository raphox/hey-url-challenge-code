# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks

  validates :short_url, presence: true
  validates :short_url, uniqueness: { case_sensitive: false }
  validates :original_url, presence: true
  validate :validate_original_url

  before_validation :generate_short_url

  private

  def generate_short_url
    return if persisted?

    code = nil

    while code.nil? ||
          Url.where({ short_url: code }).exists?
      code = SecureRandom.alphanumeric(5).upcase
    end

    self.short_url = code
  end

  def validate_original_url
    uri = URI.parse(original_url)
    errors.add(:original_url, :invalid) unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    errors.add(:original_url, :invalid)
  end
end
