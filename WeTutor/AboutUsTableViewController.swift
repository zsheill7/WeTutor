//
//  AboutUsTableViewController.swift
//  WeTutor
//
//  Created by Zoe on 4/7/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit
import MessageUI
import SCLAlertView
import FirebaseAuth

class AboutUsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var currentVersion: String = ""
    let currentLocale = NSLocale.current
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    var sendFeedbackString = ""
    
    var uidString = ""
    
    let shareString = "Check out WeTutor - it's an app that easily connects students and tutors! \n https://itunes.apple.com/us/app/wetutor/id1202611809 "
    var currentUser: User?
    
    
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : /*"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1"*/"itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.currentVersion = version
        }
        if uid != nil {
            uidString = uid!
        }
        self.sendFeedbackString = "\n\n\n\n\n\n\n\n\n--\nVersion: \(currentVersion)\nDevice: \(UIDevice.current.modelName)\nLocale: \(currentLocale)\nFirebase ID: \(uidString)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch (section, row) {
            case (0, 0):
                self.performSegue(withIdentifier: "toAboutUs", sender: self)
            case (0, 1):
                self.performSegue(withIdentifier: "toAcknowledgementsVC", sender: self)
            case (1, 0):
                self.rateApp(appId: "id1202611809", completion: { (success) in
                    print(success)
                })
                tableView.deselectRow(at: indexPath, animated: true)
            case (1, 1):
                self.shareApp()
                tableView.deselectRow(at: indexPath, animated: true)
            case (1, 2):
                self.performSegue(withIdentifier: "toFollowUsVC", sender: self)
            case (2, 0):
                sendFeedback()
            case (2, 1):
                contactUs()
            default:
                break;
            
        }
    }
    
    
    func shareApp() {
        let activity = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func sendFeedback() {
         let weTutorEmail = "info@wetutorapp.com"
        let zoeEmail = "zoe@wetutorapp.com"
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
                    mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([zoeEmail])
            mailComposerVC.setSubject("Feedback")
            mailComposerVC.setMessageBody(sendFeedbackString, isHTML: false)
            mailComposerVC.navigationBar.tintColor = UIColor.white

            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.displayAlert(title: "Send Feedback", message: "Feel free to send feedback to wetutorapp@gmail.com")
        }
    }
    
    func contactUs() {
         let weTutorEmail = "info@wetutorapp.com"
         if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients([weTutorEmail])
                mailComposerVC.setSubject("")
                mailComposerVC.setMessageBody("", isHTML: false)
                mailComposerVC.navigationBar.tintColor = UIColor.white
                self.present(mailComposerVC, animated: true, completion: nil)
         } else {
            self.displayAlert(title: "Contact Us", message: "Feel free to contact us at wetutorapp@gmail.com")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
