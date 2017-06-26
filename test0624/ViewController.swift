//
//  ViewController.swift
//  test0624
//
//  Created by Linne S. Huang on 6/24/17.
//  Copyright © 2017 Linne S. Huang. All rights reserved.
//


// Testing and Tutorial
// 1. Start from Scratch!
// 2. Putting cudes in the environment, in the same position
// 3. Putting cubes *at the camera position*
// 4. Importing 3D models and putting cups *at the camera position*


import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    
    // 1-1 - - - CONNECT: Connect the ARSCNView and named it as "sceneView"
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1-3 - - - SET UP THE ARKIT CONFIGURATION
        
        
        let configuration = ARWorldTrackingSessionConfiguration() // ARWorldTrackingSessionConfiguration is only supported by A9 processor. Otherwise, if you have a device supports ARKit, you can use ARSessionConfiguration (just will be slightly not immersive)
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration) //this is the basic AR tracking (e.g. Planes)
    }
    
    // 2-1 - - - And realized the cubes are in the same position, so, RANDOMIZE POSITION
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    // 1-2 - - - CONNECT: Connect the buttons and select "function"
    @IBAction func addCube(_ sender: Any) {
        
        // 2-2 - - - SET zCoords as the randomFloat
        // let zCoords = randomFloat(min: -2, max: -0.2)
        
        
        // 1-4 - - - Add Cube
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        // 2-3 - - - And replace -0.2 with zCoords
        // cubeNode.position = SCNVector3(0, 0, zCoords) // This is in meters
        
        // 3-2 - - - Commented out 2-2 & 2-3, Set the new positions
        let cc = getCameraCoordinates(sceneView: sceneView)
        cubeNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        sceneView.scene.rootNode.addChildNode(cubeNode) // *Putting the cup based on the root node
        print("So cube is here:", cc.x, cc.y, cc.z)
    }
    
    @IBAction func addCup(_ sender: Any) {
        
        // 4-1 - - - CALL THE CUP, PUT THE CUP
        let cupNode = SCNNode()
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        cupNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        guard let virtualObjectScene = SCNScene(named: "cup.scn", inDirectory: "Models.scnassets/cup")
            else {
                return
        }
        
        let wrapperNode = SCNNode() // *the whole chunk here: Placing the spoon based on the cup node that we are going to set below
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        cupNode.addChildNode(wrapperNode)
        
        sceneView.scene.rootNode.addChildNode(cupNode)
        print("So cup is here:", cc.x, cc.y, cc.z)
    }
    
    // 3-1 - - - GET CAMERA COORDINATES
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> myCameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x - 0.2
        cc.y = cameraCoordinates.translation.y - 0.2
        cc.z = cameraCoordinates.translation.z - 0.2
        
        return cc
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

