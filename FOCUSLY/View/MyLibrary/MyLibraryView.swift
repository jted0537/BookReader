//
//  MyLibraryView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/22.
//
import SwiftUI



// My Library Middle Screen
struct MyLibraryView: View {
    @State private var editPressed: Bool = false
    @State private var readContent: Int? = nil
    @State private var editMode = EditMode.inactive
    let formatter = DateFormatter()
    @ObservedObject var articleViewModel = ArticleViewModel()
    
    init() {
        // Remove Padding and Set BackgroundColor of List
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        UITableView.appearance().backgroundColor = UIColor(grayBackground)
    }
    
    func getTimeFormat(time: Int) -> String {
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    private func onDelete(offsets: IndexSet) {
        articleViewModel.removeArticle(articleIdx: offsets[offsets.startIndex])
        // Delete from database should be first (Index problem)
        articleViewModel.article.remove(atOffsets: offsets)
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        articleViewModel.article.move(fromOffsets: source, toOffset: destination)
        // This will change Article order (Both View and Model)
        articleViewModel.updateArticle()
    }
    
    // My Library Main View
    var body: some View {
        VStack(spacing: 0) {
            // 1st Item: "오늘의 읽기", Progress Bar
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    
                    HStack(alignment: .top) {
                        Text("오늘의 읽기").font(.title).bold().foregroundColor(grayLetter).bold()
                        
                        Image(systemName: "gearshape.fill").font(.system(size: 10)).foregroundColor(.secondary).opacity(0.8)
                        
                    }
                    HStack(spacing:0){
                        Text("00:00").foregroundColor(usuallyColor)
                        Text("/07:00").foregroundColor(grayLetter)
                    }.padding(.bottom, 15)
                    Text("매일 책을 읽어 통계 수치를 높이고 더 많은 도서를 완독하세요!").foregroundColor(grayLetter).font(.caption)
                }
                Spacer()
                ZStack(alignment: .trailing){
                    Circle()
                        .foregroundColor(grayCircle)
                        .frame(width: 120, height: 120)
                    
                    //                    Path { path in
                    //                        path.addArc(center: .init(x: 60, y: 60), radius: 60, startAngle: .degrees(0), endAngle: .degrees(360*user.todayReadingRatio), clockwise: true)
                    //                    }
                    //                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    //                    .foregroundColor(usuallyColor)
                    //                    .frame(width: 120, height: 120)
                    //                    .rotationEffect(.degrees(90))
                    
                    Text("0%").foregroundColor(grayLetter).font(.title).bold()
                        .frame(width: 120, height: 120)
                } // Progress Circle
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            
            // Article List
            List{
                ForEach(articleViewModel.article) { article in
                    NavigationLink(destination: ArticleView(curArticle: article)){
                        /* Script Info */
                        VStack(alignment: .leading){
                            Text(article.articleTitle)
                                .foregroundColor(grayLetter)
                            Text(article.createdDate)
                                .font(.footnote)
                                .foregroundColor(Color.secondary)
                            HStack{
                                Spacer()
                                Text("0%")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                    }
                    .padding()
                    .padding(.vertical, 10)
                    .background(Color.background)
                    .cornerRadius(10)
                    .shadow(color: Color.secondary.opacity(0.4), radius: 5, y: 5)
                }
                .onDelete(perform: onDelete)
                //.onMove(perform: onMove)
            }
            .environment(\.editMode, $editMode)
            .listStyle(SidebarListStyle())
            
            // Repeat Button
            HStack(spacing: 3){
                Button(action: {}){
                    HStack{
                        Spacer()
                        Image(systemName: "repeat")
                        Text("전체반복")
                        Spacer()
                    }.frame(height: 60).background(usuallyColor)
                    
                }
                Button(action: {}){
                    HStack{
                        Spacer()
                        Image(systemName: "shuffle")
                        Text("랜덤읽기")
                        Spacer()
                    }.frame(height: 60).background(usuallyColor)
                    
                }
            }.foregroundColor(Color.white)
            
        }.onAppear{ articleViewModel.fetchArticle() }
        
    }
}
