class AppController < ApplicationController
  def index
  end

  def do
    text = params[:text]
    @user = User.find(session[:user_id])
    client = Twitter::Client.new(
  :oauth_token => @user.token,
  :oauth_token_secret => @user.secret)

    Thread.new{client.update(text)}
    
    redirect_to app_index_path
  end
end
