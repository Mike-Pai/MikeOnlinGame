//
//  PlayerWaitView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/12.
//

import SwiftUI
import FirebaseAuth

struct PlayerWaitView: View {
    @Binding var currentPage :pages
    @State var playerInformation = [PlayerOnce]()
    var textView: some View {
        WebView()
    }
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("登入資訊：")
                    .font(.title2)
                Text("email")
                    .font(.title3)
                Button(action: {
                    do {
                       try Auth.auth().signOut()
                        currentPage = pages.LoginView
                    } catch {
                       print(error)
                    }
                }, label: {
                    Text("登出")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                })
                .padding(.horizontal, 10.0)
                .background(
                    Capsule()
                        .foregroundColor(.red)
                )
                Spacer()
            }
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
            HStack{
                Spacer()
                VStack{
                    Image("peter0")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200, alignment: .center)
                    Text("Placeholder")
                   // 角色圖及名稱
                }
                VStack{
                    Text("個人檔案")
                    Text("個人檔案")
                    Text("個人檔案")
                    Text("個人檔案")
                    Text("個人檔案")
                    
                    Text("個人檔案")
                   // 角色圖及名稱
                }
                Spacer()
            }
           
           
            
            Spacer()
            
        }
        .onAppear(){
            playerInformation = fetchPlayersOnce() // 06/14 目前還每辦法正確顯示玩家的資料
        }
        
    }
}

struct PlayerWaitView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerWaitView(currentPage: .constant(pages.PlayerWaitView))
            .previewLayout(.fixed(width: 651, height: 297))

    }
}
