//
//  NukeVideoView.swift
//  Tootygraph
//
//  Created by Sam on 11/01/2024.
//

import UIKit
import SwiftUI
import AVKit

import Nuke
import NukeUI
import NukeVideo

struct NukeVideoView: UIViewRepresentable {
    var asset: URL?

    init(asset: URL?) {
        self.asset = asset
    }

    func makeUIView(context: Context) -> UIView {
        let contentView = UIView()
        let imageView = LazyImageView()
        imageView.makeImageView = { container in
            if let type = container.type, type.isVideo, let asset = container.userInfo[.videoAssetKey] as? AVAsset {
                let view = VideoPlayerView()
                view.asset = asset
                view.play()
                return view
            }
            return nil
        }
        imageView.url = self.asset
        contentView.addSubview(imageView)
        imageView.pinToSuperview()
        
        return imageView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle updates if needed
    }
}

extension UIView {
    /// Pins this view to it's superview.
    func pinToSuperview() {
        guard let superview = superview else { fatalError("UIView+pinToSuperview: \(description) has no superview.") }
        pin(to: superview)
    }
    
    /// Pins this view to another view.
    func pin(to view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
