//
//  UIImageViewExtension.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {

    func showImageFromUrl(urlString: String, inverted: Bool = false, imageMode: UIView.ContentMode) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, inverted: inverted, imageMode: imageMode)
    }

    func downloadImageFrom(url: URL, inverted: Bool, imageMode: UIView.ContentMode) {
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            setImageOnImageView(inverted: inverted, image: cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self?.setImageOnImageView(inverted: inverted, image: imageToCache)
                }
            }.resume()
        }
    }
    private func setImageOnImageView(inverted: Bool, image: UIImage?) {
        if inverted {
            showInvertedImage(image: image)
        } else {
            self.image = image
        }
    }
    private func showInvertedImage(image: UIImage?) {
        self.image = image
        if let beginImage = image {
            DispatchQueue.main.async {
                guard let cgImage = beginImage.cgImage else { return }
                let ciImage = CoreImage.CIImage(cgImage: cgImage)
                guard let filter = CIFilter(name: "CIColorInvert") else { return  }
                filter.setDefaults()
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                let context = CIContext(options: nil)
                guard let outputImage = filter.outputImage else { return  }
                guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return  }
                self.image = UIImage(cgImage: outputImageCopy, scale: beginImage.scale, orientation: .up)
            }
        }
    }
}
