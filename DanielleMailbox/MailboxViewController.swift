//
//  MailboxViewController.swift
//  DanielleMailbox
//
//  Created by Simpson, Danielle on 9/1/16.
//  Copyright © 2016 Simpson, Danielle. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var myMessage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var laterIcon: UIButton!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var archiveIcon: UIButton!
    @IBOutlet var rescheduleTap: UITapGestureRecognizer!
    var edgeGesture: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet var tapContentView: UITapGestureRecognizer!
    @IBOutlet weak var contentView: UIView!
    var contentViewOpen: Bool!
    

    @IBOutlet weak var listOptions: UIImageView!
    @IBOutlet weak var myFeed: UIImageView!
    var initialCenter: CGPoint!
    var initialLater: CGPoint!
    var initialArchive: CGPoint!
    var initialContentCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

       scrollView.contentSize = CGSizeMake(320, 1350)
        messageParentView.backgroundColor = UIColorFromRGB(0xE1DEE2)
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = .Left
        contentView.addGestureRecognizer(edgeGesture)
        laterIcon.alpha = 0
        archiveIcon.alpha = 0
        contentViewOpen = false
        
    }
    
    //Function that allows me to use Hex Numbers for colors
    //for instance - white = UIColorFromRGB(0xFFFFFF)
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(messageParentView)
        
        if sender.state == UIGestureRecognizerState.Began {
            initialCenter = myMessage.center
            initialLater = laterIcon.center
            initialArchive = archiveIcon.center
            
        }
            
        else if sender.state == UIGestureRecognizerState.Changed {
            print("my message x is \(myMessage.center.x)")
            myMessage.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)

            archiveIcon.alpha = convertValue(translation.x, r1Min: 0, r1Max: 107, r2Min: 0, r2Max: 1)
            laterIcon.alpha = convertValue(-translation.x, r1Min: 0, r1Max: 107, r2Min: 0, r2Max: 1)
            
            //change background color of messageParentView based on myMessage location/translation
            
            if myMessage.center.x < 107 {
                
                //move myMessage to the left, make parent background yellow
                messageParentView.backgroundColor = UIColorFromRGB(0xFFE30D)
                
                //after 107, laterIcon should be 100% and start following myMessage
                laterIcon.alpha = 1
                laterIcon.center = CGPoint(x: initialLater.x + translation.x + 55, y: initialLater.y)
                
            }
            
            else if myMessage.center.x > 207{
                //move myMessage to the right, make parentbackground green
                messageParentView.backgroundColor = UIColorFromRGB(0x209624)
                
                //after 107, archiveIcon should be 100% and start following myMessage
                archiveIcon.alpha = 1
                archiveIcon.center = CGPoint(x: initialArchive.x + translation.x - 50, y: initialArchive.y)
            }
            else {
                //setting back to grey
                messageParentView.backgroundColor = UIColorFromRGB(0xE1DEE2)
            }
            
            
                
            //switch archive image to delete icon & bgd color
            if  myMessage.center.x > 400{
                archiveIcon.selected = true
                messageParentView.backgroundColor = UIColorFromRGB(0xDB213A)
            }
            
            //switch later icon to list icon and bgd color
            else if myMessage.center.x < -60 {
                laterIcon.selected = true
                messageParentView.backgroundColor = UIColorFromRGB(0xD48B17)
            }
                
            //change icons back to originals
            else {
                archiveIcon.selected = false
                laterIcon.selected = false
            }
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            
            //show list image
            if myMessage.center.x < -60 {
                UIView.animateWithDuration(0.1, animations: {
                    self.myMessage.center.x = -150
                    self.laterIcon.center.x = -100
                    }, completion: { (Bool) -> Void in
                        self.listOptions.alpha = 1
                })
            }
            //show rescheduled image
            else if myMessage.center.x < 15 {
                UIView.animateWithDuration(0.2, animations: {
                    self.myMessage.center.x = -150
                    self.laterIcon.center.x = -100
                }, completion: { (Bool) -> Void in
                    self.rescheduleImage.alpha = 1
                })
                
            
            
            }
            //delete/archive message
            else if myMessage.center.x > 250{
                
                UIView.animateWithDuration(0.5, animations: {
                    self.myMessage.center.x = 650
                    self.archiveIcon.center.x = 550
                    }, completion: { (Bool) -> Void in
                        self.myFeed.center.y = (self.myFeed.center.y - 86)
                        self.messageParentView.hidden = true
                        
                })
                scrollView.contentSize = CGSizeMake(320, 1250)
                
            }
            
            //set eveything back to where we started.
            else {
                UIView.animateWithDuration(0.2, animations: {
                    self.myMessage.center = self.initialCenter
                    self.laterIcon.center = self.initialLater
                    self.archiveIcon.center = self.initialArchive
                })
            }
            
            
        }
        
            }
    
    @IBAction func dismissReschedule(sender: AnyObject) {
        UIView.animateWithDuration(0.2) {
            self.myMessage.center = self.initialCenter
            self.laterIcon.center = self.initialLater
            self.rescheduleImage.alpha = 0
            
        }
    }
    
    @IBAction func dismissList(sender: AnyObject) {
        UIView.animateWithDuration(0.2) {
            self.myMessage.center = self.initialCenter
            self.laterIcon.center = self.initialLater
            self.listOptions.alpha = 0
        }
        
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer){

        let translation = sender.translationInView(contentView)
        let velocity = sender.velocityInView(contentView)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            initialContentCenter = contentView.center
            
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            
            contentView.center = CGPoint(x: initialContentCenter.x + translation.x, y: initialContentCenter.y)
        }
        
        else if sender.state == UIGestureRecognizerState.Ended {
            
            //if fast velocity or open halfway, finish opening
            if contentView.center.x > 285 || velocity.x > 200 {
                UIView.animateWithDuration(0.4, animations: {
                    self.contentView.center.x = 445
                    self.contentView.alpha = 0.75
                    self.contentViewOpen = true
                })
                
            }
            
            //if not, close menu
            else {
                UIView.animateWithDuration(0.4, animations: {
                self.contentView.center = self.initialContentCenter
                self.contentViewOpen = false
                    
                })
                
            }
        }
        
    }
    
    @IBAction func tapContentView(sender: AnyObject) {
        if contentViewOpen == true {
            UIView.animateWithDuration(0.4, animations: { 
                self.contentView.alpha = 1
                self.contentView.center = self.initialContentCenter
            })

        } 

    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.myFeed.center.y = (self.myFeed.center.y + 86)
            self.messageParentView.hidden = false
            self.myMessage.center = self.initialCenter
            self.laterIcon.center = self.initialLater
            self.archiveIcon.center = self.initialArchive
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
