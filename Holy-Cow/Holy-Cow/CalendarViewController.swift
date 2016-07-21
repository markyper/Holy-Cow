//
//  CalendarViewController.swift
//  Holy-Cow
//
//  Created by Nadia Jamrozik on 7/18/16.
//  Copyright © 2016 Nadia Jamrozik. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarBoard: UIView!
    @IBOutlet weak var calendarViewLabel: UIView!
    
    let today = NSDate()
    let dateFormatterYear = NSDateFormatter()
    let dateFormatterMonth = NSDateFormatter()
    let dateFormatterDay = NSDateFormatter()
    let dateFormatterOverall = NSDateFormatter()
    let dateComponents = NSDateComponents()
    
    var calendarArray = [String](count: 42, repeatedValue: "")
    
    var dayOfMonth:Int?
    
    var calendarController = CalendarController()
    
    var dayOfWeek:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabelColorsAndFonts()
        
        
        calendarController.populate()
        
        //setting title to current month
        dateFormatterOverall.dateFormat = "MMM yyyy"
        monthLabel.text = dateFormatterOverall.stringFromDate(today)
        
        //getting current day and month
        dateFormatterYear.dateFormat = "YYYY"
        dateFormatterMonth.dateFormat = "MM"
        dateFormatterDay.dateFormat = "dd"
        let year = Int(dateFormatterYear.stringFromDate(today))
        let month = Int(dateFormatterMonth.stringFromDate(today))
        dayOfMonth = Int(dateFormatterDay.stringFromDate(today))
        let dateComponents = NSDateComponents()
        dateComponents.year = year!
        dateComponents.month = month!
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateFromComponents(dateComponents)!
        
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        let calendarDays:Int = range.length
        
        let startOfMonth = calendar.dateFromComponents(dateComponents)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startDateComponents = myCalendar.components(.Weekday, fromDate: startOfMonth)
        dayOfWeek = startDateComponents.weekday - 1
        
        
        //array containing items 1 through days in current month
        var monthArray: [String] = []
        var firstNum = 1
        while firstNum <= calendarDays {
            monthArray.append("\(firstNum)")
            firstNum += 1
        }
        
        calendarArray[dayOfWeek!...calendarDays] = monthArray[0..<monthArray.count]
        
        for calendarCell in calendarBoard.subviews {
            for button in calendarCell.subviews as! [UIButton] {
                calendarCell.backgroundColor = UIColor.whiteColor()
                button.setTitle("\(calendarArray[button.tag])", forState: .Normal)
                button.setTitleColor(UIColor.holyBlack, forState: .Normal)
                
                //improve runtime??? INCREMENTING INDEX
                if calendarController.dummyChallenge.contains(button.tag) {
                    button.setBackgroundImage(UIImage(named: "GreyRing"), forState: .Normal)
                }
                
                //disabling button tap for inexistent calendar days
                if calendarArray[button.tag] == "" {
                    button.enabled = false
                    button.setBackgroundImage(nil, forState: .Normal)
                }
                
                if button.tag <= dayOfMonth! + (self.dayOfWeek! - 1) {
                    if calendarController.goalArray[button.tag] == DayGoal.Meat{
                        button.enabled = false
                    }
                }

                //setting current day label to blue color
                if dayOfMonth! ==  (button.tag - dayOfWeek! + 1) {
                    button.setTitleColor(UIColor.holyBlue, forState: .Normal)
                }
                
            }
        }
    }


    func setupLabelColorsAndFonts() {
        
        //setting text and font colors
        monthLabel.textColor = UIColor.holyGreen
        monthLabel.font = UIFont(name: "GTWalsheimProTrial-Medium", size: 18.0)
        
        
        //setting day label colors
        for subview in daysView.subviews {
            if let dayLabel = subview as? UITextField {
                dayLabel.textColor = UIColor.holyGrey
                dayLabel.font = UIFont(name: "GTWalsheimProTrial-Regular", size: 15)
            }
        }
    }
    
    
    @IBAction func calendarCellTapped(sender: UIButton) {
        
        if sender.tag <= dayOfMonth! + (self.dayOfWeek! - 1) {
            
            if calendarController.goalArray[sender.tag] == DayGoal.Meatless {
           
                if calendarController.outcomeArray[sender.tag] == DayOutcome.Unset {
                    calendarController.outcomeArray[sender.tag] = .Success
                    sender.setBackgroundImage(UIImage(named: "GreenCircle"), forState: .Normal)
                    
                }
                else if calendarController.outcomeArray[sender.tag] == DayOutcome.Success {
                    calendarController.outcomeArray[sender.tag] = .Failure
                    sender.setBackgroundImage(UIImage(named: "RedCircle"), forState: .Normal) // maybe add later?
                }
                else {
                    calendarController.outcomeArray[sender.tag] = .Unset
                    sender.setBackgroundImage(UIImage(named: "GreyRing"), forState: .Normal)
                }
            }
        }

        if sender.tag > dayOfMonth! + (self.dayOfWeek! - 1) {
            if calendarController.goalArray[sender.tag] == DayGoal.Meat {
                calendarController.goalArray[sender.tag] = .Meatless
                sender.setBackgroundImage(UIImage(named: "GreyRing"), forState: .Normal)
                
            } else {
                calendarController.goalArray[sender.tag] = .Meat
                sender.setBackgroundImage(nil, forState: .Normal)
            }
            
        }

        //total goal of meatless days
        var goalMeatless = calendarController.tallyGoal()
        print("TALLY GOAL = \(goalMeatless)")
        
        //total successful meatless days
//        var successMeatless = calendarController.tallyOutcome()
//        print("TALLY SUCCESS = \(successMeatless)")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var successMeatless = calendarController.tallyOutcome()
        let destination = segue.destinationViewController as! ProfileViewController
        destination.meatNumber = successMeatless
    }

}
