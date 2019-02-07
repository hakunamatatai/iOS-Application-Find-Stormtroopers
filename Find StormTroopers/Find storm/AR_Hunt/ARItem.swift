//
//  ARItem.swift
//  Find Stormtrooper
//
//  Created by Hakunamatata on 2017/4/23.
//  Copyright (c) 2017 Yuchang Chen
//

import Foundation
import CoreLocation
import SceneKit


//Item struct
struct ARItem {
  //item name
  let itemDescription: String
  //item location
  let location: CLLocation
  
  //store SCNNode of item
  var itemNode: SCNNode?
}
