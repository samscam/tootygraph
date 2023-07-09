//
//  PhotoComposerViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 27/02/2023.
//

import SwiftUI
import CoreTransferable
import PhotosUI
import TootSDK



class PhotoComposerViewModel: ObservableObject{
  
  @Published var mediaItems: [MediaItem] = []
  @Published var selectedItem: MediaItem?
  
  
  let tootClient: TootClient?
  
  init(tootClient: TootClient?){
    self.tootClient = tootClient
  }
  
  func postMedia(){
    // now do something
  }
}

//
//  func postImages() async throws {
//
//
//    for imageState in imageStates {
//      let imageData = try await imageState.loadData()
//
//      let uploadParams = UploadMediaAttachmentParams(file: imageData, thumbnail: nil, description: imageState.description , focus: nil)
//
//      let mediaAttachment = try await client.uploadMedia(uploadParams, mimeType: imageState.mimeType)
//
//      if mediaAttachment.url == nil {
//        print("Image upload in progress…")
//        var hasUploaded = false
//        repeat {
//          try await Task.sleep(for: .seconds(5))
//          print("Checking if image already uploaded…")
//          let uploadedMediaAttachment = try await tootClient.getMedia(id: mediaAttachment.id)
//          hasUploaded = uploadedMediaAttachment != nil
//        } while !hasUploaded
//      }
//
//      print("Image uploaded, posting status")
//      let params = PostParams(post: post, mediaIds: [mediaAttachment.id], visibility: visibility)
//      try await client.publishPost(params).id
//
//    }
//  }
//}

enum ImageState {
  
  case loading(_ progress: Progress)
  case empty
  case success(_ image: Image)
  case failure(_ error: Error)
  
}

class WrappedPickerItem: Identifiable, ObservableObject {
  let pickerItem: PhotosPickerItem
  @Published var state: ImageState
  @Published var description: String = ""
  
  var id: String
  var data: Data? = nil
  
  init(_ pickerItem: PhotosPickerItem) {
    self.pickerItem = pickerItem
    id = UUID().uuidString
    state = .empty
    Task{
      let mediaItem = try await pickerItem.loadTransferable(type: MediaItem.self)
    }

  }
  
}

extension WrappedPickerItem: Hashable {
  static func == (lhs: WrappedPickerItem, rhs: WrappedPickerItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
}

enum TransferError: Error {
  case importFailed
}

class MediaItem: Transferable, Identifiable, ObservableObject {
  var image: Image? = nil
  var data: Data? = nil
  
  
  init(image: Image?, data: Data?) {
    self.image = image
    self.data = data
  }
  
  static var transferRepresentation: some TransferRepresentation {
    
    DataRepresentation(importedContentType: .image) { data in
#if canImport(AppKit)
      guard let nsImage = NSImage(data: data) else {
        throw TransferError.importFailed
      }
      let image = Image(nsImage: nsImage)
      return .init(image: image, data: data)
#elseif canImport(UIKit)
      guard let uiImage = UIImage(data: data) else {
        throw TransferError.importFailed
      }
      let image = Image(uiImage: uiImage)
      return .init(image: image,data: data)
#else
      throw TransferError.importFailed
#endif
    }
    
  }
  
}


extension MediaItem: Hashable {
  static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
}
