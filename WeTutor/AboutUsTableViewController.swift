//
//  AboutUsTableViewController.swift
//  WeTutor
//
//  Created by Zoe on 4/7/17.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import UIKit
import MessageUI

class AboutUsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        //controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }
    var currentUser: User?
    
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

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
    
    let sendFeedbackString = "\n\n\n\n\n\n\n\n\n--\nDevice"
    
    let shareString = "Check out WeTutor - it's an app that easily connects students and tutors! \n https://itunes.apple.com/us/app/wetutor/id1202611809 "
    
    func shareApp() {
        let activity = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func sendFeedback() {
        
        let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["wetutorapp@gmail.com"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody("", isHTML: false)
        mailComposerVC.navigationBar.tintColor = UIColor.white

        self.present(mailComposerVC, animated: true, completion: nil)
        
    }
    
    func contactUs() {
        let mailComposerVC = MFMailComposeViewController()
        //if mailComposerVC.canSendMail() {
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["wetutorapp@gmail.com"])
            mailComposerVC.setSubject("")
            mailComposerVC.setMessageBody("", isHTML: false)
            mailComposerVC.navigationBar.tintColor = UIColor.white
            self.present(mailComposerVC, animated: true, completion: nil)
       // }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
