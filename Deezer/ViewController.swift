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
        Manager.sharedManager.initialize(clientID: 	"167085", clientSecret: "6ed68e8cd0e00c03ea9aa1cfc7ace6ea", redirectURL: "http://framework.com")

       
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

