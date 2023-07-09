//
//  PhotoComposer.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 26/02/2023.
//

import SwiftUI
import PhotosUI

struct PhotoComposer: View {
  @ObservedObject var viewModel: PhotoComposerViewModel
  
  var body: some View {
    VStack{
      ScrollView(.horizontal, showsIndicators: false){
        VStack(alignment:.center, spacing:0){
          FilmEdge()
        
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
          FilmEdge()
        }
        
        .background{
          Color.black
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

struct FilmEdge: View {
  let holeSize = CGSize(width: 15, height: 15)
  let space: CGFloat = 15
  let padding: CGFloat = 7
  
  var body: some View {
    GeometryReader { geometry in
      let cols = Int(geometry.size.width / holeSize.width)
      HStack(spacing:space){
        ForEach(0 ..< cols){ _ in
          RoundedRectangle(cornerRadius: 4).foregroundColor(.white).frame(width: holeSize.width, height: holeSize.height)
        }
      }.padding(.vertical,padding)
    }.frame(height: holeSize.height+padding*2)
  }
}

struct PhotoComposer_Previews: PreviewProvider{
  static let previewViewModel = {
    let vm = PhotoComposerViewModel(tootClient: nil)
//    vm.mediaItems.append(MediaItem(image: Image("heaton") , data: nil))
    vm.mediaItems.append(MediaItem(image: Image("hat") , data: nil))
    vm.mediaItems.append(MediaItem(image: Image("macs") , data: nil))
    vm.mediaItems.append(MediaItem(image: Image("carp") , data: nil))
    return vm
  }()
  static var previews: some View{
    PhotoComposer(viewModel: previewViewModel)
  }
  
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
