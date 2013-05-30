# oauth-login
simple OAuth 1.0a login example with rails to fetch user tokens.  
works with twitter, dropbox, and tumblr but can be modified to work with any other OAuth 1.0 service.  
**oauth_one_controller.rb is meant to work independently and can be added to any other rails project.**  
this example will add a single service's tokens to a user in the database so that they can use the service again by simply logging in with their base account.  
the twitter gem is only used for tweeting not authentication.  
posting to tumblr and uploading to dropbox are not implemented in this example as it is outside the scope of this project.  

things for you to add
---
**enter your respective keys into**   
/app/controllers/oauth_one_controller.rb _line 44_  
```
$TWITTER_KEY = '####'
$TWITTER_SECRET = '###'
$TUMBLR_KEY = '###'
$TUMBLR_SECRET = '###'
$DROPBOX_KEY = '###'
$DROPBOX_SECRET = '###'
```
**add this to your routes when using the controller independently**  
````
get "/default/oauth" => "oauth_one#receiveTokens"
get "service" => "oauth_one#requestTokens", :as => "service"
```
example of a link to twitter auth:  
`<%= link_to 'Add Twitter', service_path('twitter') %>`  
**to tweet enter your keys into**  
/config/initializers/twitter.rb  
required gems
---
* oauth  
* bcrypt-ruby  
* twitter  

![twitter](http://upload.wikimedia.org/wikipedia/en/thumb/9/9f/Twitter_bird_logo_2012.svg/100px-Twitter_bird_logo_2012.svg.png "Twitter")
![dropbox](http://upload.wikimedia.org/wikipedia/en/thumb/b/bb/Dropbox_logo.svg/220px-Dropbox_logo.svg.png "Dropbox")
![tumblr](http://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Tumblrfull.svg/250px-Tumblrfull.svg.png "Tumblr")
