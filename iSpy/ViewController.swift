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
        //We want 4 digits after the decimal point
        let precision = ".04"
        // units are seconds so 1/30 = 30x a second
        self.motionManager.deviceMotionUpdateInterval = 1/6
        
        if(self.motionManager.deviceMotionAvailable){
            self.motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXArbitraryCorrectedZVertical, toQueue: motionQueue, withHandler: {(motionData:CMDeviceMotion!,error:NSError!) in

                dispatch_async(dispatch_get_main_queue()) {
                    
                        if(self.motionManager.deviceMotion != nil){
                            let node:Node = Node(ax: motionData.userAcceleration.x.format(precision),ay: motionData.userAcceleration.y.format(precision),az: motionData.userAcceleration.z.format(precision),gx: motionData.rotationRate.x.format(precision),gy: motionData.rotationRate.y.format(precision),gz: motionData.rotationRate.z.format(precision))
                            
                            self.sample.append(node)
                            
                            if(self.sample.count == 20){
                                self.formatJSON()
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
    
    func formatJSON(){
        var values = [String]()
        for(var i = 0; i < 20; i++){
            sample[i].AppendToCollection(&values)
            println(sample[i].accelerometerx)
        }
       println(values)
      let json:NSDictionary = ["data":values]
       println(json)
        
       self.sendData(json)
       self.sample.removeAll()
    }
    
    func sendData(json:NSDictionary){

        Cycle.post("http://ispyj7t7.elasticbeanstalk.com/GetPhoneData",
            requestObject: json,
            requestProcessors: [JSONProcessor()],
            responseProcessors: [JSONProcessor()],
            completionHandler: {(cycle, error) in
                println("\(cycle.response.statusCode)")
                var header = cycle.response.valueForHTTPHeaderField("content-type")
                println("\(header)")
                println("\(cycle.response.textEncoding)")
                println("\(cycle.response.text)")
                println("\(cycle.response.object)")
        })
/*
        var err: NSError?
        var request = NSMutableURLRequest(URL: NSURL(string: "http://ispyj7t7.elasticbeanstalk.com/GetPhoneData")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: &err)
        println(request.HTTPBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        

        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Success: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
         */
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

