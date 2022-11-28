//
//  ImageCVCell.swift
//  Music
//
//  Created by Christopher Samso on 11/28/22.
//

import UIKit

class ImageCVCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ImageCVCell"
    
    private var currentTask: URLSessionDataTask?
    private var currentImageURL: URL?
    
    @IBOutlet var gradientView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var songTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        setGradientBackground()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0, green: 0, blue:0, alpha: 0).cgColor
        let colorBottom = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.95]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 383.0, height: 383.0)
        imageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func updateImage(with url: URL) {
        guard currentImageURL != url else {
            // don't re-download
            return
        }
        
        currentImageURL = url
        imageView.image = nil
        if currentTask?.state == .running {
            currentTask?.cancel()
        }
        currentTask = URLSession.shared.dataTask(
            with: url) { data, response, error in
                if let data = data {
                    let image = UIImage(data: data, scale: UIScreen.main.scale)
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                            self.imageView.image = image
                        } completion: { _ in
                        }

                    }
                }
            }
        currentTask?.resume()
    }
}
