class UsersController < ApplicationController

def new
  @user = User.new
end

def create
  @user = User.new(params[:user])
  if @user.save
    redirect_to root_url, :notice => "Signed up!"
  else
    render "new"
  end
end

def login
    require 'oauth'

    consumer = get_consumer

    # Get a request token from Twitter
    @request_token = consumer.get_request_token :oauth_callback => ('http://' + request.env['HTTP_HOST'] + '/default/oauth/')


    # Store the request token's details for later
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    
    # Hand off to Twitter so the user can authorize us
    redirect_to @request_token.authorize_url
  end
  
  def oauth
    require 'oauth'

    consumer = get_consumer
    
    # Re-create the request token
    @request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_secret])
    
    # Convert the request token to an access token using the verifier Twitter gave us
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    # Store the token and secret that we need to make API calls
    session[:oauth_token] = @access_token.token
    session[:oauth_secret] = @access_token.secret
    
    @user = User.find(session[:user_id])
    @user.token = @access_token.token
    @user.secret = @access_token.secret
    
    if @user.save
      redirect_to app_index_path, :notice => "Twitter Logged In"
    else
      render "new"
    end
    
  end

  private
  
  def get_consumer
    OAuth::Consumer.new('CONSUMER KEY', 'CONSUMER SECRET', {:site => 'https://api.twitter.com/'})
  end

end