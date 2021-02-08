//
//  MakeScriptView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/27.
//
import SwiftUI
import UIKit
import PDFKit
import UniformTypeIdentifiers
import SNDocx
import Lottie
import Firebase
import AVKit

// Making own cotents
struct MakeContentsView: View {
    @State private var contentsName: String = ""
    @State private var contents: String = ""
    @State private var fileName: String = ""
    @State private var openFile: Bool = false
    @State private var openImage: Bool = false
    @State private var isLoading: Bool = true
    
    @State var image : UIImage?
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @State var showImagePicker : Bool = false // Show Action Sheet
    @State var imageLoadState: Bool = false // Every time recognize image, this will toggle
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode> // Get Back with Swipe
    
    // Set Camera Position
    func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        default :
            return .leftTop
        }
    }
    
    // Using ML for text Recognize Document Text
    func recognizeDocumentText(){
        let vision = Vision.vision()
        let options = VisionCloudDocumentTextRecognizerOptions()
        options.languageHints = ["ko", "en"]
        let textRecognizer = vision.cloudDocumentTextRecognizer()
        
        let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: cameraPosition
        )
        if let realImage = self.image {
            let visionImage = VisionImage(image: realImage)
            visionImage.metadata = metadata
            textRecognizer.process(visionImage) { result, error in
                guard error == nil, let result = result else { return }
                self.contents = result.text
            }
        }
    }
    
    // Custom Back Button - leading
    var btnBack : some View {
        Button(action: {
            self.mode.wrappedValue.dismiss()
        }){
            HStack(spacing: 0) {
                Image(systemName: "arrow.left")
                    .foregroundColor(grayIcon)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    // Filese, Image call in
    var trailingButton : some View {
        HStack(spacing: 10) {
            // Getting .pdf, .docx, .epub, .txt from Device
            Button(action: {
                self.openFile.toggle()
            }){
                Image(systemName: "doc.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(grayIcon)
                    .frame(width: 30, height: 30)
            }
            
            // Getting Image from Device and convert into Contents
            Button(action: {
                self.openImage.toggle()
                // When Click the button -> openImage toggle -> actionsheet appear
            }){
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(grayIcon)
                    .frame(width: 30, height: 30)
            }
            .actionSheet(isPresented: $openImage) {
                ActionSheet(title: Text("이미지를 불러올 방법을 선택하세요"), buttons: [
                    .default(Text("사진")) {
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    },
                    .default(Text("카메라")) {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    },
                    .cancel(Text("취소"))
                ])
            }
        }
        .fullScreenCover(isPresented: self.$showImagePicker, content: { // Make Camera or Album Full Screen
            ImagePicker(image: self.$image, showImagePicker: self.$showImagePicker, imageLoadState: self.$imageLoadState, sourceType: self.sourceType).edgesIgnoringSafeArea(.all) // When Success, showImagePicker is false
        })
        .onChange(of: self.imageLoadState, perform: { value in
            self.recognizeDocumentText()
        }) // Each Image input, imageLoadState will toggle
    }
    
    var body: some View {
        ZStack{
            // When User touch background, hide Keyborad
            grayBackground.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            }
            VStack(spacing: 0) {
                // Contents Name TextField
                TextField("제목을 입력하세요", text: $contentsName)
                    .font(.title3)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .padding(20)
                    .background(Color.background)
                    .cornerRadius(10)
                    .padding(20)
                
                // Contents TextField
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $contents)
                        .font(.subheadline)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                    Text("내용을 입력하세요")
                        .padding(5)
                        .offset(y: 3)
                        .foregroundColor(.secondary).opacity(0.6)
                        .opacity(self.contents == "" ? 1 : 0)
                }
                .padding(20)
                .background(Color.background)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                // "작성완료" Button
                Button(action: {
                    // Not yet
                }){
                    HStack{
                        Spacer()
                        Text("작성완료")
                        Spacer()
                    }.foregroundColor(.white)
                    .frame(height: 50)
                    .background(LinearGradient(gradient: gradationColor , startPoint: .trailing, endPoint: .leading))
                    .cornerRadius(10)
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("직접입력하기"), displayMode: .inline)
            .navigationBarItems(leading: btnBack, trailing: trailingButton)
            .edgesIgnoringSafeArea(.top)
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf, .docx, .epub, .text]) { (res) in
                do {
                    let fileURL = try res.get()
                    guard fileURL.startAccessingSecurityScopedResource() else{
                        self.isLoading = false
                        return
                    } // Setting Accessability
                    
                    self.fileName = fileURL.lastPathComponent
                    
                    // Remove FileName extensions {ex) .pdf, .docx}
                    self.contentsName = String(fileURL.lastPathComponent.prefix(upTo: self.fileName.lastIndex { $0 == "." } ?? self.fileName.endIndex))
                    let extensionFormat = String(fileURL.lastPathComponent.suffix(from: self.fileName.lastIndex { $0 == "." } ?? self.fileName.endIndex))
                    
                    // Read Content from File
                    if extensionFormat == ".pdf" {
                        if let pdf = PDFDocument(url: fileURL) {
                            let pageCount = pdf.pageCount
                            let documentContent = NSMutableAttributedString()
                            
                            for i in 0 ..< pageCount {
                                guard let page = pdf.page(at: i) else { continue }
                                guard let pageContent = page.attributedString else { continue }
                                documentContent.append(pageContent)
                            }
                            self.contents = documentContent.string
                        }
                    }
                    else if extensionFormat == ".docx" {
                        self.contents = SNDocx.shared.getText(fileUrl: fileURL) ?? "불러오기 실패"
                    }
                    else if extensionFormat == ".epub" {
                        
                    }
                    else if extensionFormat == ".txt" {
                        self.contents = try String(contentsOf: fileURL, encoding: .utf8)
                    }
                    else {
                        return
                    }
                }
                catch {
                    print("error reading")
                    print(error.localizedDescription)
                }
            }
            
        }
    }
}



struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var filename: String = "temp"
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {

    }
}
