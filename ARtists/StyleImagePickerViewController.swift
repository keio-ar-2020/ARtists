//
//  StyleImagePickerViewController.swift
//  ARtists
//
//  Created by 尾崎耀一 on 2020/06/21.
//  Copyright © 2020 ar2020. All rights reserved.
//

import UIKit

protocol StyleImagePickerViewControllerDelegate {
    
    func picker(_: StyleImagePickerViewController, didSelectStyle image: UIImage)
    
}

class StyleImagePickerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var delegate: StyleImagePickerViewControllerDelegate?
    
    class func fromStoryboard() -> StyleImagePickerViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StyleImagePickerViewController") as! StyleImagePickerViewController
    }
    
    private let dataSource = StyleImagePickerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = dataSource.imageForStyle(at: indexPath.item) {
            collectionView.deselectItem(at: indexPath, animated: true)
            delegate?.picker(self, didSelectStyle: image)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let smallestDimension = collectionView.bounds.width < collectionView.bounds.height ?
            collectionView.bounds.width : collectionView.bounds.height
        let extraPadding: CGFloat = 3 // magic number
        let itemDimension =
            smallestDimension / 2
                - collectionView.contentInset.left
                - collectionView.contentInset.right
                - layout.sectionInset.left
                - layout.sectionInset.right
                - layout.minimumInteritemSpacing
                - extraPadding
        return CGSize(width: itemDimension, height: itemDimension)
    }
}

class StyleImagePickerDataSource: NSObject, UICollectionViewDataSource {
    
    static func defaultStyle() -> UIImage {
        return UIImage(named: "style24")! // use great wave as default
    }
    
    lazy private var images: [UIImage] = {
        var index = 0
        var images: [UIImage] = []
        while let image = UIImage(named: "style\(index)") {
            images.append(image)
            index += 1
        }
        return images
    }()
    
    func imageForStyle(at index: Int) -> UIImage? {
        return images[index]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StyleImagePickerCell",
            for: indexPath) as! StyleImagePickerCollectionViewCell
        let image = imageForStyle(at: indexPath.item)
        cell.styleImageView.image = image
        return cell
    }
    
}

class StyleImagePickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var styleImageView: UIImageView!
}

