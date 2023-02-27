//
//  PhotoComposerViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 27/02/2023.
//

import SwiftUI
import CoreTransferable
import PhotosUI

class PhotoComposerViewModel: ObservableObject{
  @Published var imageStates: [PickerImageStateWrap] = []
  
  @Published var selectedItems: [PhotosPickerItem] = [] {
    didSet {
      imageStates = selectedItems.map{ item in
        return PickerImageStateWrap(item)
      }
    }
  }
  
  @Published var selectedSelectedItem: PickerImageStateWrap? = nil
  
  func postImages(){
    // now do something
  }
}


enum ImageState {
  
  case loading(_ progress: Progress)
  case empty
  case success(_ image: Image)
  case failure(_ error: Error)
  
}

class PickerImageStateWrap: Identifiable, ObservableObject {
  let pickerItem: PhotosPickerItem
  @Published var state: ImageState
  @Published var description: String = ""
  
  var id: String
  
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

extension PickerImageStateWrap: Hashable {
  static func == (lhs: PickerImageStateWrap, rhs: PickerImageStateWrap) -> Bool {
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
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
        #if canImport(AppKit)
            guard let nsImage = NSImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(nsImage: nsImage)
          return .init(image: image)
        #elseif canImport(UIKit)
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(uiImage: uiImage)
          return .init(image: image)
        #else
            throw TransferError.importFailed
        #endif
        }
    }
}
