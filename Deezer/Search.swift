//
//  Search.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
final class Search:ResponseObjectSerializable,ResponseCollectionSerializable{


    var id:Int?//	The track's Deezer id	int
    var readable:Bool = false//	true if the track is readable in the player for the current user	boolean
    var title:String?//	The track's fulltitle	string
    var title_short:String?//	The track's short title	string
    var title_version:String?//	The track version	string
    var link:NSURL?//	The url of the track on Deezer	url
    var duration:Int?//	The track's duration in seconds	int
    var rank:Int?//	The track's Deezer rank	int
    var explicit_lyrics:Bool = false//	Whether the track contains explicit lyrics	boolean
    var preview:NSURL?//	The url of track's preview file. This file contains the first 30 seconds of the track	url
    var artist:Artist?//	artist object containing : id, name, link, picture, picture_small, picture_medium, picture_big	object
    var album:Album?//	album object containing : id, title, cover, cover_small, cover_medium, cover_big	object
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
    
        self.id = representation.valueForKeyPath("id") as? Int
        if let readableBool = representation.valueForKeyPath("readable") as? Bool{
            self.readable = readableBool
        }
        self.title = representation.valueForKeyPath("title") as? String
        self.title_short = representation.valueForKeyPath("title_short") as? String
        self.title_version = representation.valueForKeyPath("title_version") as? String
        if let linkString = representation.valueForKeyPath("link") as? String{
            self.link = NSURL(string: linkString)
        }
        self.duration = representation.valueForKeyPath("duration") as? Int
        self.rank = representation.valueForKeyPath("rank") as? Int
        if let explicit_lyricsBool = representation.valueForKeyPath("explicit_lyrics") as? Bool{
            self.explicit_lyrics = explicit_lyricsBool
        }
        if let previewString = representation.valueForKeyPath("preview") as? String{
            self.preview = NSURL(string: previewString)
        }
        if let artistObject = representation.valueForKeyPath("artist"){
            self.artist = Artist(response: response, representation: artistObject)
        }
        if let albumObject = representation.valueForKeyPath("album"){
            self.album = Album(response: response, representation: albumObject)
            
        }
        

    }
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Search] {
        var objects: [Search] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Search(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        
        return objects
    }
}