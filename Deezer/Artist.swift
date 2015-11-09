//
//  Artist.swift
//  Deezer
//
//  Created by Dorian Cheignon on 04/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
import Alamofire

final class Artist:ResponseObjectSerializable,ResponseCollectionSerializable{

    
    
    var Id:Int?
    var name:String?
    //The url of the artist on Deezer
    var link:NSURL?
    //The share link of the artist on Deezer
    var share:NSURL?
    //The url of the artist picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'
    var picture:NSURL?
    //The url of the artist picture in size small.
    var picture_small:NSURL?
    //The url of the artist picture in size medium.
    var picture_medium:NSURL?
    //The url of the artist picture in size big.
    var picture_big:NSURL?
    //The url of the artist on Deezer
    var tracklist:NSURL?
    //The number of artist's fans
    var nb_fan:Int?
    //	The number of artist's albums
    var nb_album:Int?
    //true if the artist has a smartradio
    var radio:Bool = false
    
    

    init?(response: NSHTTPURLResponse, representation: AnyObject) {
    
    
        self.Id = representation.valueForKeyPath("id") as? Int
        self.name = representation.valueForKeyPath("name") as? String
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
        if let tracklistString = representation.valueForKeyPath("tracklist") as? String{
            self.tracklist = NSURL(string: tracklistString)
        }
        
        self.nb_fan = representation.valueForKeyPath("nb_fan") as? Int
        self.nb_album = representation.valueForKeyPath("nb_album") as? Int
        if let radioBool = representation.valueForKeyPath("radio") as? Bool{
            self.radio = radioBool
        }
        
        

    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Artist] {
        var objects: [Artist] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Artist(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        return objects
    }
}