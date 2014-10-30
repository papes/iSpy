//
//  Node.swift
//  iSpy
//
//  Created by brett davis on 10/29/14.
//  Copyright (c) 2014 brett davis. All rights reserved.
//

import Foundation

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
    
    func ToString() -> String {
        return ("[" + self.accelerometerx + "," + self.accelerometery + "," + self.accelerometerz + "," + self.gyrox
        + "," + self.gyroy + "," + self.gyroz + "]")
    }
}