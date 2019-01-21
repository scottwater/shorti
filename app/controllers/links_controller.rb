class LinksController < ApplicationController
  before_action :verify_access, only: [:create, :show]

  def index
    render json: {message: "Welcome to Shorti!"}
  end

  def create
    link = Link.new
    link.url = params[:url]
    link.title = params[:title]
    link.description = params[:description]
    if link.save
      render json: {id: link.share_id, url: link.share_url(base_share_url)}, status: :created
    else
      render json: {error: "Your link could not be created"}, status: :unauthorized
    end
  end

  def redirect
    if (link = Link.get_by_share_id(params[:share_id]))
      link.counter += 1
      link.save
      redirect_to link.url, status: :moved_permanently
    else
      render json: {error: "No URL is available for #{params[:share_id]}"}, status: :not_found
    end
  end

  def show
    if (link = Link.get_by_share_id(params[:share_id]))
        data = { 
          id: link.share_id, 
          counter: link.counter, 
          title: link.title, 
          description: link.description,
          url: link.share_url(base_share_url)
        }
      render json: data
    else
      render json: {error: "No URL is available for #{params[:share_id]}"}, status: :not_found
    end
  end

  private

  def base_share_url
    ENV.fetch("SHORTI_BASE_URL", request.url)
  end

  def verify_access
    if Rails.env.production? || params[:action] == 'show' && ENV["SHORT_INFO_API_KEY"].present?
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
