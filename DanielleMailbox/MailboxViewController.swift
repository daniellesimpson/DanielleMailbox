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
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var archiveIcon: UIButton!
    @IBOutlet var rescheduleTap: UITapGestureRecognizer!
    var edgeGesture: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet var tapContentView: UITapGestureRecognizer!
    @IBOutlet weak var contentView: UIView!
    var contentViewOpen: Bool!
    
    var initialCenter: CGPoint!
    var initialLater: CGPoint!
    var initialArchive: CGPoint!
    var initialContentCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

       scrollView.contentSize = CGSizeMake(320, 1500)
        messageParentView.backgroundColor = UIColorFromRGB(0xE1DEE2)
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = .Left
        contentView.addGestureRecognizer(edgeGesture)
        laterIcon.alpha = 0
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        print("🍸🍸🍸🍸🍸🍸🍸")
        
        
        print("alpha is \(laterIcon.alpha)")
        
        let location = sender.locationInView(messageParentView)
        let translation = sender.translationInView(messageParentView)
        let velocity = sender.velocityInView(messageParentView)
//        print("Your location is:\(location)")
//        print("Your translation is:\(translation)")
//        print("Your velocity is:\(velocity)")
        
        //var tx = convertValue(offset, r1Min: 0, r1Max: 255, r2Min:Grey, r2Max: END_COLOR)
        var xOffset = CGFloat(translation.x)
        
       
    
        
        
        if sender.state == UIGestureRecognizerState.Began {
            initialCenter = myMessage.center
            initialLater = laterIcon.center
            initialArchive = archiveIcon.center
            
        }
            
        else if sender.state == UIGestureRecognizerState.Changed {
            myMessage.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
            laterIcon.center = CGPoint(x: initialLater.x + translation.x + 25, y: initialLater.y)
            archiveIcon.center = CGPoint(x: initialArchive.x + translation.x - 25, y: initialArchive.y)
            
            
            print("Your translation is:\(translation.x)")
            
            print("translation divided is \(-(translation.x / 100))")
            laterIcon.alpha = -(translation.x / 100)
            
            //changing colors based on myMessage.x
            
            if myMessage.center.x < 107 {
                //right side - later - yellow background
                messageParentView.backgroundColor = UIColorFromRGB(0xFFE30D)
                laterIcon.alpha = 1
                
            }
            
            else if myMessage.center.x > 207{
                messageParentView.backgroundColor = UIColorFromRGB(0x209624)
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
            
            //change delete icon back to archive
            else {
                archiveIcon.selected = false
            }
            
           
            
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            
            //show reschedule image
            if myMessage.center.x < -85 {
                rescheduleImage.alpha = 1
            }
            
            myMessage.center = initialCenter
            laterIcon.center = initialLater
            archiveIcon.center = initialArchive
        }
        
            }
    
    @IBAction func dismissReschedule(sender: AnyObject) {
        rescheduleImage.alpha = 0
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer){
        //print("🌲🌲🌲🌲🌲🌲🌲🌲🌲🌲🌲🌲🌲")
        let translation = sender.translationInView(contentView)
        let location = sender.locationInView(contentView)
        let velocity = sender.velocityInView(contentView)
        var xOffset = CGFloat(translation.x)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            initialContentCenter = contentView.center
            
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            contentView.center = CGPoint(x: initialContentCenter.x + translation.x, y: initialContentCenter.y)
            if velocity.x > 200 {
                print("Open 🤓🤓🤓🤓🤓🤓")
            }
            else {
                print("ignore 😷😷😷😷😷😷")
            }
            print("velocity Before \(velocity)")
        }
        
        else if sender.state == UIGestureRecognizerState.Ended {
            
            print("velocity after \(velocity)")
            
            //if fast velocity or open halfway, finish opening
            if contentView.center.x > 285 || velocity.x > 400 {
                contentView.center.x = 445
                contentView.alpha = 0.75
                contentViewOpen = true
                
            }
            
            //if not, close menu
            else {
                print("snap back")
                contentView.center = initialContentCenter
                contentViewOpen = false
                
            }
        }
        
    }
    
    @IBAction func tapContentView(sender: AnyObject) {
        if contentViewOpen == true {
            //contentView.center.x = 0
            contentView.alpha = 1
            print("opened")
            contentView.center = initialContentCenter

        }
        
        else {
            print("closed")
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
