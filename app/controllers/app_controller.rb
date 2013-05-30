class AppController < ApplicationController
  def index
    
    @user = User.find(session[:user_id])
    if !@user.token
      @user.token = params[:format].split(',')[0]
      @user.secret = params[:format].split(',')[1]
    
      if @user.save
        notice = "Twitter Logged In"
      else
        render "users#new"
      end
    end
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
