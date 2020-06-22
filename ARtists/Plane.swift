//
//  Plane.swift
//  ARtists
//
//  Created by 尾崎耀一 on 2020/06/21.
//  Copyright © 2020 ar2020. All rights reserved.
//

import Foundation
import ARKit

class Plane: SCNNode {
    
    let plane: SCNPlane
    
    init(anchor: ARPlaneAnchor) {
        plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        super.init()
        
        plane.cornerRadius = 0.008
        plane.materials = [GridMaterial()]
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // Planes in SceneKit are vertical by default so we need to rotate 90 degrees to match
        planeNode.eulerAngles.x = -.pi / 2
        
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR: init(coder:) has not been implemented")
    }
    
    func updateWith(anchor: ARPlaneAnchor) {
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        
        if let grid = plane.materials.first as? GridMaterial {
            grid.updateWith(anchor: anchor)
        }
        
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
    }
    
}
