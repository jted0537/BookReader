//
//  MakeScriptView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/27.
//

import SwiftUI

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> MultilineTextView.Coordinator {
        return MultilineTextView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.text = "내용을 입력하세요"
        view.textColor = UIColor(grayIcon.opacity(0.5))
        view.font = .systemFont(ofSize: 16)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.count == 0 {
            
            uiView.isScrollEnabled = true
            uiView.isEditable = true
            uiView.isUserInteractionEnabled = true
            uiView.text = "내용을 입력하세요"
            uiView.textColor = UIColor(grayIcon.opacity(0.5))
            uiView.font = .systemFont(ofSize: 16)
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent : MultilineTextView
        init(parent1: MultilineTextView){
            parent = parent1
        }
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .label
        }
    }
}


/* Making own cotents */
struct MakeScriptView: View {
    
    @State var contentsName: String = ""
    @State var contents: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
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
    
    var trailingButton : some View {
        HStack(spacing: 10) {
             
            /* Getting PDF from Device */
            Button(action: {
                
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
            offWhite.ignoresSafeArea()
            VStack{
                TextField("제목을 입력하세요", text: $contentsName)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                
                MultilineTextView(text: $contents)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                
                Button(action: {}){
                    Text("작성완료")
                }
                 
            }
            .background(offWhite)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("직접입력하기"), displayMode: .inline)
            .navigationBarItems(leading: btnBack, trailing: trailingButton)
            .edgesIgnoringSafeArea(.top)
        }
        
    }
}

struct MakeScriptView_Previews: PreviewProvider {
    static var previews: some View {
        MakeScriptView()
    }
}
