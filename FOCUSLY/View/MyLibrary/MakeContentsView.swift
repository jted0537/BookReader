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
/* Making own cotents */
struct MakeContentsView: View {
    
    @State private var contentsName: String = ""
    @State private var contents: String = ""
    @State private var fileName: String = ""
    @State private var openFile: Bool = false
    @State var isLoading: Bool = false
    @State var hasTimeElapsed = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    /* Custom Back Button - leading */
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
    
    /* PDF, Image callin */
    var trailingButton : some View {
        HStack(spacing: 10) {
            
            /* Getting PDF from Device */
            Button(action: {
                self.openFile.toggle()
            }){
                Image(systemName: "doc.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(grayIcon)
                    .frame(width: 30, height: 30)
            }
            
            /* Getting Image from Device and convert into Contents*/
            Button(action: {
                
            }){
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(grayIcon)
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    var body: some View {
        ZStack{
            /* When User touch background, hide Keyborad */
            grayBackground.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            }
            VStack(spacing: 0){
                /* Get Contents Name */
                TextField("제목을 입력하세요", text: $contentsName)
                    .font(.title3)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .padding(20) /* Inner Padding */
                    .background(Color.background)
                    .cornerRadius(10)
                    .padding(20) /* Outer Padding */
                
                
                /* Get Contents */
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
                .padding(20) /* Inner Padding */
                .background(Color.background)
                .cornerRadius(10)
                .padding(.horizontal, 20) /* Outer Padding */
                
                /* "작성완료" Button */
                Button(action: {
                    //self.openFile.toggle()
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
                    self.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        hasTimeElapsed = true
                    }
                    let fileURL = try res.get()
                    guard fileURL.startAccessingSecurityScopedResource() else{
                        return
                    } /* Setting Accessability */
                    
                    self.fileName = fileURL.lastPathComponent
                    
                    /* Remove FileName extensions {ex) .pdf, .docx} */
                    self.contentsName = String(fileURL.lastPathComponent.prefix(upTo: self.fileName.lastIndex { $0 == "." } ?? self.fileName.endIndex))
                    let extensionFormat = String(fileURL.lastPathComponent.suffix(from: self.fileName.lastIndex { $0 == "." } ?? self.fileName.endIndex))
                    
                    /* Read Content from File */
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
                        print("docx")
                        self.contents = SNDocx.shared.getText(fileUrl: fileURL) ?? "불러오기 실패"
                        
                    }
                    else if extensionFormat == ".epub" {
                        
                    }
                    else if extensionFormat == ".txt" {
                        self.contents = try String(contentsOf: fileURL, encoding: .utf8)
                    }
                    else {return}
                    self.isLoading = false
                }
                catch {
                    print("error reading")
                    print(error.localizedDescription)
                }
            }
            
            if self.openFile {
                LottieView()
            }
        }
        
    }
}


struct AnimationsView: UIViewRepresentable {
    @Binding var show: Bool
    
    func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(name: "loading", bundle: Bundle.main)
        view.loopMode = .loop
        if show {
            view.play()
        }
        else {
            view.stop()
        }
        return view
    }
    
    func updateUIView(_ uiView: AnimationView, context: UIViewRepresentableContext<AnimationsView>) {
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
    //animationView.contentMode = .scaleAspectFit
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
  
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) { }
}
