//
//  GameWaitView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/16.
//

//待處理 ： Firebase讀取其他玩家的資料還有畫面(像是尚未加入玩家時的畫面)～

import SwiftUI

struct GameWaitView: View {
    @Binding var currentpage : pages
    @Binding var uiImage : UIImage?
    @Binding var email :String

    
    @State var playername = "白謹瑜"
    @State var inviteNumber = "003520"
    @State var nickName = "小白"
    @State var showChangeRole = false
    @ObservedObject var firebaseData : FirebaseData
    var body: some View {
        VStack{
            ZStack{
                
                HStack{
                    
                    Button(action: {
                        currentpage = pages.PlayerWaitView 
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.black)
                        
                        
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                    Spacer()
                    Text("邀請碼：\(inviteNumber)")
                }
                .padding(10.0)
                .background(
                    Color.blue
                    
                )
                HStack{
                    Spacer()
                    Text("\(playername) 的房間")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            
            HStack{
                Spacer()
                PlayrtView(showChangeRole: $showChangeRole, uiImage: $uiImage, nickName: $firebaseData.player.nickName)
                Spacer()
                PlayrtView(showChangeRole: $showChangeRole, uiImage: $uiImage, nickName: $firebaseData.player.nickName)
                Spacer()
                PlayrtView(showChangeRole: $showChangeRole, uiImage: $uiImage, nickName: $firebaseData.player.nickName)
                Spacer()
                PlayrtView(showChangeRole: $showChangeRole, uiImage: $uiImage, nickName: $firebaseData.player.nickName)
                Spacer()
            }
            Spacer()
        }
        .background(
            Image("Image1")
                .resizable()
                .scaledToFill()
        )
    }
}

struct GameWaitView_Previews: PreviewProvider {
    static var previews: some View {
        GameWaitView(currentpage: .constant(pages.GameWaitView), uiImage: .constant(UIImage(systemName: "photo")), email: .constant(""), firebaseData: FirebaseData())
            .previewLayout(.fixed(width: 651, height: 297))
    }
}



struct PlayrtView: View {
    @Binding var showChangeRole :Bool
    @Binding var uiImage:UIImage?
    @Binding var nickName:String
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
                Text(nickName)
                Spacer()
            }
            .background(Color.orange)
            RoleView(showChangeRole: $showChangeRole)
            Button(action: {
                
            }, label: {
                Text("開始遊戲")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(0.8)
            })
            .frame(width: 150)
            .background(
                Capsule()
                    .foregroundColor(.secondary)
                
            )
            
        }
        .frame(width: 160)
    }
}

struct RoleView: View {
    @Binding var showChangeRole:Bool
    var body: some View {
        VStack{
          
            HStack{
                Spacer()
                if showChangeRole{
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.left.square.fill")
                            .background(Color.secondary)
                    }
                    .foregroundColor(.white)
                }
                Spacer()
                Text("灰原")
                Spacer()
                if showChangeRole{
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.right.square.fill")
                            .background(Color.secondary)
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
            .background(Color.red)
            Image("ai")
                .resizable()
                .scaledToFit()
                .frame(width: 120,height: 130, alignment: .center)
                .background(
                    Circle()
                        .foregroundColor(.white)
                )
            
            
            
            
        }
        .frame(width: 150)
        .background(
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.9)
        )
    }
}
