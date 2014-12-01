import UIKit
import CoreMotion

/**
* @author      Brett Davis
* @version     1.0
* @since       2014-09-24  
*/


/*
* Takes a double and formats it to a specified # of decimal places
* @param f is the double to be formatted
* @returns a string value
*/
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
    var continuous: Bool = false
    var sample:[Node] = [Node]()
    
    @IBOutlet weak var collectButton: UIButton!
    
    // function that gets called when button is pressed
    @IBAction func toggle(sender: AnyObject) {
        // tomfoolery I had to do to get this to work with single button
        self.check = !(self.check)
        if( self.check == true){
            collectButton.setTitle("Stop Collecting", forState: UIControlState.Normal)
            continuous = true;
            collectData()
        } else {
            collectButton.setTitle("Start Collecting", forState: UIControlState.Normal)
            stopCollecting()
        }
        
    }
    
    @IBAction func singleTest(sender: AnyObject) {
        continuous = false
        collectData()
        
    }

    @IBAction func viewAnalytics(sender: AnyObject) {
    }
    /*
    * Collects data from the phone senors and puts data into a collection of Nodes.
    */
    func collectData(){
        
        // set up some values to use in the curve
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180)
        let ovalRect = CGRectMake(97.5, 58.5, 125, 125)
        
        // create the bezier path
        let ovalPath = UIBezierPath()
        
        ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)),
            radius: CGRectGetWidth(ovalRect) / 2,
            startAngle: ovalStartAngle,
            endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.CGPath
        progressLine.strokeColor = UIColor.blueColor().CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = 10.0
        progressLine.lineCap = kCALineCapRound
        
        // add the curve to the screen
        self.view.layer.addSublayer(progressLine)
        
        // create a basic animation that animates the value 'strokeEnd'
        // from 0.0 to 1.0 over 3.0 seconds
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.removedOnCompletion = true
        animateStrokeEnd.duration = 3.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        
        // add the animation
        progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
   
        
        
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
                          progressLine.removeFromSuperlayer()
                            self.formatJSON()
                        }
                       
                        
                    }
                }
            })
        }
    }
    
    /*
    * Stops the collection of data from the phone senors and flushes the Node collection.
    */
    func stopCollecting() {
        self.motionManager.stopDeviceMotionUpdates()
        self.sample.removeAll()
    }
    
    /*
    * Takes Node collection and formats data into JSON
    */
    func formatJSON(){
        var values = [String]()
        for(var i = 0; i < 20; i++){
            sample[i].AppendToCollection(&values)
        }
        println(values)
        println(" ")
        if(!continuous){
            stopCollecting()
        }
        
        let json:NSDictionary = ["data":values]
       // self.sendData(json)
        self.sample.removeAll()
    }
    
    /*
    * Sends JSON to web service via HTTP
    * @param json is the data to be sent to the server
    */
    func sendData(json:NSDictionary){
        Cycle.post("http://ispyj7t7.elasticbeanstalk.com/GetPhoneData",
            requestObject: json,
            requestProcessors: [JSONProcessor()],
            responseProcessors: [JSONProcessor()],
            completionHandler: {(cycle, error) in
                println("\(cycle.response.statusCode)")
                var header = cycle.response.valueForHTTPHeaderField("content-type")
               /* println("\(header)")
                println("\(cycle.response.textEncoding)")
                println("\(cycle.response.text)")
                println("\(cycle.response.object)")
*/
        })
        
        if(!continuous){
            stopCollecting()
        }
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

