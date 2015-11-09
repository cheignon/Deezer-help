//
//  DeezerAuthViewController.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import UIKit
protocol DeezerWebViewAuthControllerDelegate{
    
    func cancelDeezerButtonHit(sender:AnyObject)
    func foundDeezerAuthorizationCode(authorizationCode:String)
    
}
class DeezerAuthViewController: UIViewController,UIWebViewDelegate {

    var delegate:DeezerWebViewAuthControllerDelegate?
    var authURL:String?
    var webView: UIWebView?
    func initWithURL(URL:String,delegate:DeezerWebViewAuthControllerDelegate)->Self{
        
        self.authURL = URL
        self.delegate = delegate
        return self
        
    }
    
    override func loadView() {
        
        super.loadView()
                self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        let navBar:UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 64))
        self.view.addSubview(navBar)
        
        let bbi: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        let navItem:UINavigationItem = UINavigationItem(title: "Connect with Deezer")
        navItem.leftBarButtonItem = bbi
        navBar.pushNavigationItem(navItem, animated: true)
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 64, width: UIScreen.mainScreen().bounds.size.width,height: UIScreen.mainScreen().bounds.size.height-64))
        self.webView?.backgroundColor = UIColor(red: 55/255, green: 50/255, blue: 61/255, alpha: 1)
        self.webView?.delegate = self
        self.view.addSubview(self.webView!)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Connect With Deezer"
        self.loadAuthURL()
    }
    
    func loadAuthURL(){
        
        
        let request:NSURLRequest = NSURLRequest(URL: NSURL( string:self.authURL!)!)
        self.webView?.loadRequest(request)
    }
    
    func cancel(sender:UIButton){
        
        
        self.delegate?.cancelDeezerButtonHit(sender)
    }
    
    // MARK: - Deezer UIWebView Delegate Methods
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    // we check all url from web view if url contain a callback url with authorization code, then we send code to get token
    // from Deezer api
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        if let url : NSURL = request.URL{
            print(url)
            if let redirectURL: NSURL =  NSURL(string: Manager.sharedManager.deezerRedirectURL){
            if url.host != nil{
                if url.host!.isEqual(redirectURL.host){
                    // it's parser for url to get only authorization code
                    var  urlResources:String = url.resourceSpecifier
                    urlResources = urlResources.stringByReplacingOccurrencesOfString(QUESTION_MARK, withString:EMPTY_STRING, options: NSStringCompareOptions.LiteralSearch, range: nil)
                    urlResources = urlResources.stringByReplacingOccurrencesOfString(HASHTAG, withString:EMPTY_STRING, options: NSStringCompareOptions.LiteralSearch, range: nil)
                    var urlResourcesArray = urlResources.componentsSeparatedByString(SLASH)
                    let urlParamaters = urlResourcesArray[urlResourcesArray.count-1]
                    let urlParamatersArray = urlParamaters.componentsSeparatedByString(AMPERSAND)
                    let keyValue = urlParamatersArray.first
                    let keyValueArray: NSArray = keyValue!.componentsSeparatedByString(EQUALS)
                    // end of parser
                    if keyValueArray.objectAtIndex(0).isEqual("code"){
                        self.delegate?.foundDeezerAuthorizationCode(keyValueArray.objectAtIndex(1) as! String)
                    }
                    return false
                }
                
            }
        }
        }
        return true
    }
}
