//
//  Track.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
class Track{
    
    var id:Int?	//The track's Deezer id	int
    var readable:Bool = false	//true if the track is readable in the player for the current user	boolean
    var title:String?	//The track's fulltitle	string
    var title_short:String?	//The track's short title	string
    var title_version:String?	//The track version	string
    var unseen:Bool = false	//The track unseen status	boolean
    var isrc:String?	//The track isrc	string
    var link:NSURL?	//The url of the track on Deezer	url
    var share:NSURL?	//The share link of the track on Deezer	url
    var duration:Int?	//The track's duration in seconds	int
    var track_position:Int?	//The position of the track in its album	int
    var disk_number:Int?	//The track's album's disk number	int
    var rank:Int?	//The track's Deezer rank	int
    var release_date:NSDate?	//the track's release date	date
    var explicit_lyrics:Bool = false	//Whether the track contains explicit lyrics	boolean
    var preview:NSURL?	//The url of track's preview file. This file contains the first 30 seconds of the track	url
    var bpm:Float?//Beats per minute	float
    var gain:Float?	//Signal strength	float
    var available_countries:[String]?//	List of countries where the track is available	list
    var alternative:Track?//Return an alternative readable track if the current track is not readable	track
    var contributors:[Artist]?//	Return a list of contributors on the track	list
    var artist:Artist?
    var album:Album?	//album object containing : id, title, link, cover, cover_small, cover_medium, cover_big, release_date	object
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        
        self.id = representation.valueForKeyPath("id") as? Int
        if let readableBool = representation.valueForKeyPath("readable") as? Bool{
            self.readable = readableBool
        }
        self.title = representation.valueForKeyPath("title") as? String
        self.title_short = representation.valueForKeyPath("title_short") as? String
        self.title_version = representation.valueForKeyPath("title_version") as? String
        if let unseenBool = representation.valueForKeyPath("unseen") as? Bool{
            self.unseen = unseenBool
        }
        self.isrc = representation.valueForKeyPath("isrc") as? String
        if let linkString = representation.valueForKeyPath("link") as? String{
            self.link = NSURL(string: linkString)
        }
        if let shareString = representation.valueForKeyPath("share") as? String{
            self.share = NSURL(string: shareString)
        }
        self.duration = representation.valueForKeyPath("duration") as? Int
        self.track_position = representation.valueForKeyPath("track_position") as? Int
        self.disk_number = representation.valueForKeyPath("disk_number") as? Int
        self.rank = representation.valueForKeyPath("rank") as? Int
        if let release_dateString = representation.valueForKeyPath("release_date") as? String{
            let dateFormatter =  NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            self.release_date = dateFormatter.dateFromString(release_dateString)
        }
        if let explicit_lyricsBool = representation.valueForKeyPath("explicit_lyrics") as? Bool{
            self.explicit_lyrics = explicit_lyricsBool
        }
        if let previewString = representation.valueForKeyPath("preview") as? String{
            self.preview = NSURL(string: previewString)
        }
        self.bpm = representation.valueForKeyPath("bpm") as? Float
        self.gain = representation.valueForKeyPath("gain") as? Float
        if let available_countriesListString = representation.valueForKeyPath("available_countries") as? [String]{
            self.available_countries = available_countriesListString
        }
        if let alternativeTrack = representation.valueForKeyPath("alternative"){
            self.alternative = Track(response: response, representation: alternativeTrack)
        }
        if let contributorsList = representation.valueForKeyPath("contributors"){
            self.contributors = Artist.collection(response: response, representation: contributorsList)
        }
        if let artistObject = representation.valueForKeyPath("artist"){
            self.artist = Artist(response: response, representation: artistObject)
        }
        if let albumObject = representation.valueForKeyPath("album"){
            self.album = Album(response: response, representation: albumObject)
        }

    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Track] {
        var objects: [Track] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Track(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        return objects
    }
    
}