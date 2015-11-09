//
//  Playlist.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
final class Playlist:ResponseObjectSerializable,ResponseCollectionSerializable {
    
    var id:Int?//	The playlist's Deezer id	int
    var title:String?//	The playlist's title	string
    var description:String?//	The playlist description	string
    var duration:Int?//	The playlist's duration (seconds)	int
    var is_loved_track:Bool = false//	If the playlist is the love tracks playlist	boolean
    var collaborative:Bool = false//	If the playlist is collaborative or not	boolean
    var rating:Int?//	The playlist's rate	int
    var unseen_track_count:Int?//	Nb tracks not seen	int
    var fans:Int?//	The number of playlist's fans	int
    var link:NSURL?//	The url of the playlist on Deezer	url
    var share:NSURL?//	The share link of the playlist on Deezer	url
    var picture:NSURL?//	The url of the playlist's cover. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'	url
    var picture_small:NSURL?//	The url of the playlist's cover in size small.	url
    var picture_medium:NSURL?//	The url of the playlist's cover in size medium.	url
    var picture_big:NSURL?//	The url of the playlist's cover in size big.	url
    var checksum:String?//	The checksum for the track list	string
    var creator:User?	//user object containing : id, name	object
    var tracks:[Track]?	//list of track	list
    var time_add:Double?//	The time when the track has been added to the playlist	timestamp
    //API Link to the tracklist of this album
    var tracklist:NSURL?
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        
        if let is_public = representation.valueForKeyPath("public") as? Bool{
            if is_public{
                self.id = representation.valueForKeyPath("id") as? Int
                
                self.title = representation.valueForKeyPath("title") as? String
                
                self.description = representation.valueForKeyPath("description") as? String
                
                self.duration = representation.valueForKeyPath("duration") as? Int
                if let is_loved_trackBool = representation.valueForKeyPath("is_loved_track") as? Bool{
                    self.is_loved_track = is_loved_trackBool
                }
                if let collaborativeBool = representation.valueForKeyPath("collaborative") as? Bool{
                    self.is_loved_track = collaborativeBool
                }
                
                self.rating = representation.valueForKeyPath("rating") as? Int
                
                self.unseen_track_count = representation.valueForKeyPath("unseen_track_count") as? Int
                self.fans = representation.valueForKeyPath("fans") as? Int
                
                if let linkString = representation.valueForKeyPath("link") as? String{
                    self.link = NSURL(string: linkString)
                }
                if let shareString = representation.valueForKeyPath("share") as? String{
                    self.share = NSURL(string: shareString)
                }
                
                if let pictureString = representation.valueForKeyPath("picture") as? String{
                    self.picture = NSURL(string: pictureString)
                }
                if let picture_smallString = representation.valueForKeyPath("picture_small") as? String{
                    self.picture_small = NSURL(string: picture_smallString)
                }
                if let picture_mediumString = representation.valueForKeyPath("picture_medium") as? String{
                    self.picture_medium = NSURL(string: picture_mediumString)
                }
                if let picture_bigString = representation.valueForKeyPath("picture_big") as? String{
                    self.picture_big = NSURL(string: picture_bigString)
                }
                self.checksum = representation.valueForKeyPath("checksum") as? String
                if let creatorObject = representation.valueForKeyPath("creator") {
                    self.creator = User(response: response, representation: creatorObject)
                }
                
                if let tracksListObject = representation.valueForKeyPath("tracks")?.valueForKeyPath("data"){
                    self.tracks = Track.collection(response: response, representation: tracksListObject)
                }
                self.time_add = representation.valueForKeyPath("time_add") as? Double
                if let tracklistString = representation.valueForKeyPath("tracklist") as? String{
                    self.tracklist = NSURL(string: tracklistString)
                }
            }
        }
        
    }
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Playlist] {
        var objects: [Playlist] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Playlist(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        
        return objects
    }
}