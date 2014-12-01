import Foundation

/**
* @author      Brett Davis
* @version     1.0
* @since       2014-10-29
*/

class Node{
    var accelerometerx:String
    var accelerometery:String
    var accelerometerz:String
    var gyrox:String
    var gyroy:String
    var gyroz:String
    
    init(ax :String, ay:String, az: String, gx:String,gy:String,gz:String){
        self.accelerometerx = ax
        self.accelerometery = ay
        self.accelerometerz = az
        self.gyrox = gx
        self.gyroy = gy
        self.gyroz = gz
    }
    
    /*
    * Takes node and appends instance variables in order to a collection of strings
    * @param arr is a mutable array to which the instance variables are appended to
    */
    func AppendToCollection(inout arr: [String]){
        arr.append(self.accelerometerx)
        arr.append(self.accelerometery)
        arr.append(self.accelerometerz)
        arr.append(self.gyrox)
        arr.append(self.gyroy)
        arr.append(self.gyroz)
    }
}