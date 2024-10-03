//
//  CustomPlayLine.swift
//  MyBookApp
//
//  Created by Гриша Шкробов on 15.08.2024.
//

import SwiftUI

struct CustomPlayLine: View {
    
    @Binding var value: CGFloat
    
    @State var procentValue = 0.0
    
    @Binding var currentSeconds: Int
    @Binding var nowTapp: Bool
    
    let lineSize: CGFloat
    let allSeconds: Int
    
    var body: some View {
        HStack{
            Text(getTimeFromSecond(second: currentSeconds))
                .foregroundStyle(.gray)
                .font(.system(size: 14))
                .frame(width: 50)
                .lineLimit(1)
            ZStack(alignment: .leading){
                GeometryReader{ geometry in
                    
                }
                .frame(width: lineSize, height: 4)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(100)
                GeometryReader{ geometry in
                    
                }
                .frame(width: value, height: 4)
                .background(Color.blue)
                .cornerRadius(100)
                Image(systemName: "circle.fill")
                    .foregroundColor(.blue)
                    .offset(x: -5)
                    .offset(x: value)
            }
            .gesture(
                DragGesture()
                    .onChanged({ gesture in
                        
                        nowTapp = true
                        
                        withAnimation{
                            value = gesture.location.x
                        }
                        
                        if(value > lineSize){
                            withAnimation{
                                value = lineSize
                            }
                        }
                        if(value < 0){
                            withAnimation{
                                value = 0
                            }
                        }
                        
                        procentValue = value/lineSize
                        
                        currentSeconds = Int(Double(allSeconds)*procentValue)
                    
                    })
                    .onEnded({ gesture in
                        nowTapp = false
                    })
            )
            .onTapGesture { point in
                
                nowTapp.toggle()
                
                withAnimation{
                    value = point.x
                }
                
                procentValue = value/lineSize
                
                currentSeconds = Int(Double(allSeconds)*procentValue)
                
                nowTapp.toggle()
                
            }
            Text(getTimeFromSecond(second:allSeconds))
                .foregroundStyle(.gray)
                .font(.system(size: 14))
                .frame(width: 50)
                .lineLimit(1)
        }
    }
    
    private func getTimeFromSecond(second: Int) -> String {
        
        let minCount = second/60
        
        let seconds = second%60
        
        return "\(minCount/10)\(minCount%10):\(seconds/10)\(seconds%10)"
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

struct CustomPlayLine_Preview: PreviewProvider{
    
    @State static var abc = 0
    static var cba = 100
    @State static var cba1: CGFloat = 0
    private static let lineSize = UIScreen.screenWidth/2+50
    @State private static var boold = true
    
    static var previews: some View {
        CustomPlayLine(value: $cba1, currentSeconds: $abc, nowTapp: $boold, lineSize: lineSize, allSeconds: cba)
    }
    
}
