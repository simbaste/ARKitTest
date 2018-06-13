//
//  ViewController.swift
//  ARKitTest
//
//  Created by Stephane Darcy SIMO MBA on 12/06/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    struct CameraCoordinates {
        var x: Float
        var y: Float
        var z: Float
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> CameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        return CameraCoordinates(x: cameraCoordinates.translation.x, y: cameraCoordinates.translation.y, z: cameraCoordinates.translation.z)
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }

    @IBAction func addCube(_ sender: Any) {
        let zCoord = randomFloat(min: -2, max: -0.2)
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let cameraCoordinates = getCameraCoordinates(sceneView: sceneView)

        cubeNode.position = SCNVector3(cameraCoordinates.x, cameraCoordinates.y, zCoord) // This is in meters
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    @IBAction func addCup(_ sender: Any) {
        let zCoord = randomFloat(min: -2, max: -0.2)
        let cupNode = SCNNode()
        let cameraCoordinates = getCameraCoordinates(sceneView: sceneView)
        let wrapperNode = SCNNode()
        
        cupNode.position = SCNVector3(cameraCoordinates.x, cameraCoordinates.y, zCoord)
        guard let virtualObjectScene = SCNScene(named: "vase.scn", inDirectory: "Models.scnassets/vase") else {
            return
        }
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        cupNode.addChildNode(wrapperNode)
        sceneView.scene.rootNode.addChildNode(cupNode)
    }
}









