//
//  User.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import Foundation
final class User:ResponseObjectSerializable,ResponseCollectionSerializable {

    var id:Int?//	The user's Deezer ID	int
    var name:String?//	The user's Deezer nickname	string
    var lastname:String?//	The user's last name	string
    var firstname:String?//	The user's first name	string
    var email:String?//	The user's email	string
    var status:Int?//	The user's status	int
    var birthday:NSDate?//	The user's birthday	date
    var inscription_date:NSDate?//	The user's inscription date	date
    var gender:String?//	The user's gender : F or M	string
    var link:NSURL?//	The url of the profil for the user on Deezer	url
    var picture:NSURL?//	The url of the user's profil picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big'	url
    var picture_small:NSURL?//	The url of the user's profil picture in size small.	url
    var picture_medium:NSURL?//	The url of the user's profil picture in size medium.	url
    var picture_big:NSURL?//	The url of the user's profil picture in size big.	url
    var country:String?//	The user's country	string
    var lang:String?//	The user's language	string
    var tracklist:NSURL?//	API Link to the flow of this user	url
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
    
        self.id = representation.valueForKeyPath("id") as? Int
        self.name = representation.valueForKeyPath("name") as? String
        self.lastname = representation.valueForKeyPath("lastname") as? String
        self.firstname = representation.valueForKeyPath("firstname") as? String
        self.email = representation.valueForKeyPath("email") as? String
        self.status = representation.valueForKeyPath("status") as? Int

        if let birthdayString = representation.valueForKeyPath("birthday") as? String{
            let dateFormatter =  NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            self.birthday = dateFormatter.dateFromString(birthdayString)
        }
        if let inscription_dateString = representation.valueForKeyPath("inscription_date") as? String{
            let dateFormatter =  NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            self.inscription_date = dateFormatter.dateFromString(inscription_dateString)
        }
        self.gender = representation.valueForKeyPath("gender") as? String
        if let linkString = representation.valueForKeyPath("link") as? String{
            self.link = NSURL(string: linkString)
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
        self.country = representation.valueForKeyPath("country") as? String
        self.lang = representation.valueForKeyPath("lang") as? String
        if let tracklistString = representation.valueForKeyPath("tracklist") as? String{
            self.tracklist = NSURL(string: tracklistString)
        }


    }
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [User] {
        var objects: [User] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = User(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        
        return objects
    }

}