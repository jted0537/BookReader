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
    
    /* Custom Back Button */
    var btnBack : some View { Button(action: {
        self.mode.wrappedValue.dismiss()
    }) {
            HStack(spacing: 0) {
                Image(systemName: "arrow.left")
                    .foregroundColor(grayLetter)
                    .aspectRatio(contentMode: .fit)
            }

        }
    }
    
    var body: some View {
        VStack{
            Text("gho")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
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
