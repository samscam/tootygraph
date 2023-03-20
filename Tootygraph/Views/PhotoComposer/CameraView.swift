//
//  CameraView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 17/03/2023.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: View {
  @StateObject var cameraViewModel = CameraViewModel()
  
  var body: some View {
    VStack{
      VideoPreviewView(captureSession: $cameraViewModel.captureSession)
    }
  }
}

struct VideoPreviewView: UIViewRepresentable{

  typealias UIViewType = VideoPreviewUIView
  @Binding var captureSession: AVCaptureSession
  
  func makeUIView(context: Context) -> VideoPreviewUIView {
    return VideoPreviewUIView()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.videoPreviewLayer.session = captureSession
  }
}


class VideoPreviewUIView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
