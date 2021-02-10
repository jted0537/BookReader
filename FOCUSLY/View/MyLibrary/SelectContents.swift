//
//  ReadingRow.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.


import SwiftUI

struct SelectContents: View {
    /* State Variables */
    @State private var presentActionSheet = false
    @State private var isSelected = false
    @State var NavActivate: Int? = 0
    @GestureState var longPress = false
    @GestureState var longDrag = false
    /* Binding Variables */
    @Binding var editPressed: Bool
    
    let formatter = DateFormatter()
    @State var contents: Contents
    
    var body: some View {
        formatter.dateFormat = "y-M-d"
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
                isSelected.toggle()
            }
        
        let longTapGesture = LongPressGesture(minimumDuration: 0.5)
            .updating($longPress) { currentstate, gestureState, transaction in
                gestureState = true
            }
        
        let tapBeforeLongGestures = longTapGesture.sequenced(before:longPressGestureDelay).exclusively(before: shortPressGesture)
        
        return
            /* RowUI Vstack */
            VStack(alignment: .leading, spacing: 10) {
                
                Button(action: {
                    //print("1")
                }) {
                    VStack{
                        HStack {
                            /* Script Info */
                            VStack(alignment: .leading){
                                Text(contents.title)
                                    .foregroundColor(Color.primary)
                                Text(formatter.string(from: contents.date))
                                        .font(.footnote)
                                        .foregroundColor(Color.primary)

                            }
                            Spacer()
                        }
                        /* Script Progress */
                        Text("진척도: \(Int(contents.readProgress*100))%")
                            .font(.caption)
                            .foregroundColor(Color.primary)
                    }.onTapGesture {
                        NavigationLink(destination: ReadContents(curContent: contents)){}
                    }.onLongPressGesture{
                        print("2")
                    }
                    
                    .padding()
                    .padding(.vertical, 5)
                }
                
                /* Each NavigationLink */
                
            }
            .background(isSelected ? Color.secondary : Color.background)
            .cornerRadius(10)
            .padding(.top, 10)
            .padding(.horizontal, 20)
            .shadow(color: Color.secondary.opacity(0.3), radius: 5, y: 5)
            /* Action Sheet -> 나중에 수정될 코드 */
    }
}
