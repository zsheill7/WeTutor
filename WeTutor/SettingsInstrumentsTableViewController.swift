//
//  SettingsInstrumentsTableViewController.swift
//  ParseBandApp
//
//  Created by Zoe Sheill on 7/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Firebase

class SettingsInstrumentsTableViewController: UITableViewController {
    
    var user = FIRAuth.auth()?.currentUser
    var cellTag: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.concertInstTableView.reloadData()
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        /*if (cellTag == 1) {
            return marchingInstrumentsList.count
        } else if (cellTag == 2) {
            return concertInstrumentsList.count
        } else if (cellTag == 3) {
            return bandTypesList.count
        }*/
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        //print(concertInstrumentsList[indexPath.row])
        
       /* if (cellTag == 1) {
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
        
        cell.textLabel?.text = ""*/
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /*tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
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
        user!.saveInBackground()*/
        
    }

}
