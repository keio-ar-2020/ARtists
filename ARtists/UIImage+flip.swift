//
//  UIImage+flip.swift
//  ARtists
//
//  Created by 尾崎耀一 on 2020/06/22.
//  Copyright © 2020 ar2020. All rights reserved.
//

import UIKit

extension UIImage {

    // let scale = 1.0

    func flipVertical() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(1.0))
        let imageRef = self.cgImage
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y:  0)
        context?.scaleBy(x: 1.0, y: 1.0)
        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flipHorizontalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flipHorizontalImage!
    }

    func flipHorizontal() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(1.0))
        let imageRef = self.cgImage
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: size.width, y:  size.height)
        context?.scaleBy(x: -1.0, y: -1.0)
        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flipHorizontalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flipHorizontalImage!
    }

}
