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
      switch(cameraViewModel.authStatus){
      case .notDetermined:
       Text("You probably need to authorise camera access")
      case .denied:
        Text("Oh dear, denied")
      case .restricted:
        Text("Camera access is restricted")
      case .authorized:
        VideoPreviewView(captureSession: $cameraViewModel.captureSession)
      default:
        Text("Something else happened")
      }
      
    }.border(.pink)
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
    uiView.videoPreviewLayer.videoGravity = .resizeAspectFill
  }
}


class VideoPreviewUIView: UIView {
  
  var orientationChangeObserver: NSObjectProtocol?
  
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    sharedInit()
  }
  
  func sharedInit(){
    self.orientationChangeObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
      self?.correctVideoOrientation()
    }
  }

  
  deinit{
    guard let orientationChangeObserver = orientationChangeObserver else { return }
    NotificationCenter.default.removeObserver(orientationChangeObserver)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    correctVideoOrientation()
  }
  
  private func correctVideoOrientation() {
    guard let orientation = self.window?.windowScene?.interfaceOrientation,
          let connection = videoPreviewLayer.connection else { return }
    if connection.isVideoOrientationSupported {
      switch orientation {
      case .portrait:
        connection.videoOrientation = .portrait
      case .landscapeLeft:
        connection.videoOrientation = .landscapeLeft
      case .landscapeRight:
        connection.videoOrientation = .landscapeRight
      case .portraitUpsideDown:
        connection.videoOrientation = .portraitUpsideDown
      default:
        connection.videoOrientation = .portrait
      }
    }
  }
}
