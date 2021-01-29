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
            grayBackground.ignoresSafeArea()
            VStack(spacing: 0){
                TextField("제목을 입력하세요", text: $contentsName)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                
                MultilineTextView(text: $contents)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                Button(action: {}){
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
        MakeContentsView()
    }
}
