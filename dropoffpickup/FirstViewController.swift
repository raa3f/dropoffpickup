//
//  FirstViewController.swift
//  dropoffpickup
//
//  Created by Raaef Khan on 5/02/2015.
//  Copyright (c) 2015 Raaef Khan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

let kPickedUp: String = "Picked Up"
let kDropedOff: String = "Droped Off"
let kUpdatedAt: String = "updatedAt"
let kDateFormatString: String = "hh:mm MMM dd"
let kDropOffPickUpTableName: String = "DropOffPickUp"

let kTableField_By: String = "By"
let kTableField_Status: String = "Status"
let kTableField_Time: String = "Time"
let kTableField_Username: String = "username"

var dateformatter: NSDateFormatter = NSDateFormatter()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var objectArray: [PFObject]!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDroppedOffPickedUp: UIButton!
    
    @IBAction func DroppedOffOrPickedUp(sender: AnyObject) {
        
        if btnDroppedOffPickedUp.titleLabel!.text == kDropedOff {
            DroppedOff(true)
        } else {
            DroppedOff(false)
        }
        
        toggleDropOffPickup()
        
         self.tableView.reloadData()
    }
    
    func toggleDropOffPickup() -> String {
        if btnDroppedOffPickedUp.titleLabel!.text == kDropedOff {
            btnDroppedOffPickedUp.setTitle(kPickedUp, forState: .Normal)
        } else {
            btnDroppedOffPickedUp.setTitle(kDropedOff, forState: .Normal)
        }
        
        return btnDroppedOffPickedUp.titleLabel!.text!
    }
    
   /* func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return  2
    } */
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        switch(section){
//        case 0: return "Section 0"
//        case 1: return "Section 1"
//        case 2: return "Section 1"
//        default: return "default header title"
//        }
//        
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objectArray == nil {
            return 0
        }
        return objectArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        if (objectArray==nil) {
            cell.textLabel?.text = "No record found"
        }else{
            cell.textLabel?.text = objectArray[indexPath.row][kTableField_Status] as NSString
        }
        
        dateformatter.dateFormat = kDateFormatString
        var updatedAtDateString = NSString(format: "%@", dateformatter.stringFromDate(objectArray[indexPath.row].updatedAt))
        cell.detailTextLabel?.text = (objectArray[indexPath.row])[kTableField_By] as NSString + " at \(updatedAtDateString)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Parse.enableLocalDatastore() = true
        Parse.setApplicationId("2oI2WegeaCJsyCwarThhHYyvVha0FcJQMO8H6ANf", clientKey: "eGoDAOxpo4mtqBDj3nV2OjyOGQ3QlNgTZrG9Utv1")
        
        ReloadData()
 
    }

    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            var modelLogin = PFLogInViewController()
            self.presentViewController(modelLogin, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func ReloadData(){
        self.objectArray = []
        var query = PFQuery(className:kDropOffPickUpTableName)
        query.whereKey(kUpdatedAt, lessThanOrEqualTo:NSDate())
        query.orderByDescending(kUpdatedAt)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for object in objects as [PFObject]{
                    self.objectArray.append(object)
                }
                
                if (self.objectArray[0] as PFObject)[kTableField_Status] as NSString == kDropedOff {
                    self.btnDroppedOffPickedUp.titleLabel?.text = kPickedUp
                } else {
                    self.btnDroppedOffPickedUp.titleLabel?.text = kDropedOff
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func DroppedOff(status: Bool){
        var droppedofforpickedup = kDropedOff
        
        if !status {
            droppedofforpickedup = kPickedUp
        }
        
        var currentUser = PFUser.currentUser()
        if (currentUser==nil){
            
        }
        
        var dropOffPickUp = PFObject(className:kDropOffPickUpTableName)
        dropOffPickUp[kTableField_By] = currentUser[kTableField_Username]
        dropOffPickUp[kTableField_Time] = datePicker.date
        dropOffPickUp[kTableField_Status] = droppedofforpickedup
        
        dropOffPickUp.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                // The object has been saved.
                self.ReloadData()
            } else {
                // There was a problem, check error.description
            }
        }
    }
}

