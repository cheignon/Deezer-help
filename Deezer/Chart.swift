//
//  Chart.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
final class Chart:ResponseObjectSerializable,ResponseCollectionSerializable{

    
    
    var tracks:[Track]?	//list of track
    var id: Int?//	The track's Deezer id	int
    var title:String?//	The track's fulltitle	string
    var title_short:String? //	The track's short title	string
    var title_version:String?//	The track version	string
    var link:NSURL?//	The url of the track on Deezer	url
    var duration:Int?	//The track's duration in seconds	int
    var rank:Int?//	The track's Deezer rank	int
    var explicit_lyrics:Bool = false//	Whether the track contains explicit lyrics	boolean
    var preview:NSURL?//	The url of track's preview file. This file contains the first 30 seconds of the track	url
    var position:Int?	//The position of the track in the charts	int
    var artists:[Artist]?//	artist object containing : id, name, link, picture, picture_small, picture_medium, picture_big, radio	object
    var albums:[Album]?//	list of album	list
    var user:User?	//user object containing : id, name	object
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        
        if let tracksListObject = representation.valueForKeyPath("tracks")?.valueForKeyPath("data"){
            self.tracks = Track.collection(response: response, representation: tracksListObject)
        }
        self.id = representation.valueForKeyPath("id") as? Int
    
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
        self.position = representation.valueForKeyPath("position") as? Int

        if let artistListObject = representation.valueForKeyPath("artists")?.valueForKeyPath("data"){
            self.artists = Artist.collection(response: response, representation: artistListObject)
        }
        if let albumListObject = representation.valueForKeyPath("album")?.valueForKeyPath("data"){
            self.albums = Album.collection(response: response, representation: albumListObject)
        }

    }
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Chart] {
        var objects: [Chart] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Chart(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        return objects
    }

}