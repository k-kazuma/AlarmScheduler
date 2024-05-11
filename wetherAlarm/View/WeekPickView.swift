import SwiftUI


struct weekPicker: Hashable {
    var id: Int
    var dayOfWeek: String
    var isActive: Bool
}

struct WeekPickView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var weeks:[Int]
    
    let index = [0,1,2,3,4,5,6]
    
    @State var dayOfWeek: [weekPicker] = [
        weekPicker(id: 0, dayOfWeek: "日曜日", isActive: false),
        weekPicker(id: 1, dayOfWeek: "月曜日", isActive: false),
        weekPicker(id: 2, dayOfWeek: "火曜日", isActive: false),
        weekPicker(id: 3, dayOfWeek: "水曜日", isActive: false),
        weekPicker(id: 4, dayOfWeek: "木曜日", isActive: false),
        weekPicker(id: 5, dayOfWeek: "金曜日", isActive: false),
        weekPicker(id: 6, dayOfWeek: "土曜日", isActive: false)
    ]
    
    var body: some View {
        
        ZStack{
            backGroundBlack
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("曜日を選択")
                        .modifier(TitleModifier())
                    Spacer()
                }
                Form{
                    Section{
                        List(index, id: \.self) { i in
                            Button(action: {
                                dayOfWeek[i].isActive.toggle()
                            }, label: {
                                HStack{
                                    Text(dayOfWeek[i].dayOfWeek)
                                    Spacer()
                                    if dayOfWeek[i].isActive {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(fontOrenge)
                                    }
                                }
                                .onChange(of: dayOfWeek[i].isActive){
                                    if dayOfWeek[i].isActive == true {
                                        weeks.append(dayOfWeek[i].id)
                                    } else {
                                        if let index = weeks.firstIndex(where: {$0 == dayOfWeek[i].id}) {
                                            weeks.remove(at: index)
                                        }
                                    }
                                    weeks.sort { $0 < $1 }
                                    print(weeks)
                                }
                            })
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .padding(5)
                            .listRowBackground(backGroundGlay)
                            .background(backGroundGlay)
                            
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(backGroundBlack)
                
//                List(index, id: \.self) { i in
//                    Button(action: {
//                        dayOfWeek[i].isActive.toggle()
//                    }, label: {
//                        HStack{
//                            Text(dayOfWeek[i].dayOfWeek)
//                            Spacer()
//                            if dayOfWeek[i].isActive {
//                                Image(systemName: "checkmark")
//                                    .foregroundColor(fontOrenge)
//                            }
//                        }
//                        .onChange(of: dayOfWeek[i].isActive){
//                            if dayOfWeek[i].isActive == true {
//                                weeks.append(dayOfWeek[i].id)
//                                
//                            } else {
//                                if let index = weeks.firstIndex(where: {$0 == dayOfWeek[i].id}) {
//                                    weeks.remove(at: index)
//                                }
//                            }
//                            weeks.sort { $0 < $1 }
//                            print(weeks)
//                        }
//                    })
//                    .foregroundColor(.white)
//                    .font(.system(size: 25))
//                    .padding(5)
//                    .listRowBackground(backGroundGlay)
//                    .background(backGroundGlay)
//                }
//                .padding(0)
//                .frame(width: width*0.9)
//                .scrollContentBackground(.hidden)
//                .background(backGroundGlay)
                
                Button("戻る"){
                    Task{
                        dismiss()
                    }
                    
                }
                .buttonStyle(mainButtonStyle())
                Spacer()
                    .frame(height: 1)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}



