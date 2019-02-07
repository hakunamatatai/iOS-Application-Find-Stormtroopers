//
//  MapViewController.swift
//  Find Stormtrooper
//
//  Created by Hakunamatata on 2017/4/20.
//  Copyright (c) 2017 Yuchang Chen
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  var targets = [ARItem]()  //item array
  
  //if user want to use location, he should ask authority first
  //obatain user's current location
  let locationManager = CLLocationManager()   //viewDidload()
  
  //locate item location
  var userLocation: CLLocation?
  
  //store the selected annotation, for remove it later
  var selectedAnnotation: MKAnnotation?
  
  //setting visible area
  let regionRadius: CLLocationDistance = 1000
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  
  
  func setupLocations() {
    //bird library
    //var itemNode: SCNNode? ，add nil value for itemNode
    let trooper1Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0400, longitude: -76.1325), itemNode: nil)
    targets.append(trooper1Target)
    
    let trooper2Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0402, longitude: -76.1326), itemNode: nil)
    targets.append(trooper2Target)
    
    let alien1Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0400, longitude: -76.1325), itemNode: nil)
    targets.append(alien1Target)
    
    
    
    //life science
    let trooper3Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0381, longitude: -76.1305), itemNode: nil)
    targets.append(trooper3Target)
    
    let alien2Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0385, longitude: -76.1308), itemNode: nil)
    targets.append(alien2Target)
    
    let alien3Target = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 43.0382, longitude: -76.1303), itemNode: nil)
    targets.append(alien3Target)
    
    let alien4Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0381, longitude: -76.1312), itemNode: nil)
    targets.append(alien4Target)
    
    
    // 4-206  itemNode:nil
    let test1Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0377, longitude: -76.1304), itemNode: nil)
    targets.append(test1Target)
    
    let test2Target = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 43.0378, longitude: -76.1305), itemNode: nil)
    targets.append(test2Target)
    
    let test3Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0376, longitude: -76.1303), itemNode: nil)
    targets.append(test3Target)
    
    let test4Target = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 43.0375, longitude: -76.1304), itemNode: nil)
    targets.append(test4Target)
    
    let test5Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0374, longitude: -76.1306), itemNode: nil)
    targets.append(test5Target)
    
    
    //bookstore
    let alien5Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0397, longitude: -76.1336), itemNode: nil)
    targets.append(alien5Target)
    
    //lyman hall
    let alien6Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0376, longitude: -76.1327), itemNode: nil)
    targets.append(alien6Target)
    
    let alien7Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 43.0377, longitude: -76.1326), itemNode: nil)
    targets.append(alien7Target)
    
    let alien8Target = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 43.0378, longitude: -76.1328), itemNode: nil)
    targets.append(alien8Target)
    
    
    //nobhill
    let nobhill1Target = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 42.9987, longitude: -76.1273), itemNode: nil)
    targets.append(nobhill1Target)
    
    let nobhill2Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 42.9986, longitude: -76.1272), itemNode: nil)
    targets.append(nobhill2Target)
    
    let nobhill3Target = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 42.9988, longitude: -76.1274), itemNode: nil)
    targets.append(nobhill3Target)
    
    
    
    for item in targets {
      //MapAnnotation
      //traverse targets array, and add annotation for each target
      let annotation = MapAnnotation(location: item.location.coordinate, item: item)
      self.mapView.addAnnotation(annotation)
    }
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    
    // set initial location in syracuse university：display region
    let initialLocation = CLLocation(latitude: 43.0385, longitude: -76.1308)
    centerMapOnLocation(location: initialLocation)

    //call setuplocation
    //setupLocations()
    
    //get authority, if not, mapview can't locate item!!!!
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
    //add
    setupLocations()
  }
}


//everytime device update location, will call MapView

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    self.userLocation = userLocation.location
  }
  
  //transfer location... in viewcontroller to map
  //delegate method: if target locate less 60, show camera
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
    //get the selected annotation coordinate
    let coordinate = view.annotation!.coordinate
    
    //ensure userlocation allocated
    if let userCoordinate = userLocation {
      
      //ensure the target 在自己范围内
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 100 {
        
        //实例化 ARViewController from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ViewController {
          
          // ---  set the delegate of viewController as MapViewController
          viewController.delegate = self
          
          
          //check if the taped annotation is MapAnnotation
          if let mapAnnotation = view.annotation as? MapAnnotation {
            
            //before show the target, 存储了被点击annotation的ARItem的引用，所以 viewController know what alien 
            //you will meet
            viewController.target = mapAnnotation.item
            
            //trans user location to viewController
            viewController.userLocation = mapView.userLocation.location!
            
            //save the selected annotation
            selectedAnnotation = view.annotation
            
            //at last, show viewcontroller
            self.present(viewController, animated: true, completion: nil)

          }
        }
      }
    }
  }
}



//extension MapViewController: ViewControllerDelegate
extension MapViewController: ARControllerDelegate {
  func viewController(controller: ViewController, tappedTarget: ARItem) {
    
    //close AR
    self.dismiss(animated: true, completion: nil)
    
    //delete target from target list
    let index = self.targets.index(where: {$0.itemDescription == tappedTarget.itemDescription})
    self.targets.remove(at: index!)
    
    if selectedAnnotation != nil {
      //delete annotation
      mapView.removeAnnotation(selectedAnnotation!)
    }
  }
}
































