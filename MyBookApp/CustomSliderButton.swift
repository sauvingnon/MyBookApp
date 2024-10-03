//
//  CustomSliderButton.swift
//  MyBookApp
//
//  Created by Гриша Шкробов on 15.08.2024.
//

import SwiftUI

struct CustomSliderButton: View {
    
    @Binding var isTapped: Bool
    
    var body: some View {
        Button(action: {
            isTapped.toggle()
        }, label: {
            HStack(alignment: .center, spacing: 27){
                Image(systemName: "headphones")
                    .foregroundStyle(.black)
                Image(systemName: "text.alignleft")
                    .foregroundStyle(.black)
            }
            .overlay(content: {
                Image(systemName: isTapped ? "text.alignleft" : "headphones")
                    .animation(.none)
                    .padding(12)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(100)
                    .offset(x: isTapped ? 24 : -24.0)
            })
            .frame(width: 100, height: 50)
            .background(.white)
            .cornerRadius(100)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
            )
        })
    }
        
}

struct CustomSliderButton_Preview: PreviewProvider{
    
    @State static var state = true
    
    static var previews: some View {
        CustomSliderButton(isTapped: $state)
    }
    
}
