//
//  StylizedImageViewController.swift
//  ARtists
//
//  Created by 尾崎耀一 on 2020/06/21.
//  Copyright © 2020 ar2020. All rights reserved.
//

import UIKit

class StylizedImageViewController: UIViewController {
    
    /// Style transfer result.
    var originalImage: UIImage?
    var styleImage: UIImage?
    var resultImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var putItOnWallButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.originalImage == nil {
            self.originalImage = UIImage(named: "NOIMAGE")
        }
        if self.styleImage == nil {
            self.styleImage = UIImage(named: "NOIMAGE")
        }
        if self.resultImage == nil {
            self.resultImage = UIImage(named: "NOIMAGE")
        }
        self.imageView.image = self.resultImage
        segmentedControl.selectedSegmentIndex = 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toARSceneViewController" {
            let next = segue.destination as? ARSceneViewController
            next?.paintImage = self.resultImage
        }
    }
    
    @IBAction func onSegmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Mode 0: Show input image
            imageView.image = originalImage
        case 1:
            // Mode 1: Show style image
            imageView.image = styleImage
        case 2:
            // Mode 2: Show style transfer result.
            imageView.image = resultImage
        default:
            break
        }
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
