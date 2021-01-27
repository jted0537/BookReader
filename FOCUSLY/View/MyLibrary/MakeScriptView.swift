//
//  MakeScriptView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/27.
//

import SwiftUI

/* Making own cotents */
struct MakeScriptView: View {
    
    @State var contetnsName: String = ""
    @State var contents: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    /* Custom Back Button - leading */
    var btnBack : some View { Button(action: {
        self.mode.wrappedValue.dismiss()
    }) {
            HStack(spacing: 0) {
                Image(systemName: "arrow.left")
                    .foregroundColor(grayIcon)
                    .aspectRatio(contentMode: .fit)
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
            }
            
            /* Getting Image from Device and convert into Contents*/
            Button(action: {
            
            }){
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(grayIcon)
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("gho")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle(Text("직접입력하기"), displayMode: .inline)
                .navigationBarItems(leading: btnBack, trailing: trailingButton)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MakeScriptView_Previews: PreviewProvider {
    static var previews: some View {
        MakeScriptView()
    }
}
