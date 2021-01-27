//
//  ReadingRow.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.


import SwiftUI

struct ReadingRow: View {
    @State private var presentActionSheet = false
    @State private var longPressed = false
    
    @Binding var editPressed: Bool
    @Binding var readContent: Int?
    @Binding var script: Script
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading){
                    Text(script.title)
                    HStack{
                        Text(script.publisher + "   ")
                            .font(.footnote)
                        Text(script.formater.string(from: script.date))
                            .font(.footnote)
                    }
                    
                }
                Spacer()
                
                // 추후 생략될 코드
                Image(systemName: "ellipsis")
                    .onTapGesture {
                        self.presentActionSheet = true
                    }
                    .rotationEffect(.degrees(90))
                
            }
            Text("진척도: \(Int(script.readProgress*100))%")
                .font(.caption)
        }
        .padding()
        .background(longPressed ? grayBox : Color.white)
        .cornerRadius(10)
        .padding(.top, 10)
        .padding(.horizontal, 20)
        .shadow(color: Color.secondary.opacity(0.3), radius: 10, y: 5)
        .actionSheet(isPresented: $presentActionSheet){
            ActionSheet(title: Text("이 글에 대해 수행할 작업을 선택하세요."), buttons: [
                .default(Text("좋아요")),
                .default(Text("삭제")),
                .default(Text("수정")),
                .default(Text("공유")),
                .cancel()
            ])
        }
        .onTapGesture {
            if editPressed {
                longPressed.toggle()
            }
            else{
                self.readContent = script.id
            }
        }
        .onLongPressGesture {
            self.editPressed = true
            longPressed = true
        }
        
    }
    
}

//struct ReadingRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadingRow(editPressed: .constant(false), script: Script(recordId: 0, title: "noname", pub: "noauth"))
//    }
//}
