//
//  UIView+Image.swift
//  p4.1
//
//  Created by Merouane Bellaha on 02/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UIView {
    /// Transform the object in an UIImage
    var image: UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
