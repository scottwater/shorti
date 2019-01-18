Rails.application.routes.draw do
  post "/" => "links#create"
  get "/:share_id" => "links#show"

  root to: "links#index"
end
