//
//  ViewController.swift
//  iSpy
//
//  Created by brett davis on 9/20/14.
//  Copyright (c) 2014 brett davis. All rights reserved.
//

import UIKit
import CoreMotion


    //number formatter
    extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

class ViewController: UIViewController {
    
    // instance variables
    let motionManager: CMMotionManager = CMMotionManager()
    var motionQueue = NSOperationQueue()
    var gyroQueue = NSOperationQueue()
    var check: Bool = false
    var sample:[Node] = [Node]()
   
    // temp labels on app to display #s on screen
    @IBOutlet weak var accelerometerX: UILabel!
    @IBOutlet weak var accelerometerY: UILabel!
    @IBOutlet weak var accelerometerZ: UILabel!
    @IBOutlet weak var gyroX: UILabel!
    @IBOutlet weak var gyroY: UILabel!
    @IBOutlet weak var gyroZ: UILabel!
    @IBOutlet weak var collectButton: UIButton!
    
    // function that gets called when button is pressed
    @IBAction func toggle(sender: AnyObject) {
        // tomfoolery I had to do to get this to work with single button
        self.check = !(self.check)
        if( self.check == true){
            collectButton.setTitle("Stop Collecting", forState: UIControlState.Normal)
            collectData()
        }
        else{
            collectButton.setTitle("Start Collecting", forState: UIControlState.Normal)
            stopCollecting()
        }
        
    }
    
    func collectData(){
        // units are seconds so 1/30 = 30x a second
        let precision = ".04"
        self.motionManager.deviceMotionUpdateInterval = 1/6
        //self.motionManager.gyroUpdateInterval = 1/5
        
        
        if(self.motionManager.deviceMotionAvailable){
            self.motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXArbitraryCorrectedZVertical, toQueue: motionQueue, withHandler: {(motionData:CMDeviceMotion!,error:NSError!) in

                dispatch_async(dispatch_get_main_queue()) {
                    
                        if(self.motionManager.deviceMotion != nil){
                            let node:Node = Node(ax: motionData.userAcceleration.x.format(precision),ay: motionData.userAcceleration.y.format(precision),az: motionData.userAcceleration.z.format(precision),gx: motionData.rotationRate.x.format(precision),gy: motionData.rotationRate.y.format(precision),gz: motionData.rotationRate.z.format(precision))
                            
                            self.sample.append(node)
                            
                            if(self.sample.count == 20){
                                self.sendSample()
                            }
                            self.accelerometerX.text = "\(motionData.userAcceleration.x.format(precision))"
                            self.accelerometerY.text = "\(motionData.userAcceleration.y.format(precision))"
                            self.accelerometerZ.text = "\(motionData.userAcceleration.z.format(precision))"
                            self.gyroX.text = "\(motionData.rotationRate.x.format(precision))"
                            self.gyroY.text = "\(motionData.rotationRate.y.format(precision))"
                            self.gyroZ.text = "\(motionData.rotationRate.z.format(precision))"
                            
                            
                         //   println("Accelerometer x: \(motionData.userAcceleration.x) y: \(motionData.userAcceleration.y) z: \(motionData.userAcceleration.z)Time: \(self.getTimestamp())")
                            
                         
                        }
                
                }
            })
        }
    }
    
    
    func stopCollecting() {
        self.motionManager.stopDeviceMotionUpdates()
        self.sample.removeAll()
    }
    
    func getTimestamp() -> String {
        return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .LongStyle)
    }
    
    func sendSample(){
        var temp:String = String()
        for(var i = 0; i < 20; i++){
            temp += self.sample[i].ToString()
            if(i != 19){
                temp += ","
            }
        }
        
        println(temp)
        self.sample.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Dispose of any resources that can be recreated.
        self.collectButton.setTitle("Start Collecting", forState: UIControlState.Normal)
        self.check = false

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }

    

}

