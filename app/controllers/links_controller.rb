class LinksController < ApplicationController
  before_action :verify_access, only: :create

  def index
    render json: {message: "Welcome to Shorti!"}
  end

  def create
    link = Link.new
    link.url = params[:url]
    link.title = params[:title]
    link.description = params[:description]
    if link.save
      render json: {id: link.share_id, url: link.share_url(ENV.fetch("SHORTI_BASE_URL", request.url))}, status: :created
    else
      render json: {error: "Your link could not be created"}, status: :unauthorized
    end
  end

  def show
    if (link = Link.get_by_share_id(params[:share_id]))
      link.counter += 1
      link.save
      if params[:info]
        render json: {id: link.share_id, counter: link.counter, title: link.title, description: link.description}
      else
        redirect_to link.url, status: :moved_permanently
      end
    else
      render json: {error: "No URL is available for #{params[:share_id]}"}, status: :not_found
    end
  end

  private

  def verify_access
    if Rails.env.production?
      verify_api_key!
    elsif ENV["SHORTI_API_KEY"].present? || params[:api_key].present?
      verify_api_key!
    end
  end

  def verify_api_key!
    unless ENV["SHORTI_API_KEY"].present? && ENV["SHORTI_API_KEY"] == params[:api_key]
      render json: {error: "Invalid API Key"}, status: :conflict
    end
  end
end
