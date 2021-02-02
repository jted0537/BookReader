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

/* Making own cotents */
struct MakeContentsView: View {
    
    @State private var contentsName: String = ""
    @State private var contents: String = ""
    @State private var fileName: String = ""
    @State private var openFile: Bool = false
    
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
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf, .word, .epub, .text]) { (res) in
                do {
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
                        let newURL = fileURL.deletingPathExtension().appendingPathExtension("pdf")
                        print(fileURL)
                        print(newURL)
                        guard newURL.startAccessingSecurityScopedResource() else{
                            return
                        }
                        try FileManager.default.moveItem(at: fileURL, to: newURL)
                        
                        if let pdf = PDFDocument(url: newURL) {
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
                    else if extensionFormat == ".epub" {
                        
                        
                    }
                    else if extensionFormat == ".txt" {
                        self.contents = try String(contentsOf: fileURL, encoding: .utf8)
                    }
                    else {return}
                    

                }
                catch {
                    print("error reading")
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
}


