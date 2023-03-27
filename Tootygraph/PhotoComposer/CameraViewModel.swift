//
//  CameraViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 17/03/2023.
//

import Foundation
import AVFoundation


class CameraViewModel: ObservableObject {
  private var authorizationStatus: AVAuthorizationStatus = .notDetermined
  
  @MainActor @Published var captureSession: AVCaptureSession = AVCaptureSession()
  
  @MainActor @Published var authStatus: AVAuthorizationStatus = .notDetermined
  
  init(){
    Task{
      let authStatus = await requestVideoAuthorisation()
      await MainActor.run {
        self.authorizationStatus = authStatus
      }
      
      if (authStatus == .authorized){
        try? await setupCaptureSession()
      }
      await captureSession.startRunning()

    }
  }
  
  
  private func requestVideoAuthorisation() async -> AVAuthorizationStatus {
    let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
    if authStatus == .notDetermined {
      await AVCaptureDevice.requestAccess(for: .video)
      return AVCaptureDevice.authorizationStatus(for: .video)
    }
    return authStatus
  }
  
  private func setupCaptureSession() async throws {
    guard authorizationStatus == .authorized else {
      throw CameraViewModelError.notAuthorised
    }
    
    
    await captureSession.beginConfiguration()
    
    let defaultDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for:.video,position: .unspecified)
    guard let defaultDevice = defaultDevice else {
      throw CameraViewModelError.failedToAddCameraInput
    }
    let videoDeviceInput = try AVCaptureDeviceInput(device: defaultDevice)
  
    guard await captureSession.canAddInput(videoDeviceInput) else {
      throw CameraViewModelError.failedToAddCameraInput
    }
      
    await captureSession.addInput(videoDeviceInput)
    
    
    let photoOutput = AVCapturePhotoOutput()
    guard await captureSession.canAddOutput(photoOutput) else { return }
    await captureSession.sessionPreset = .photo
    await captureSession.addOutput(photoOutput)
    
    await captureSession.commitConfiguration()
  }
  
  enum CameraViewModelError: Error {
    case notAuthorised
    case failedToAddCameraInput
  }
}
