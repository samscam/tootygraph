//
//  PhotoPicker.swift
//  Tootygraph
//
//  Created by Sam on 17/01/2024.
//

import Foundation
import SwiftUI

import CoreTransferable
import PhotosUI


class PhotoPickerViewModel: ObservableObject{
    
    @Published var mediaItems: [MediaItem] = []
    @Published var selectedItem: MediaItem?
    
}
struct PhotoPickerView: View {
    let viewModel: PhotoPickerViewModel
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                VStack(alignment:.center, spacing:0){
                    
                    
                    LazyHStack(spacing:0){
                        ForEach(viewModel.mediaItems){ item in
                            item.image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(0)
                                .padding(.horizontal,7)
                                .tag(item)
                                .onTapGesture {
                                    viewModel.selectedItem = item
                                }
                                .opacity(viewModel.selectedItem == item ? 1.0 : 0.4)
                        }
                    }
                    .frame(height:150)
                    
                    
                    
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                }
                .padding(.vertical, 20)
                .background{
                    FilmEdge().fill(Color.black,style: FillStyle(eoFill: true))
                    //          Color.black
                }
            }
            
            Spacer()
            CameraView()
        }
        
        
        //
        //    VStack{
        //
        //      ScrollView(.horizontal, showsIndicators: false) {
        //        HStack{
        //          ForEach(viewModel.mediaItems){ item in
        //            item.image?
        //              .resizable()
        //              .aspectRatio(contentMode: .fit)
        //              .photoFrame()
        //              .frame(maxWidth:150)
        //          }
        //        }.padding()
        //      }
        //
        //      Spacer()
        //
        //        .frame(maxHeight:300)
        //      Spacer()
        //    }
    }
}


#Preview{
    let viewModel = PhotoPickerViewModel()
    return PhotoPickerView(viewModel: viewModel)
}



//
//      if (viewModel.wrappedPickerItems.count > 0){
//        PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 4,
//                     matching: .images) {
//          Text("Change selection")
//        }
//      }
//      if (viewModel.mediaItems.count == 0){
//        VStack{
//
//          PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 4) {
//            Text("Pick from library")
//          }
//                       .font(.title)
//                       .buttonStyle(.borderedProminent)
//          Spacer()
//          Button("Camera") {
//            showingCamera = true
//          }.font(.title)
//            .buttonStyle(.borderedProminent)
//        }
//      } else {
//        TabView(selection: $viewModel.tabSelection){
//
//          ForEach(viewModel.mediaItems){ item in
//            ImageMetaEditor(wrap: item)
//              .focused($focussedItem, equals: item)
//              .tag(Optional(item))
//          }
//          if (viewModel.wrappedPickerItems.count > 0){
//            Button("Send it") {
//              viewModel.postImages()
//            }.font(.title)
//              .buttonStyle(.borderedProminent)
//              .tag(Optional<WrappedPickerItem>.none)
//
//          }
//        }.tabViewStyle(.page)
//
//
//
//
//      }
//    }
//    .sheet(isPresented: $showingCamera, content: {
//      CameraView(isPresented: $showingCamera)
//    })
//    .onChange(of: viewModel.tabSelection) { newValue in
//      focussedItem = newValue
//    }
//
//  }
//}
//struct ImageMetaEditor: View {
//  @ObservedObject var mediaItem: MediaItem
//  var body: some View {
//    VStack{
//      PickedImageView(mediaItem: mediaItem)
//        .padding()
//
//        TextField(text: $mediaItem.description, prompt: Text("Describe this image"), axis:.vertical ){
//          Label("Description", systemImage: "pencil")
//        }
//
//        .padding(10)
//        .background(RoundedRectangle(cornerRadius: 10).fill(.tertiary))
//        .padding(5)
//        .padding(.bottom,40)
//
//      }
//  }
//}
//
//struct PickedImageView: View {
//  @ObservedObject var mediaItem: MediaItem
//  var body: some View {
//    switch mediaItem.image {
//    case .success(let image):
//      image
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//        .photoFrame()
//    case .failure(let error):
//      Text(error.localizedDescription)
//    case .loading(let progress):
//      ProgressView(value: progress.fractionCompleted)
//    case .empty:
//      Text("empty")
//    }
//  }
//}



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
