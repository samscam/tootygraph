//
//  CameraViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 17/03/2023.
//

import Foundation
@preconcurrency import AVFoundation

@MainActor
class CameraViewModel: ObservableObject {

    @Published var captureSession: AVCaptureSession = AVCaptureSession()
    
    @Published var authStatus: AVAuthorizationStatus = .notDetermined
    
    @Published var captureDevice: AVCaptureDevice?
    
    
    init(){
        Task{
            let authStatus = await requestVideoAuthorisation()
            
            self.authStatus = authStatus
            
            
            if (authStatus == .authorized){
                do{
                    try await setupCaptureSession()
                    Task.detached {
                        await self.captureSession.startRunning()
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            
        }
    }
    
    
    private func requestVideoAuthorisation() async -> AVAuthorizationStatus {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .notDetermined {
            let authorised = await AVCaptureDevice.requestAccess(for: .video)
            
            return authorised ? .authorized : .denied
        }
        return authStatus
    }
    
    private func setupCaptureSession() async throws {
        guard authStatus == .authorized else {
            throw CameraViewModelError.notAuthorised
        }
        
        
        captureSession.beginConfiguration()
        
        let defaultDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for:.video,position: .unspecified)
        guard let defaultDevice = defaultDevice else {
            throw CameraViewModelError.failedToAddCameraInput
        }
        captureDevice = defaultDevice
        let videoDeviceInput = try AVCaptureDeviceInput(device: defaultDevice)
        
        guard captureSession.canAddInput(videoDeviceInput) else {
            throw CameraViewModelError.failedToAddCameraInput
        }
        
        captureSession.addInput(videoDeviceInput)
        
        
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        captureSession.commitConfiguration()
        
    }
    
    enum CameraViewModelError: Error {
        case notAuthorised
        case failedToAddCameraInput
    }
}
