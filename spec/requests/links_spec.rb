require "rails_helper"

RSpec.describe "The LINKS API!", type: :request do
  after(:each) do
    ENV["SHORTI_API_KEY"] = nil
    ENV["SHORTI_BASE_URL"] = nil
    ENV["SHORT_INFO_API_KEY"] = nil
  end

  describe "creating new links" do
    it "will add a new link" do
      post "/", params: {url: "https://scottw.com"}
      expect(response).to have_http_status(:created)
    end

    it "will add a new link with a custom URL" do
      ENV["SHORTI_BASE_URL"] = "https://shorti.shorti/"
      post "/", params: {url: "https://scottw.com"}
      expect(json["url"]).to match("https://shorti.shorti/#{json["id"]}")
    end

    it "will reject requests with an invalid API KEY" do
      post "/", params: {url: "https://scottw.com", api_key: "ABC"}
      expect(response).to have_http_status(:conflict)
    end

    it "will reject requests with an invalid API KEY" do
      ENV["SHORTI_API_KEY"] = "ABC"
      post "/", params: {url: "https://scottw.com"}
      expect(response).to have_http_status(:conflict)
    end

    it "will add a new link with a valid API KEY" do
      ENV["SHORTI_API_KEY"] = "ABC"
      post "/", params: {url: "https://scottw.com", api_key: "ABC"}
      expect(response).to have_http_status(:created)
    end

    it "will return a clean url to share (no API KEY)" do
      ENV["SHORTI_API_KEY"] = "ABC"
      post "/?api_key=ABC", params: {url: "https://scottw.com"}

      expect(json["url"]).to eql("http://www.example.com/#{json["id"]}")
    end
  end

  describe "with an existing link" do
    let(:link) do
      link = Link.new
      link.title = "KickoffLabs"
      link.url = "https://kickofflabs.com"
      link.save
      link
    end

    it "will redirect to the link" do
      get "/#{link.share_id}"
      expect(response).to redirect_to(link.url)
    end

    it "will increment the counter" do
      expect(link.counter).to be_zero
      get "/#{link.share_id}"
      link.reload
      expect(link.counter).to eql(1)
    end

    it "will show the info about the link" do 
      get "/info/#{link.share_id}" 
      expect(json["url"]).to eql("http://www.example.com/#{link.share_id}")
    end

    it "will return an error if the API Key is required" do 
      ENV["SHORTI_INFO_API_KEY"] = "Y"
      ENV["SHORTI_API_KEY"] = "NO"
      get "/info/#{link.share_id}" 
      expect(json["error"]).to eql("Invalid API Key")
    end

    it "will return the info with a valid API Key" do 
      ENV["SHORTI_INFO_API_KEY"] = "Y"
      ENV["SHORTI_API_KEY"] = "YES"
      get "/info/#{link.share_id}", params: {api_key: "YES"}
      expect(json["url"]).to eql("http://www.example.com/#{link.share_id}")
    end
  end

  it "will return a 404 for links that do not exist" do
    get "/MISSING"
    expect(response).to have_http_status(:not_found)
  end
end
