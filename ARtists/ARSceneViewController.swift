//
//  ViewController.swift
//  ARtists
//
//  Created by 尾崎耀一 on 2020/06/21.
//  Copyright © 2020 ar2020. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARSceneViewController: UIViewController {
    
    var paintImage: UIImage?
    
    @IBOutlet var sceneView: ARSCNView!
    
    let sceneManager = ARSceneManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sceneManager.attach(to: sceneView)
        
        sceneManager.displayDegubInfo()
        
        // Prevent the screen from being dimmed after a while as users will likely have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScene(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapScene(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            let location = gesture.location(ofTouch: 0,
                                            in: sceneView)
            let hit = sceneView.hitTest(location,
                                        types: .existingPlaneUsingGeometry)
            
            if let hit = hit.first {
                placeBlockOnPlaneAt(hit)
            }
        default:
            print("tapped default")
        }
    }
    
    func placeBlockOnPlaneAt(_ hit: ARHitTestResult) {
        let box = createBox()
        position(node: box, atHit: hit)
        
        sceneView?.scene.rootNode.addChildNode(box)
    }
    
    private func createBox() -> SCNNode {
        // TODO: multiple paints should be put on wall and frame should be attached.
        let aspectRate = self.paintImage!.size.height / self.paintImage!.size.width
        let width = 0.4
        let box = SCNBox(width: CGFloat(width), height: CGFloat(width) * aspectRate, length: 0.0001, chamferRadius: 0.02) // unit: meter
        box.firstMaterial?.diffuse.contents = self.paintImage!.flipVertical()
        let boxNode = SCNNode(geometry: box)
        boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))

        return boxNode
    }
    
    private func position(node: SCNNode, atHit hit: ARHitTestResult) {
           node.transform = SCNMatrix4(hit.anchor!.transform)
           node.eulerAngles = SCNVector3Make(node.eulerAngles.x + (Float.pi / 2), node.eulerAngles.y, node.eulerAngles.z)
           
           let position = SCNVector3Make(hit.worldTransform.columns.3.x + node.geometry!.boundingBox.min.z, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
           node.position = position
       }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class Projectile: SCNNode {
    
    override init() {
        super.init()
        
        let capsule = SCNCapsule(capRadius: 0.006, height: 0.06)
        
        geometry = capsule
        
        eulerAngles = SCNVector3(CGFloat.pi / 2, (CGFloat.pi * 0.25), 0)
        
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR: init(coder:) has not been implemented")
    }
    
    func launch(inDirection direction: SCNVector3) {
        physicsBody?.applyForce(direction, asImpulse: true)
    }
    
}
