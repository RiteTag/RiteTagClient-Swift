<p align="center">
  <img src="Assets/icon.png?raw=true" alt="RiteTag"/>
</p>

# RiteTagClient-Swift
RiteTag API Client for Mac OSX and iOS

# Docs
For information about the API endpoints and response format see:
http://docs.ritetag.apiary.io/

# Signup
Resigter for a developer account and get your keys at:
https://ritetag.com/developer/signup

# Usage
Initialiaze the client with your api keys
```
var api = RiteTagSwiftClient(consumerKey: "", consumerSecret: "", accessToken: "", accessTokenSecret : "")
```
Call the api with a success and failure callback
```
api.statsForHashtag(hashtag,
    onSuccess: {
        json in
        
        let hashtag = json["query"].stringValue
        let retweets = json["queryHashtag"]["retweets"].intValue
        
        println("\(hashtag) has \(retweets) retweets / hour")

    }, onFailure: {
        error in
        
        print("Error: " + error)
    })
```
