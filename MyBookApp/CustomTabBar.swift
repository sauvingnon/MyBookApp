import SwiftUI

enum TabType: String{
    case yesterday
    case hello
    case tomorrow
}

struct CustomTabBar: View {
    
    @State var selectedTab: TabType = .yesterday
    
    var body: some View {
        HStack{
            Spacer()
            Button {
                selectedTab = .yesterday
            } label: {
                VStack(alignment: .center, spacing: 4){
                    Image(systemName: "arrowshape.left.fill")
                        .imageScale(.large)
                        .scaleEffect(1.2)
                        .padding(.bottom, 5)
                    Text("Yesterday")
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .tint(selectedTab == .yesterday ? Color.blue : Color.gray)
            .padding(15)
            Spacer()
            Button {
                selectedTab = .hello
            } label: {
                VStack(alignment: .center, spacing: 4){
                    Text("Hello")
                        .font(.system(size: 20, weight: .medium))
                }
            }
            .tint(selectedTab == .hello ? Color.blue : Color.gray)
            .padding(15)
            Spacer()
            Button {
                selectedTab = .tomorrow
            } label: {
                VStack(alignment: .center, spacing: 4){
                    Image(systemName: "arrowshape.right.fill")
                        .imageScale(.large)
                        .scaleEffect(1.2)
                        .padding(.bottom, 5)
                    Text("Tomorrow")
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .tint(selectedTab == .tomorrow ? Color.blue : Color.gray)
            .padding(15)
            Spacer()
        }
        .frame(height: 50, alignment: .bottom)
    }
    
}

struct CustomTabBar_Previews: PreviewProvider {
    
    @State private static var state: TabType = .yesterday
    
    static var previews: some View {
        CustomTabBar()
    }
}

//extension CustomTabBar{
//    private func CustomizeTabItem(tab: TabType) -> some View{
//        Button {
//            selectedTab = tab
//        } label: {
//            VStack(alignment: .center, spacing: 4){
//                Image(selectedTab == tab ? tab.rawValue + "_selected" : tab.rawValue)
//            }
//        }
//        .tint(Color.gray)
//        .padding(15)
//    }
//}
