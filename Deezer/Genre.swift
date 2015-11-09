//
//  Genre.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
final class Genre:ResponseObjectSerializable,ResponseCollectionSerializable {
    var id:Int?//	The editorial's Deezer id	int
    var name:String?//	The editorial's name	string
    var picture:NSURL?//	The url of the genre picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'	url
    var picture_small:NSURL?//	The url of the genre picture in size small.	url
    var picture_medium:NSURL?//	The url of the genre picture in size medium.	url
    var picture_big:NSURL?//	The url of the genre picture in size big.	url
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
    
        self.id = representation.valueForKeyPath("id") as? Int
        self.name = representation.valueForKeyPath("name") as? String
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
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Genre] {
        var objects: [Genre] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = Genre(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        
        return objects
    }
}