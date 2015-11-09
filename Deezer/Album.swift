//
//  Album.swift
//  Deezer
//
//  Created by Dorian Cheignon on 04/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
import Alamofire
final class Album:ResponseObjectSerializable,ResponseCollectionSerializable{
    
    // The Deezer album id
    var Id:Int?
    // The album title
    var title:String?
    // The album UPC
    var upc:String?
    //The url of the album on Deezer
    var link:NSURL?
    // The share link of the album on Deezer
    var share:NSURL?
    // The url of the album's cover. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
    var cover:NSURL?
    //The url of the album's cover in size small.
    var cover_small:NSURL?
    //The url of the album's cover in size medium.
    var cover_medium:NSURL?
    //The url of the album's cover in size big.
    var cover_big:NSURL?
    //The album's first genre id (You should use the genre list instead). NB : -1 for not found
    var genre_id:Int?
    //List of genre object
    var genres:[Genre]? 
    //The album's label name
    var label:String?
    //The number of tracks
    var nb_tracks:Int?
    //The album's duration (seconds)
    var duration:Int?
    //The number of album's Fans
    var fans: Int?
    //The album's rate
    var rating : Int?
    //The album's release date
    var release_date:NSDate?
    //The record type of the album (EP / ALBUM / etc..)
    var record_type:String?
    // bool is available
    var available:Bool = false
    //Return an alternative album object if the current album is not available
    var alternative:Album?
    //API Link to the tracklist of this album
    var tracklist:NSURL?
    //Whether the album contains explicit lyrics
    var explicit_lyrics:Bool = false
    
    
    var contributors:[Artist]?
    
    var artist:Artist?
    
    var tracks:[Track]?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
    
    
        self.Id = representation.valueForKeyPath("id") as? Int
        self.title = representation.valueForKeyPath("title") as? String
        self.upc = representation.valueForKeyPath("upc") as? String
        if let linkString = representation.valueForKeyPath("link") as? String{
            self.link = NSURL(string: linkString)
        }
        if let shareString = representation.valueForKeyPath("share") as? String{
            self.share = NSURL(string: shareString)
        }
        if let coverString = representation.valueForKeyPath("cover") as? String{
            self.cover = NSURL(string: coverString)
        }
        if let cover_smallString = representation.valueForKeyPath("cover_small") as? String{
            self.cover_small = NSURL(string: cover_smallString)
        }
         if let cover_mediumString = representation.valueForKeyPath("cover_medium") as? String{
            self.cover_medium = NSURL(string: cover_mediumString)
        }
        if let cover_mediumString = representation.valueForKeyPath("cover_medium") as? String{
            self.cover_medium = NSURL(string: cover_mediumString)
        }
        
        
        self.genre_id = representation.valueForKeyPath("genre_id") as? Int

        if let datasGenre = representation.valueForKeyPath("genres")?.valueForKeyPath("data"){
            self.genres = Genre.collection(response: response, representation: datasGenre)
        }

        self.label = representation.valueForKeyPath("label") as? String

        self.nb_tracks = representation.valueForKeyPath("nb_tracks") as? Int

        self.duration = representation.valueForKeyPath("duration") as? Int

        self.fans = representation.valueForKeyPath("fans") as? Int

        self.rating = representation.valueForKeyPath("rating") as? Int

        if let release_dateString = representation.valueForKeyPath("release_date") as? String{
            let dateFormatter =  NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            self.release_date = dateFormatter.dateFromString(release_dateString)
        }

        self.record_type = representation.valueForKeyPath("record_type") as? String

        if let availableBool = representation.valueForKeyPath("available") as? Bool{
            self.available = availableBool
        }

        if let datasAlternative = representation.valueForKeyPath("alternative"){
            self.alternative = Album(response: response, representation: datasAlternative)
        }

        if let tracklistString = representation.valueForKeyPath("tracklist") as? String{
            self.tracklist = NSURL(string: tracklistString)
        }

        if let explicit_lyricsBool = representation.valueForKeyPath("explicit_lyrics") as? Bool{
            self.explicit_lyrics = explicit_lyricsBool
            
        }
        if let contributorsList = representation.valueForKeyPath("contributors"){
            self.contributors = Artist.collection(response: response, representation: contributorsList)
        }
        if let artistObject = representation.valueForKeyPath("artist"){
            self.artist = Artist(response: response, representation: artistObject)
        }
        if let tracksListObject = representation.valueForKeyPath("tracks")?.valueForKeyPath("data"){
            self.tracks = Track.collection(response: response, representation: tracksListObject)
            
        }
        if self.tracks == nil{
            
            
            
            Alamofire.request(Method.GET, self.tracklist!.absoluteString).responseJSON { (response) -> Void in
                if response.result.isSuccess {
                    if  let data = response.result.value?.valueForKeyPath("data"){
                        self.tracks = Track.collection(response: response.response!, representation: data)
                    }
                }
                
                
                
            }
            
        }
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Album] {
        var objects: [Album] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Album(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        return objects
    }
    
}