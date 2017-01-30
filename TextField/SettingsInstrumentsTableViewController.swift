//
//  SettingsInstrumentsTableViewController.swift
//  ParseBandApp
//
//  Created by Zoe Sheill on 7/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SettingsInstrumentsTableViewController: UITableViewController {
    
    var user = PFUser.currentUser()
    var cellTag: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.concertInstTableView.reloadData()
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (cellTag == 1) {
            return marchingInstrumentsList.count
        } else if (cellTag == 2) {
            return concertInstrumentsList.count
        } else if (cellTag == 3) {
            return bandTypesList.count
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        //print(concertInstrumentsList[indexPath.row])
        
        if (cellTag == 1) {
            cell.textLabel?.text = String(marchingInstrumentsList[indexPath.row])
            return cell
        }
        else if (cellTag == 2) {
            cell.textLabel?.text = String(concertInstrumentsList[indexPath.row])
            return cell
        } else if (cellTag == 3) {
            cell.textLabel?.text = String(bandTypesList[indexPath.row])
            return cell
        }
        
        cell.textLabel?.text = ""
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let cellText:String = currentCell.textLabel!.text!
        
        if (cellTag == 1) {
            
            
            user!.setObject(cellText, forKey: "marchingInstrument")
            
            //print(currentCell.textLabel!.text!)
        }
        else if (cellTag == 2) {
            
            user!.setObject(cellText, forKey: "concertInstrument")
            
        }
        else if (cellTag == 3) {
            user!.setObject(cellText, forKey: "ensemble")
        }
        user!.saveInBackground()
        
    }

}
