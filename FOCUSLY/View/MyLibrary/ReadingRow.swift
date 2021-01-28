//
//  ReadingRow.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.


import SwiftUI

struct ReadingRow: View {
    /* State Variables */
    @State private var presentActionSheet = false
    @State private var isSelected = false
    @State var NavActivate: Int? = 0
    @GestureState var longPress = false
    @GestureState var longDrag = false
    /* Binding Variables */
    @Binding var editPressed: Bool
    @Binding var readContent: Int?
    @Binding var contents: Contents
    
    
    var body: some View {
        
        /* Open Source for Tap Gesture */
        let longPressGestureDelay = DragGesture(minimumDistance: 0)
            .updating($longDrag) { currentstate, gestureState, transaction in
                    gestureState = true
            }
        .onEnded { value in
            print(value.translation) // We can use value.translation to see how far away our finger moved and accordingly cancel the action (code not shown here)
            print("long press action goes here")
            editPressed = true
            // 아직 버그???
            isSelected.toggle()
        }

        let shortPressGesture = LongPressGesture(minimumDuration: 0)
        .onEnded { _ in
            print("short press goes here")
            if !editPressed {
                NavActivate = 1
            }
            else{
                isSelected.toggle()
            }
        }

        let longTapGesture = LongPressGesture(minimumDuration: 0.5)
            .updating($longPress) { currentstate, gestureState, transaction in
                gestureState = true
        }

        let tapBeforeLongGestures = longTapGesture.sequenced(before:longPressGestureDelay).exclusively(before: shortPressGesture)
        
        return
            /* Each NavigationLink */
            VStack {
                NavigationLink(destination: BookView(curContent: $contents), tag: 1, selection: $NavActivate){
                    EmptyView()
                }
                
                /* RowUI Vstack */
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        /* Script Info */
                        VStack(alignment: .leading){
                            Text(contents.title)
                            HStack{
                                Text(contents.publisher + "   ")
                                    .font(.footnote)
                                Text(contents.formater.string(from: contents.date))
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
                    /* Script Progress */
                    Text("진척도: \(Int(contents.readProgress*100))%")
                        .font(.caption)
                }
                .padding()
                .background(isSelected ? grayBox : Color.white)
                .cornerRadius(10)
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .shadow(color: Color.secondary.opacity(0.3), radius: 10, y: 5)
                /* Action Sheet -> 나중에 수정될 코드 */
                .actionSheet(isPresented: $presentActionSheet){
                    ActionSheet(title: Text("이 글에 대해 수행할 작업을 선택하세요."), buttons: [
                        .default(Text("좋아요")),
                        .default(Text("삭제")),
                        .default(Text("수정")),
                        .default(Text("공유")),
                        .cancel()
                    ])
                }
                /* Tap Gesture */
                .gesture(tapBeforeLongGestures)
            }

        
        
    }
    
}

//struct ReadingRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadingRow(editPressed: .constant(false), script: Script(recordId: 0, title: "noname", pub: "noauth"))
//    }
//}
