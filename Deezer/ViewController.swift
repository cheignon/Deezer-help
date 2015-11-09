//
//  ViewController.swift
//  Deezer
//
//  Created by Dorian Cheignon on 04/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DeezerWebViewAuthControllerDelegate {

    var deezerAuthViewController:DeezerAuthViewController?
    @IBOutlet weak var connectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        0) Go to Deezer developers website: http://developers.deezer.com
//        1) Login with your standard Deezer account, and go to My App.
//        2) Create an application id for your project by clicking on "Create a new application" button
//        3) Fill in the app creation form and validate. You can edit your application later to add additional informations.
//        WARNING : redirect url must to be with this format : - http://wwww.domain.com
//                                                             - http://domain.com
//                                                             - http://localhost
        Manager.sharedManager.initialize(clientID: 	"YOUR APP ID", clientSecret: "YOUR SECRET CLIENT", redirectURL: "YOUR REDIRECT URL")

       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Manager.sharedManager.isValidsession(){
            self.performSegueWithIdentifier("authSuccessSegue", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func connectButtonDidTouched(sender:AnyObject){
        if let authUrl = Manager.sharedManager.authorizationURLDeezer(){
            self.deezerAuthViewController = DeezerAuthViewController().initWithURL(authUrl, delegate: self)
            self.presentViewController(self.deezerAuthViewController!, animated: true, completion: nil)
        }
        
    }
    func cancelDeezerButtonHit(sender: AnyObject) {
        self.deezerAuthViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func foundDeezerAuthorizationCode(authorizationCode: String) {
        self.deezerAuthViewController?.dismissViewControllerAnimated(true, completion: nil)
        Manager.sharedManager.authorizationCode(authorizationCode)
        self.performSegueWithIdentifier("authSuccessSegue", sender: self)
    }

}

