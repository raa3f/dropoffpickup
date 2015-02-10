//
//  SecondViewController.swift
//  dropoffpickup
//
//  Created by Raaef Khan on 5/02/2015.
//  Copyright (c) 2015 Raaef Khan. All rights reserved.
//

import UIKit
import Parse

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var objectArray: [PFObject]!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: DropedOffPickedUpTableViewCell = tableView.dequeueReusableCellWithIdentifier("DropedOffPickedUpTableViewCell") as DropedOffPickedUpTableViewCell
        dateformatter.dateFormat = kDateFormatString
        cell.droppedOffBy.text = objectArray[indexPath.row][kTableField_By] as NSString
        cell.droppedOffAt.text = NSString(format: "%@", dateformatter.stringFromDate(objectArray[indexPath.row][kTableField_Time] as NSDate))
        
        cell.pickedUpBy.text = objectArray[indexPath.row+1][kTableField_By] as NSString
        cell.pickedUpAt.text = NSString(format: "%@", dateformatter.stringFromDate(objectArray[indexPath.row+1][kTableField_Time] as NSDate))
            
        cell.totalTime.text = "total will be displayed here" as NSString
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Parse.setApplicationId("2oI2WegeaCJsyCwarThhHYyvVha0FcJQMO8H6ANf", clientKey: "eGoDAOxpo4mtqBDj3nV2OjyOGQ3QlNgTZrG9Utv1")
        // Do any additional setup after loading the view, typically from a nib.
        self.objectArray = []
        var query = PFQuery(className: kDropOffPickUpTableName)
        query.addDescendingOrder(kUpdatedAt)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for object in objects as [PFObject]{
                    self.objectArray.append(object)
                }
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

