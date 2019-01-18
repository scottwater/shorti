require "rails_helper"

describe Link, type: :model do
  it "a URL must be set" do
    link = Link.new
    link.url = nil
    expect(link).to_not be_valid
  end

  it "a URL must be a URL" do
    link = Link.new
    link.url = "how now!"
    expect(link).to_not be_valid
  end

  # URI.parse downcases scheme and host. These may not matter

  it "we do not care about the case of the host" do
    link = Link.new
    link.url = "https://SCOTTW.com"
    expect(link).to be_valid
  end

  it "we do not care about the case of the scheme" do
    link = Link.new
    link.url = "HTTPS://SCOTTW.com"
    expect(link).to be_valid
  end
end
