class OauthOneController < ApplicationController
#needed to remember type in this example. most likely remove and change how consumer works for your app
$type = ''

def requestTokens
    require 'oauth'
    #prepare your consumer keys to send to selected service (twitter, tumblr, dropbox)
    consumer = get_consumer(params[:format])
    $type = params[:format]

    #get a request token from service
    @request_token = consumer.get_request_token :oauth_callback => ('http://' + request.env['HTTP_HOST'] + '/default/oauth/')

    #store the request token
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    
    #send user to service log-in page
    redirect_to @request_token.authorize_url
  end
  
def receiveTokens
    require 'oauth'

    consumer = get_consumer($type)
    
    #re-create the request token
    @request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_secret])
    
    #convert the request token to an access token using the verifier the service gave us
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    #store the token and secret that we need to make API calls
    session[:oauth_token] = @access_token.token
    session[:oauth_secret] = @access_token.secret
    
    #send tokens to your app. change based on your app
    redirect_to app_index_path(@access_token.token + "," + @access_token.secret)
  end

  private
  
  #set to your keys and secrets. most likely remove and store somewhere else depending on your app
  $TWITTER_KEY = '###'
  $TWITTER_SECRET = '###'
  $TUMBLR_KEY = '###'
  $TUMBLR_SECRET = '###'
  $DROPBOX_KEY = '###'
  $DROPBOX_SECRET = '###'
  
  
  def get_consumer(type)
    if type == 'twitter'
    OAuth::Consumer.new($TWITTER_KEY, $TWITTER_SECRET, {:site => 'https://api.twitter.com/'})
    elsif type == 'tumblr'
    OAuth::Consumer.new($TUMBLR_KEY, $TUMBLR_SECRET, {:site => 'http://www.tumblr.com'})
    elsif type == 'dropbox'
    OAuth::Consumer.new($DROPBOX_KEY, $DROPBOX_SECRET, {:site => 'https://api.dropbox.com/1'})
  end
  end
  
end