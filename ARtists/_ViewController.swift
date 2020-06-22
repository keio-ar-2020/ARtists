////
////  ViewController.swift
////  ARtists
////
////  Created by 尾崎耀一 on 2020/06/21.
////  Copyright © 2020 ar2020. All rights reserved.
////
//
//import UIKit
//import RevealingSplashView
//import SceneKit
//import ARKit
//
//class _ViewController: UIViewController, ARSCNViewDelegate {
//    private var revealingLoaded = false
//    override var shouldAutorotate: Bool {
//        return revealingLoaded
//    }
//    
//    @IBOutlet var sceneView: ARSCNView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "ARtist-icon")!, iconInitialSize: CGSize(width:140, height: 140), backgroundColor: UIColor.white)
//        self.view.addSubview(revealingSplashView)
//        revealingSplashView.duration = 1.0
//        
//        revealingSplashView.useCustomIconColor = false
//        
//        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
//        
//        revealingSplashView.startAnimation(){
//            self.revealingLoaded = true
//            self.setNeedsStatusBarAppearanceUpdate()
//            print("SplashView Completed")
//        }
//        
//        // Set the view's delegate
//        sceneView.delegate = self
//        
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        
//        // Set the scene to the view
//        sceneView.scene = scene
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        // Run the view's session
//        sceneView.session.run(configuration)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Pause the view's session
//        sceneView.session.pause()
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return !UIApplication.shared.isStatusBarHidden
//    }
//    
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return UIStatusBarAnimation.fade
//    }
//
//    // MARK: - ARSCNViewDelegate
//    
///*
//    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//     
//        return node
//    }
//*/
//    
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//        
//    }
//    
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//        
//    }
//    
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//        
//    }
//}
