//
//  Manager.swift
//  Deezer
//
//  Created by Dorian Cheignon on 04/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

//
//  DeezerManager.swift
//  SleepCompanion
//
//  Created by Dorian Cheignon on 09/07/2015.
//  Copyright (c) 2015 Holi. All rights reserved.
//

import Foundation
import Alamofire
let QUESTION_MARK = "?"
let EMPTY_STRING = ""
let HASHTAG = "#"
let SLASH = "/"
let AMPERSAND = "&"
let EQUALS = "="
protocol ManagerDelegate{
    
    func managerDidRetrievedToken()
    
}
let DeezerConnect = "connect.deezer.com"

class Manager: NSObject{
    
    var delegate:ManagerDelegate?
    var is_refresh:Bool = false
    var deezerClientID:String!
    var deezerRedirectURL:String!
    var deezerScope:String = "basic_access"
    var deezerClientSecret:String!
    class var sharedManager : Manager {
        struct Static {
            static let instance: Manager = Manager()
        }
        return Static.instance
    }
    
    func initialize(clientID ClientID:String,clientSecret ClientSecret:String,redirectURL RedirectURL:String){
        self.deezerClientID = ClientID
        self.deezerClientSecret = ClientSecret
        self.deezerRedirectURL = RedirectURL
    }
    func addPermissions(permissions Permissions:String){
        self.deezerScope = self.deezerScope + "," + Permissions
    }
    // check if session is valid
    // case 1 : we have a token valid so the session is valide
    // case 2 : we haven't a token so the session is not valid
    // case 3 : we have a token but is not valid so the session is not valid
    func isValidsession() -> Bool{
        
        
        if self.accessTokenDeezer() != nil {
            return true
        }else{
            return false
        }
    }
    func accessTokenDeezer()->String? {
        
        
        
        let encodedObject: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("accessToken_deezer")
        
        if let object: NSData = encodedObject as? NSData{
            if let at:AccessTokenDeezer = NSKeyedUnarchiver.unarchiveObjectWithData(object) as? AccessTokenDeezer{
                if at.isValid(){
                    return at.access_token
                }else{
                    self.is_refresh = true
                }
            }
        }
        return nil
        
    }
    
    func disconnect(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("accessToken_deezer")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    // it's request to get authorization code
    func authorizationURLDeezer()->String?{
        // the state is random string but this string have to be unique
        let DeezerState = "\(NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String)-\(NSDate().timeIntervalSince1970)"
        return "https://\(DeezerConnect)/oauth/auth.php?app_id=\(deezerClientID)&redirect_uri=\(deezerRedirectURL)&perms=\(deezerScope)&state=\(DeezerState)"
    }
    
    func tokenURLDeezer()->String?{
        return "https://\(DeezerConnect)/oauth/access_token.php?"
    }
    
    func authorizationCode(authorizationCode: String){
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(authorizationCode, forKey: "authorizationCode_deezer")
        userDefault.synchronize()
        self.exchangeCodeForTokenDeezer()
    }
    
    // it's function to create a token object
    func accessTokenDeezer(accessToken: String,withExpiration expiration:Double){
        
        let nat:AccessTokenDeezer = AccessTokenDeezer.tokenWithToken(accessToken, expiresIn: expiration)
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(nat)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(encodedObject, forKey: "accessToken_deezer")
        userDefault.synchronize()
        if self.is_refresh{
            self.is_refresh = false
            self.delegate?.managerDidRetrievedToken()
        }
        
        
    }
    // it's a request to get the first token
    func exchangeCodeForTokenDeezer(){
        if let authorizationCode: String =  NSUserDefaults.standardUserDefaults().valueForKey("authorizationCode_deezer") as? String{
            if let accessURL: String = self.tokenURLDeezer(){
                Alamofire.request(.GET,accessURL + "app_id=\(deezerClientID)&secret=\(deezerClientSecret)&code=\(authorizationCode)&output=json").responseJSON(completionHandler: { (response) -> Void in
                    if response.result.isSuccess{
                        if let access_token  = response.result.value?.valueForKeyPath("access_token") as? String{
                            if let expires  = response.result.value?.valueForKeyPath("expires") as? Double{
                                self.accessTokenDeezer(access_token, withExpiration: expires)
                            }
                        }
                    
                    }
                })
            }
        }
    }    
    
}

class AccessTokenDeezer: NSObject,NSCoding{
    
    var access_token:  String?
    var expires_in:  NSDate?
    //var refresh_token:  String?
    //var token_type: String?
    /**
    * Tells whether or not the token is valid.
    * = return TRUE if valid token. FALSE if invalid token.
    */
    func isValid()->Bool{
        
        if let _ = self.access_token{
            if let expires_in = self.expires_in{
                
                if expires_in.timeIntervalSince1970 > NSDate().timeIntervalSince1970{
                    return true
                }else{
                    return false
                }
            }
            return false
        }else{
            return false
        }
        
        
    }
    /**
     * Sets the token and expiration date.
     * = param token The token string.
     * = param expiration The amount of time (in seconds) the token has until it expires.
     */
    class func tokenWithToken(token : String,expiresIn expiration:Double)->AccessTokenDeezer{
        
        
        
        let accessToken:AccessTokenDeezer = AccessTokenDeezer()
        accessToken.access_token = token
        accessToken.expires_in = NSDate().dateByAddingTimeInterval(expiration)
        // accessToken.refresh_token = refresh
        //accessToken.token_type = type
        return accessToken
        
    }
    override init() {}
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.access_token, forKey: "access_token_deezer")
        aCoder.encodeObject(self.expires_in, forKey: "expires_in_deezer")
        // aCoder.encodeObject(self.refresh_token, forKey: "refresh_token_deezer")
        // aCoder.encodeObject(self.token_type, forKey: "token_type_deezer")
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let token:String = aDecoder.decodeObjectForKey("access_token_deezer") as? String{
            self.access_token = token
        }
        if let expiresIn:NSDate = aDecoder.decodeObjectForKey("expires_in_deezer") as? NSDate{
            self.expires_in = expiresIn
        }
        //        if let refreshToken:String = aDecoder.decodeObjectForKey("expires_in_deezer") as? String{
        //            self.refresh_token = refreshToken
        //        }
        //        if let token_type:String = aDecoder.decodeObjectForKey("token_type_deezer") as? String{
        //            self.token_type = token_type
        //        }
        
    }
}


final class DeezerSongObject:ResponseObjectSerializable,ResponseCollectionSerializable{
    
    var title:String?
    var album:String?
    var picture_small:String?
    var preview:String?
    
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        
        self.title = representation.valueForKeyPath("title") as? String
        self.album = representation.valueForKeyPath("album")!.valueForKeyPath("title") as? String
        self.picture_small = representation.valueForKeyPath("album")!.valueForKeyPath("cover_small") as? String
        self.preview = representation.valueForKeyPath("preview") as? String
        
        
    }
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [DeezerSongObject] {
        var objects: [DeezerSongObject] = []
        
        if let representations = representation as? [[String: AnyObject]] {
            for anRepresentation in representations {
                if let object = DeezerSongObject(response: response, representation: anRepresentation) {
                    objects.append(object)
                }
            }
        }
        
        return objects
    }
    
}
