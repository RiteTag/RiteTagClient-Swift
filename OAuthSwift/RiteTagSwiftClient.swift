//
//  RiteTagSwiftClient.swift
//  RiteTag
//
//  Created by Shashank Bharadwaj on 3/6/15.
//  Copyright (c) 2015 RiteTag All rights reserved.
//

import Foundation

public class RiteTagSwiftClient {
    
    let host = "https://ritetag.com";
    let imageServices = ["twitter", "flickr", "imgur", "giphy", "instagram"]
    let oauthswift : OAuthSwiftClient
    
    init (consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
        oauthswift = OAuthSwiftClient(
            consumerKey       : consumerKey,
            consumerSecret    : consumerSecret,
            accessToken       : accessToken,
            accessTokenSecret : accessTokenSecret
        )
    }
    
    private func removeHashIfPresent(hashtag: String) -> String {
        if hashtag[hashtag.startIndex] == "#" {
            return dropFirst(hashtag)
        } else {
            return hashtag
        }
    }
    private func formatHashtag(hashtag: String) -> String {
        return hashtag.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    public func imagesForHashtag(hashtag: String, fromService: String, onSuccess: (JSON) -> Void, onFailure: (JSON) -> Void)
    {
        var hashtagWithoutHash = removeHashIfPresent(hashtag)
        if hashtagWithoutHash.length() == 0 {
            onSuccess([] as JSON)
            return
        }
        
        var tag = formatHashtag(hashtagWithoutHash)
        var fullURL = host
        var parameters = Dictionary<String, AnyObject>()

        if contains(imageServices, fromService) && (fromService != "twitter") {
            fullURL += "/api/v2.1/images/" + fromService
            parameters["tag"] = tag
        } else {
            fullURL += "/api/v2.1/images-for-hashtag/" + tag
        }
        
        oauthswift.get(
            fullURL,
            parameters: parameters,
            success: {
                data, response in
                let json = JSON(data: data)
                if (fromService == "twitter") {
                    onSuccess(json["images"])
                } else {
                    onSuccess(json["photos"])
                }
            },
            failure: {(error:NSError!) -> Void in
                onFailure(JSON(error))
        })
    }
    
    public func influencersForHashtag(hashtag: String,  onSuccess: (JSON) -> Void, onFailure: (JSON) -> Void)
    {
        var hashtagWithoutHash = removeHashIfPresent(hashtag)
        if hashtagWithoutHash.length() == 0 {
            onSuccess([] as JSON)
            return
        }
        
        let fullURL = host + "/api/v2/influencers-for-hashtag/" + formatHashtag(hashtagWithoutHash)
        
        oauthswift.get(
            fullURL,
            parameters: Dictionary(),
            success: {
                data, response in
                let json = JSON(data: data)
                onSuccess(json["influencers"])
            },
            failure: {(error:NSError!) -> Void in
                onFailure(JSON(error))
        })
    }

    public func statsForHashtag(hashtag: String,  onSuccess: (JSON) -> Void, onFailure: (JSON) -> Void)
    {
        var hashtagWithoutHash = removeHashIfPresent(hashtag)
        if hashtagWithoutHash.length() == 0 {
            onSuccess(["result":"false", "message":"Hashtag missing"] as JSON)
            return
        } else if hashtagWithoutHash.length() == 1 {
            onSuccess(["result":"false", "message":"Hashtag is too short"] as JSON)
            return
        }
        let fullURL = host + "/api/v2/ai/twitter/" + formatHashtag(hashtagWithoutHash)

        oauthswift.get(
            fullURL,
            parameters: Dictionary(),
            success: {
                data, response in
                let json = JSON(data: data)
                onSuccess(json)
            },
            failure: {(error:NSError!) -> Void in
                onFailure(JSON(error))
        })
    }
    
    public func trendingTags(onSuccess: (JSON) -> Void, onFailure: (JSON) -> Void)
    {
        let fullURL = host + "/api/v2/trending-hashtags"
        
        oauthswift.get(
            fullURL,
            parameters: [
                "green"     : true,
                "onlylatin" : true
            ],
            success: {
                data, response in
                let json = JSON(data: data)
                
                onSuccess(json["tags"])
            },
            failure: {(error:NSError!) -> Void in
                onFailure(JSON(error))
        })
    }
}
