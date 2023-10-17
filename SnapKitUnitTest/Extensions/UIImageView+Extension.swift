//
//  UIImageView+Extension.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 17/10/2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageWithURL(_ url: URL?) {
        guard let url else { return }
        
        if url.absoluteString.starts(with: "http") {
            KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                let image = try? result.get().image
                self?.image = image
            }
        } else {
            image = UIImage(contentsOfFile: url.absoluteString)
        }
    }
}
