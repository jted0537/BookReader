//
//  MakeScriptView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/27.
//

import SwiftUI

/* Making own cotents */
struct MakeContentsView: View {
    
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
    
    /* PDF, Image callin */
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
                    .background(Color.primary)
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
                        .opacity(contents == "" ? 1 : 0)
                }.cornerRadius(10).padding(.horizontal, 20)
                
                /* "작성완료" Button */
                Button(action: {
                    
                }){
                    ZStack{
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
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("직접입력하기"), displayMode: .inline)
            .navigationBarItems(leading: btnBack, trailing: trailingButton)
            .edgesIgnoringSafeArea(.top)
        }
        
    }
}

struct MakeScriptView_Previews: PreviewProvider {
    static var previews: some View {
        MakeContentsView()
    }
}
