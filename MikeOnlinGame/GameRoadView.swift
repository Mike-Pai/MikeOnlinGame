//
//  Game.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/20.
//

import SwiftUI



struct GameRoadView: View {
    @Binding var size :CGSize
    @Binding var roadText :String
    var body: some View {
      
        
            IsometricView(active: true, extruded: true, depth: 10) {
                ZStack{
                   
                    Rectangle()
                        .stroke()
                    Text(roadText)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 55)
                        
                }
                
            }
            
            .frame(width: size.width, height: size.height, alignment: .center)
            .scaledToFit()
        
    }
    
}

struct GameRoadView_Previews: PreviewProvider {
    static var previews: some View {
        GameRoadView(size: .constant(CGSize(width: 70, height: 70)), roadText:.constant("帝丹小學(起點)"))
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
