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


struct MediaItem: Identifiable {
  var id: String
  var type: AttachmentType
  var description: String
  var data: Data  
}

class PhotoComposerViewModel: ObservableObject{
  @Published var wrappedPickerItems: [WrappedPickerItem] = []
  
  @Published var selectedItems: [PhotosPickerItem] = [] {
    didSet {
      wrappedPickerItems = selectedItems.map{ item in
        return WrappedPickerItem(item)
      }
      tabSelection = wrappedPickerItems.first
    }
  }
  
  @Published var tabSelection: WrappedPickerItem?
  
  let tootClient: TootClient?
  
  init(tootClient: TootClient?){
    self.tootClient = tootClient
  }
  
  func postImages(){
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
    let progress = loadTransferable(from: pickerItem)
    state = .loading(progress)
  }
  
  func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: TransferImage.self) { result in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let image?):
          self.state = .success(image.image)
        case .success(nil):
          self.state = .empty
        case .failure(let error):
          self.state = .failure(error)
          
        }
      }
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

struct TransferImage: Transferable {
  let image: Image
  let data: Data
  
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
