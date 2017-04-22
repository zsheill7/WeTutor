//
//  FollowUsTableViewController.swift
//  WeTutor
//
//  Created by Zoe on 4/9/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class FollowUsTableViewController: UITableViewController {
    let facebookUrlString = "https://www.facebook.com/WeTutor-1832581133659961/?ref=aymt_homepage_panel"
    let inFacebookUrlString = "fb://profile/1832581133659961"
    let twitterUrlString = "https://twitter.com/wetutorapp"
    let websiteUrlString = "https://www.wetutorapp.com"
    
    var facebookUrl: URL?
    var twitterUrl: URL?
    var websiteUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                break;
            case 1:
                self.openUrl(urlString: websiteUrlString)
            case 2:
                self.openUrl(urlString: facebookUrlString)
            case 3:
                self.openUrl(urlString: twitterUrlString)
            
            default:
                break;
        }
    }
    
    func openUrl(urlString: String) {
        print("in open url")
        if let url = URL(string: urlString) {
            print("succeeded")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            FIRAnalytics.logEvent(withName: "opened URL", parameters: [
                "succeeded" : false as NSObject,
                "urlString": urlString as NSObject
                ])
        }
    }
}
