Rails.application.routes.draw do
  post "/" => "links#create"
  get "/info/:share_id" => "links#show"
  get "/:share_id" => "links#redirect"

  root to: "links#index"
end
