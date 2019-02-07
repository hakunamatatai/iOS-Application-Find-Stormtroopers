//
//  MapAnnotation.swift
//  Find Stormtrooper
//
//  Created by Hakunamatata on 2017/4/23.
//  Copyright (c) 2017 Yuchang Chen
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
  //MKAnnotation protocol
  //one coordinate
  let coordinate: CLLocationCoordinate2D
  //one optional value title
  let title: String?
  //store ARItem belong to annotation
  let item:ARItem
  
  
  //init allocate
  init(location: CLLocationCoordinate2D, item: ARItem) {
    self.coordinate = location
    self.item = item
    self.title = item.itemDescription
    
    super.init()
  }
}
