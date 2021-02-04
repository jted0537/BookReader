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
        
        /* for Tap Gesture ( short press / long press classified ) */
        
        /* When Short Pressed */
        let shortPressGesture = LongPressGesture(minimumDuration: 0)
            .onEnded { _ in
                if !editPressed {
                    NavActivate = 1
                }
                else{
                    isSelected.toggle()
                }
            }
        
        /* When Long Pressed */
        //        VStack(alignment: .leading, spacing: 10) {
        //            NavigationLink(destination: ContentsView(curContent: $contents), tag: 1, selection: $NavActivate) {
        //                VStack{
        //                    HStack {
        //                        /* Script Info */
        //                        VStack(alignment: .leading){
        //                            Text(contents.title)
        //                                .foregroundColor(.primary)
        //                            HStack{
        //                                Text(contents.publisher + "   ")
        //                                    .font(.footnote)
        //                                    .foregroundColor(.primary)
        //                                Text(contents.formater.string(from: contents.date))
        //                                    .font(.footnote)
        //                                    .foregroundColor(.primary)
        //                            }
        //                        }
        //                        Spacer()
        //                    }
        //                    /* Script Progress */
        //                    Text("진척도: \(Int(contents.readProgress*100))%")
        //                        .font(.caption)
        //                        .foregroundColor(.primary)
        //                }.onTapGesture {
        //                    self.NavActivate = 1
        //                }.onLongPressGesture {
        //                    self.editPressed = true
        //                }
        //                .padding()
        //                .padding(.vertical, 5)
        //                //.background(self.editPressed ? Color.secondary : Color.background)
        //            }.background(self.editPressed ? Color.secondary : Color.background)
        //        }
        //        .cornerRadius(10)
        //        .padding(.top, 10)
        //        .padding(.horizontal, 20)
        //        .shadow(color: Color.secondary.opacity(0.5), radius: 5, y: 5)
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
        
        let longTapGesture = LongPressGesture(minimumDuration: 0.5)
            .updating($longPress) { currentstate, gestureState, transaction in
                gestureState = true
            }
        
        let tapBeforeLongGestures = longTapGesture.sequenced(before:longPressGestureDelay).exclusively(before: shortPressGesture)
        
        /* Body of ReadingRow */
        return
            /* RowUI Vstack */
            VStack(alignment: .leading, spacing: 10) {
                /* Each NavigationLink */
                NavigationLink(destination: ContentsView(curContent: $contents), tag: 1, selection: $NavActivate){
                    VStack{
                        HStack {
                            /* Script Info */
                            VStack(alignment: .leading){
                                Text(contents.title)
                                    .foregroundColor(Color.primary)
                                HStack{
                                    Text(contents.publisher + "   ")
                                        .font(.footnote)
                                        .foregroundColor(Color.primary)
                                    Text(contents.formater.string(from: contents.date))
                                        .font(.footnote)
                                        .foregroundColor(Color.primary)
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
                            .foregroundColor(Color.primary)
                    }
                    /* Tap Gesture */
                    .gesture(tapBeforeLongGestures)
                    
                }
                .padding()
                .padding(.vertical, 5)
            }
            .background(isSelected ? Color.secondary : Color.background)
            .cornerRadius(10)
            .padding(.top, 10)
            .padding(.horizontal, 20)
            .shadow(color: Color.secondary.opacity(0.5), radius: 5, y: 5)
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
    }
}
