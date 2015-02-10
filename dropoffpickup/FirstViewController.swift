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

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kPickedUp: String = "PickedUp"
    let kDropedOff: String = "Droped Off"
    
    var objectArray: [PFObject]!
    var dateformatter: NSDateFormatter = NSDateFormatter()
    
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
            cell.textLabel?.text = objectArray[indexPath.row]["Status"] as NSString
        }
        
        
        dateformatter.dateFormat = "yy MMM dd, hh:mm"
        var updatedAtDateString = NSString(format: "%@", dateformatter.stringFromDate(objectArray[indexPath.row].updatedAt))
        cell.detailTextLabel?.text = (objectArray[indexPath.row])["By"] as NSString + " at \(updatedAtDateString)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Parse.enableLocalDatastore() = true
        Parse.setApplicationId("2oI2WegeaCJsyCwarThhHYyvVha0FcJQMO8H6ANf", clientKey: "eGoDAOxpo4mtqBDj3nV2OjyOGQ3QlNgTZrG9Utv1")
        
        var dateToday = NSDate()
        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MMM dd, yyyy, hh:mm" //Feb 05, 2015, 15:16
        var todaysDate =  NSString(format: "%@", dateFormat.stringFromDate(dateToday))
       
        self.objectArray = []
        
        var query = PFQuery(className:"DropOffPickUp")
        //query.whereKey("updatedAt", lessThanOrEqualTo:NSDate())
        //query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for object in objects as [PFObject]{
                    self.objectArray.append(object)
                }
                
                if (self.objectArray[0] as PFObject)["Status"] as NSString == self.kDropedOff {
                    self.btnDroppedOffPickedUp.titleLabel?.text = self.kPickedUp
                } else {
                    self.btnDroppedOffPickedUp.titleLabel?.text = self.kDropedOff
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            
            self.tableView.reloadData()
        }
        //ReloadData()

        
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
        var query = PFQuery(className:"DropOffPickUp")
        query.whereKey("updatedAt", lessThanOrEqualTo:NSDate())
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for object in objects as [PFObject]{
                    self.objectArray.append(object)
                }
                
                if (self.objectArray[0] as PFObject)["Status"] as NSString == self.kDropedOff {
                    self.btnDroppedOffPickedUp.titleLabel?.text = self.kPickedUp
                } else {
                    self.btnDroppedOffPickedUp.titleLabel?.text = self.kDropedOff
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
        
        var dropOffPickUp = PFObject(className:"DropOffPickUp")
        dropOffPickUp["By"] = currentUser["username"]
        dropOffPickUp["Time"] = datePicker.date
        dropOffPickUp["Status"] = droppedofforpickedup
        
        dropOffPickUp.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
}

