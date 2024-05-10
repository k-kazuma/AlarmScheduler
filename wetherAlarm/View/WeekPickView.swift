import SwiftUI


struct weekPicker {
    var index: Int
    var dayOfWeek: String
    var isActive: Bool
    
//    mutating func toggle() {
//        self.isActive.toggle()
//    }
}

struct WeekPickView: View {
    
    @Binding var weeks:[Int]
    
    let index = [0,1,2,3,4,5,6]
    
    @State var dayOfWeek: [weekPicker] = [
        weekPicker(index: 0, dayOfWeek: "日曜日", isActive: false),
        weekPicker(index: 1, dayOfWeek: "月曜日", isActive: false),
        weekPicker(index: 2, dayOfWeek: "火曜日", isActive: false),
        weekPicker(index: 3, dayOfWeek: "水曜日", isActive: false),
        weekPicker(index: 4, dayOfWeek: "木曜日", isActive: false),
        weekPicker(index: 5, dayOfWeek: "金曜日", isActive: false),
        weekPicker(index: 6, dayOfWeek: "土曜日", isActive: false)
    ]
    
    var body: some View {
        
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
                        weeks.append(dayOfWeek[i].index)
                        
                    } else {
                        if let index = weeks.firstIndex(where: {$0 == dayOfWeek[i].index}) {
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
        .scrollContentBackground(.hidden)
        .background(backGroundGlay)
    }
}



