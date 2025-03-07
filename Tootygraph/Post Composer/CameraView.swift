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
                VideoPreviewView(captureSession: $cameraViewModel.captureSession, captureDevice: $cameraViewModel.captureDevice)
            default:
                Text("Something else happened")
            }
            
        }.border(.pink)
    }
}

struct VideoPreviewView: UIViewRepresentable{
    
    typealias UIViewType = VideoPreviewUIView
    @Binding var captureSession: AVCaptureSession
    @Binding var captureDevice: AVCaptureDevice!
    
    
    func makeUIView(context: Context) -> VideoPreviewUIView {
        let preview = VideoPreviewUIView()
        preview.setupCapture(session: captureSession, device: captureDevice)
        return preview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.videoPreviewLayer.session = captureSession
        uiView.videoPreviewLayer.videoGravity = .resizeAspectFill

        
    }
}

@MainActor
class VideoPreviewUIView: UIView {
    
    var observation: NSKeyValueObservation?
    
    var rotationController: AVCaptureDevice.RotationCoordinator?
    
    func setupCapture(session: AVCaptureSession, device: AVCaptureDevice){
        rotationController = AVCaptureDevice.RotationCoordinator(device: device, previewLayer: videoPreviewLayer)
        
        observation = rotationController?.observe(\.videoRotationAngleForHorizonLevelPreview, options: [.old, .new]) { rotationCoordinator, change in
            Task{
                await MainActor.run{
                    guard let newValue = change.newValue,
                          let connection = self.videoPreviewLayer.connection
                    else { return }
                    
                    // Make sure the angle is supported. This can probably be omitted, but it's safe to check.
                    if connection.isVideoRotationAngleSupported(newValue) {
                        // Set the videoRotationAngle to the new value
                        connection.videoRotationAngle = newValue
                    }
                }
            }
            
        }
    }
    
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
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}
