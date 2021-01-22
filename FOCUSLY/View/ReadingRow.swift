//
//  ReadingRow.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.
//

import SwiftUI

struct ReadingRow: View {
    @State private var presentActionSheet = false
    var reading: Book
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading){
                    Text(reading.title)
                    HStack{
                        Text(reading.publisher + "   ")
                            .font(.footnote)
                        Text(reading.formater.string(from: reading.date))
                            .font(.footnote)
                    }
                    
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .onTapGesture {
                        self.presentActionSheet = true
                    }
                    .rotationEffect(.degrees(90))
            }
            Text("진척도: \(Int(reading.readProgress*100))%")
                .font(.caption)
        }
        .padding()
        .background(Color.white)
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
    }
}

struct ReadingRow_Previews: PreviewProvider {
    static var previews: some View {
        ReadingRow(reading: Book(recordId: 0, title: "noname", pub: "noauth"))
    }
}
