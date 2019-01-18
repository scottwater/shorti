class Link < ApplicationRecord
  validates :url, presence: true
  validate :validate_url

  def share_id
    Base32::Crockford.encode(id)
  end

  def share_url(root_url)
    "#{root_url}#{share_id}"
  end

  def self.get_by_share_id(share_id)
    find_by(id: Base32::Crockford.decode(share_id))
  end

  private

  # wanted to keep it simple and use https://github.com/perfectline/validates_url
  # but it requires the scheme to be lower case (which I prefer)
  # I could not get their tests to pass locally, so going with something simple
  def validate_url
    uri = URI.parse(url)
    unless uri&.host && uri.scheme =~ /\Ahttps?/i && uri.host.include?(".")
      errors.add(:url, "Invalid Host or Scheme")
    end
  rescue URI::InvalidURIError
    errors.add(:url, "Invalid URI Error")
  end
end
