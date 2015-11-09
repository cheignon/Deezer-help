//
//  Client.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
import Alamofire

enum Order{
    
    case RANKING
    case TRACK_ASC
    case TRACK_DESC
    case ARTIST_ASC
    case ARTIST_DESC
    case ALBUM_ASC
    case ALBUM_DESC
    case RATING_ASC
    case RATING_DESC
    case DURATION_ASC
    case DURATION_DESC
}
enum Filter{
    
    
    case ARTIST
    case ALBUM
    case TRACK
    case PLAYLIST
    case PODCAST
 
}
let DeezerSearchBaseURL = "http://api.deezer.com/search"
let Output = "&output=json"
class Client: NSObject {

    class var sharedClient: Client {
        struct Static {
            static let instance: Client = Client()
        }
        return Static.instance
    }
    func searchWithText(text Text:String,result: ([AnyObject]) -> Void,withOrder order:Order?,withFilter filter:Filter?){
    
       
        var request = DeezerSearchBaseURL
        
        
        
        if filter != nil {
        
            switch(filter!){
            
            case .ARTIST:
                request += "/artist"
                break
            case .ALBUM:
                request += "/album"
                break
                
            case .TRACK:
                request += "/track"
                break
                
            case .PLAYLIST:
                request += "/playlist"
                break
            case .PODCAST:
                request += "/podcast"
                break

            }
        
        }
        request += "?q=" + Text
        
        
        if order != nil{
            switch(order!){
            case .RANKING:
                request += "&order=RANKING"
                break
            case .TRACK_ASC:
                request += "&order=TRACK_ASC"
                break
            case .TRACK_DESC:
                request += "&order=TRACK_DESC"
                break
            case .ARTIST_ASC:
                request += "&order=ARTIST_ASC"
                break
            case .ARTIST_DESC:
                request += "&order=ARTIST_DESC"
                break
            case .ALBUM_ASC:
                request += "&order=ALBUM_ASC"
                break
            case .ALBUM_DESC:
                request += "&order=ALBUM_DESC"
                break
            case .RATING_ASC:
                request += "&order=RATING_ASC"
                break
            case .RATING_DESC:
                request += "&order=RATING_DESC"
                break
            case .DURATION_ASC:
                request += "&order=DURATION_ASC"
                break
            case .DURATION_DESC:
                request += "&order=DURATION_DESC"
                break
                
            }
        }
        
        request += Output
        
        
        Alamofire.request(.GET, request).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                if  let data = response.result.value?.valueForKeyPath("data"){
                    if filter != nil {
                        
                        switch(filter!){
                            
                        case .ARTIST:
                            result(Artist.collection(response: response.response!, representation: data))

                            break
                        case .ALBUM:
                            result(Album.collection(response: response.response!, representation: data))
                            break
                            
                        case .TRACK:
                            result(Track.collection(response: response.response!, representation: data))
                            break
                            
                        case .PLAYLIST:
                            result(Playlist.collection(response: response.response!, representation: data))
                            break
                        case .PODCAST:
                            request += "/podcast"
                            break
                            
                        }
                        
                    }else{
                        result(Search.collection(response: response.response!, representation: data))
                    }
                }
            }else{
                result([Search]())
            }
        }
    }
    
    func searchWithTrackList(tracklist:NSURL,result: ([Track]) -> Void){
        
        Alamofire.request(.GET, tracklist.absoluteString).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                if  let data = response.result.value?.valueForKeyPath("data"){
                    result(Track.collection(response: response.response!, representation: data))

                }
            }
        }
    }
    
   
    
}
