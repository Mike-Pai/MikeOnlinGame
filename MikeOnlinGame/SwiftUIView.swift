//
//  SwiftUIView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/30.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Image("大富翁")
            .resizable()
            .scaledToFit()
            .frame(width: 500, height: 250, alignment: .center)
            .overlay(
                VStack{
                    Spacer()
                    Text("米花首富")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.yellow)
                        .background(
                            Rectangle()
                                .stroke(lineWidth: 3)
                                .foregroundColor(.white)
                        )
                    Spacer()
                    HStack{
                        Button(action: {
                            
                        }, label: {
                            Text("排行榜")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 80)
                                .background(
                                    Capsule()
                                        .foregroundColor(.blue)
                                    
                                )
                        })
                        .frame(width: 80)
                        Button(action: {
                            
                        }, label: {
                            Text("返回主頁")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 80)
                                .background(
                                    Capsule()
                                        .foregroundColor(.red)
                                    
                                )
                        })
                        .frame(width: 80)
                        
                    }
                    .offset(y:20)
                }
                
            )
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
