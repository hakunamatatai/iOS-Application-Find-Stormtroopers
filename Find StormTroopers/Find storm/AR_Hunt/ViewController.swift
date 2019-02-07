//
//  ViewController.swift
//  Find Stormtrooper
//
//  Created by Hakunamatata on 2017/4/20.
//  Copyright (c) 2017 Yuchang Chen
//

import UIKit
import SceneKit
import AVFoundation
import CoreLocation


//use for delete target and return to map
//add a delegate protocal which there is only one method
//call it when taget is hitted
protocol ARControllerDelegate {
  func viewController(controller: ViewController, tappedTarget: ARItem)
}

class ViewController: UIViewController {
  
  @IBOutlet weak var sceneView: SCNView!
  @IBOutlet weak var leftIndicator: UILabel!
  @IBOutlet weak var rightIndicator: UILabel!
  
  //add these two functions to store AVCaptureSession and AVCaptureVideoPreviewLayer
  //connect video input such as camera
  var cameraSession: AVCaptureSession?
  //connect output such as previewlayer 预览层
  var cameraLayer: AVCaptureVideoPreviewLayer?
  
  //store target
  var target: ARItem!
  
  //use CLLocationManager to accept device direction
  var locationManager = CLLocationManager()
  var heading: Double = 0
  var userLocation = CLLocation()
  
  //add property
  var delegate: ARControllerDelegate?
  
  //create null de SCNScene and SCNNode, targetNode is a SCNnode include a SCNBox
  let scene = SCNScene()
  let cameraNode = SCNNode()
  let targetNode = SCNNode(geometry: SCNBox(width: 3, height: 3, length: 3, chamferRadius: 1))
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //loadcamera,already have camera input, call the above method, then load it into view preview layer
    loadCamera()
    self.cameraSession?.startRunning()
    
    //set viewController as CLLocationManager delegate
    //shoudl add extension
    self.locationManager.delegate = self
    
    //get direction info with startUpdatingHeading： default：direction change over 1du ,inform delegate
    self.locationManager.startUpdatingHeading()
    
    //-- SCNView setting code, create a null scene and add a camera
    sceneView.scene = scene
    cameraNode.camera = SCNCamera()
    //3D
    cameraNode.position = SCNVector3(x:0, y:0, z:10)
    
    //add camera node
    scene.rootNode.addChildNode(cameraNode)
    
    //call setuptarget()
    setupTarget()
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //use capture sesstion to connect video input such as camera and then connect to output: previewlayer
  func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
    
    //error return/ and capture sesstion return
    var error: NSError?
    var captureSession: AVCaptureSession?
    
    //get the back camera of device
    let backVideoDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera , mediaType: AVMediaTypeVideo, position: .back)
    
    //if back camera exit
    if backVideoDevice != nil {
      var videoInput: AVCaptureInput!
      do {
        videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
      } catch let error1 as NSError {
        error = error1
        videoInput = nil
      }
      
      //---- create an instance of AVCaptureSession
      if error == nil {
        captureSession = AVCaptureSession()
        
        //add the device as video input
        if captureSession!.canAddInput(videoInput) {
          captureSession!.addInput(videoInput)
        } else {
          //if fail to add video input
          error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
        }
      }
      else {
        //if back  camera doesn't exit
        error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
      }
    }
      else {
      error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
    }
      //return one sesstion
      return (session: captureSession, error: error)
    }
  
  
  //add quit button
  //already have camera input, call the above method, then load it into view preview layer
  func loadCamera() {
    //call above method to get capture session
    let captureSessionResult = createCaptureSession()
    
    //if there is error,
    guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
      print("Error creating capture session.")
      return
    }
    
    //if correct, store capture session in cameraSession
    self.cameraSession = session
    
    //create one video previewlayer
    //if true, set videogravity, and set frame of this layer as bounds of view -- to give user a full screen
    
    if let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession) {
      cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      cameraLayer.frame = self.view.bounds
      
      //add this layer as child layer and store it into cameraLayer
      self.view.layer.insertSublayer(cameraLayer, at: 0)
      self.cameraLayer = cameraLayer
    }
  }
  
  
  //repositionTarget() 
  //--- if camera direction change, compute cha between current direction with target direction
  //show turn left and turn right label
  func repositionTarget() {
    
    //compute the anble between current directinon with target direction
    //call function getHeadingForDirectionFromCoordinate
    let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: target.location)
    
    //delta direction = current - change
    let delta = heading - self.heading
    
    if delta < -20.0 {
      leftIndicator.isHidden = false
      rightIndicator.isHidden = true
    } else if delta > 20.0 {
      leftIndicator.isHidden = true
      rightIndicator.isHidden = false
    } else {
      leftIndicator.isHidden = true
      rightIndicator.isHidden = true
    }
    
    //get distance from device to target
    let distance = userLocation.distance(from: target.location)
    
    //if item has already allocate node
    //which means if the target already shown in camera once time
    if let node = target.itemNode{
      
      //if node doesn't have parent, use distance set location and add this node into scenery
      //which means the target didn't shown in camera once time
      if node.parent == nil {
        node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
        scene.rootNode.addChildNode(node)
      } else {
        
        //delete all action and create a new action
        node.removeAllActions()
        
        //SceneKit 里的
        //SCNAction.move(to:  , duration: ) create an acion, move node to location, time is defined
        //runAction(_:) is a mehod of SCNode, run an action.
        node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2))
      }
    }
  }
  
  //弧度转角度
  func radiansToDegrees(_ radians: Double) -> Double {
    return (radians) * (180.0 / .pi)
    //M_PI  .pi
  }
  
  //角度转弧度
  func degreesToRadians(_ degrees: Double) -> Double {
    return (degrees) * ( .pi / 180.0)
  }
  
  func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
    
    //change latitude and longitute into radians
    //call degreesToRadians
    let fromLat = degreesToRadians(from.coordinate.latitude)
    let fromLng = degreesToRadians(from.coordinate.longitude)
    let toLat = degreesToRadians(to.coordinate.latitude)
    let toLng = degreesToRadians(to.coordinate.longitude)
    
    //use this 4 value to computer direction and change it to degree
    //call radiansToDegrees
    let degree = radiansToDegrees(atan2(sin(toLng - fromLng) * cos(toLat), cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLng - fromLng)))
    
    //if degree < 0 then add 360 to +
    if degree >= 0 {
      return degree
    } else {
      return degree + 360
    }
  }
  
  
  //give targetNode a name and allocate it to target, then viewdidload() could call this method
  //add pics into node, allocate it to target itemNode
  func setupTarget() {
    //把模型加到场景里
    
    //targetNode.name = "target"
    //self.target.itemNode = targetNode
    
    //load model into scene, itemDescription of target is the name of .dae file
    let scene = SCNScene(named: "art.scnassets/\(target.itemDescription).dae")
    
    //tranfer scene to get a node named itemDescription
    let enemy = scene?.rootNode.childNode(withName: target.itemDescription, recursively: true)
    
    //adjust location, and show two models
    if target.itemDescription == "dragon" {
      enemy?.position = SCNVector3(x: 0, y: -15, z: 0)
    }
    //if target.itemDescription == "Bear_Brown" {
    //  enemy?.position = SCNVector3(x: 5, y: -30, z: -5)
    //}
    else {
      enemy?.position = SCNVector3(x: 0, y: 0, z: 0)
    }

    
    //add model to null node, and allocate it to current target's itemNode property
    let node = SCNNode()
    node.addChildNode(enemy!)
    node.name = "enemy"
    self.target.itemNode = node
  }
  
  
  //touch to throw ball
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    // change touch into coordinate of scene
    let touch = touches.first!
    let location = touch.location(in: sceneView)
    
    // hitTest(, options: ) send fire to location and return SCNHitTestResult array for each node
    let hitResult = sceneView.hitTest(location, options: nil)
    
    // SceneKit Fireball.scnp load fireball particlesystem
    let fireBall = SCNParticleSystem(named: "Fireball.scnp", inDirectory: nil)
    //Fireball.scnp
    
    // then add particlesystem to a null node, and set it at the bottom of screen
    let emitterNode = SCNNode()
    emitterNode.position = SCNVector3(x: 0, y: -5, z: 10)
    emitterNode.addParticleSystem(fireBall!)
    scene.rootNode.addChildNode(emitterNode)
    
    // if detect this is a click
    if hitResult.first != nil {
      
      //wait time: then delete target itemNode
      target.itemNode?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.3), SCNAction.removeFromParentNode(), SCNAction.hide()]))
      
      //change node operation to sequence, keep move operation unchangeable
      let sequence = SCNAction.sequence([SCNAction.move(to: target.itemNode!.position, duration: 0.5),
                                         
      //pause 2.0s after emitter move
      SCNAction.wait(duration: 2.0),
      
      //inform that delegate has been hitted
      SCNAction.run({_ in
        self.delegate?.viewController(controller: self, tappedTarget: self.target)})])
      
      emitterNode.runAction(sequence)
      
      //then move emitternode to target location
      //let moveAction = SCNAction.move(to: target.itemNode!.position, duration: 0.5)
      //emitterNode.runAction(moveAction)
    } else {
      //if not hit, just move fireball location
      emitterNode.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 0, z: -30), duration: 0.5))
    }
  }
  
}

//in order to use CLLocationManagerDelegate protocol, add extension
extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    
    //everytime, a new direction info generated, CLLocationManager will call this delegate method
    self.heading = fmod(newHeading.trueHeading, 360.0)
    
    //fmod is double value mod function, to ensure direction from 0 ~ 359
    
    repositionTarget()
  }
}





























