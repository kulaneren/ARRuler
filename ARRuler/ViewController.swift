//
//  ViewController.swift
//  ARRuler
//
//  Created by eren on 8.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var nodeText = SCNNode()
    
    var arryDotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

    }

       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //Add dot to scene
    func addDot(at hitResult: ARHitTestResult){
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        arryDotNodes.append(dotNode)
        
        if arryDotNodes.count >= 2{
            calculate()
        }
    }
    
    // calculate distance between 2 dots
    func calculate(){
        let start = arryDotNodes[0]
        
        let end = arryDotNodes[1]
        
        let a = end.position.x - start.position.x
        
        let b = end.position.y - start.position.y
        
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        updateText(text: "\(distance)", atPosition: start.position)
        
    }
    
    // update measure text in scene
    func updateText(text: String, atPosition position: SCNVector3){
        
        nodeText.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        nodeText.geometry = textGeometry
        
//        nodeText.position = SCNVector3(0, 0.01, -0.1)
        
        nodeText.position = position
        
        nodeText.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(nodeText)
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if arryDotNodes.count >= 2{
            for node in arryDotNodes{
                node.removeFromParentNode()
            }
            
            arryDotNodes.removeAll()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView){
            let hitResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitResults.first{
                addDot(at: hitResult)
            }
        }
    }
    
}
