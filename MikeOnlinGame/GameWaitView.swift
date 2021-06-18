//
//  GameWaitView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/16.
//

//待處理 ： Firebase讀取其他玩家的資料還有畫面(像是尚未加入玩家時的畫面)～

import SwiftUI
import Kingfisher

struct GameWaitView: View {
    @Binding var currentpage : pages
    @Binding var email :String
    @Binding var inviteNumber:String
    
    @State var playername = "白謹瑜"
    @State var isReadyWord = "準備"
    @State var readyColor = Color.secondary
    @State var showChangeRole = false
   
    let exitNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("Host exit"))
    let startNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("game start"))

    @StateObject var firebaseOfRoomdata = FirebaseDataOfRoom()
    @ObservedObject var firebaseData : FirebaseData
    var body: some View {
        VStack{
            ZStack{
                
                HStack{
                    
                    Button(action: {
                        firebaseOfRoomdata.deleteplayer(roomID: inviteNumber, email: email)
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
                ForEach(0..<4){ index in
                    PlayrtView(index: index).environmentObject(firebaseOfRoomdata)
                }
                Spacer()
                
            }
            Spacer()
            Button(action: {
                firebaseOfRoomdata.playerself.isready.toggle()
                firebaseOfRoomdata.changeIsReady(roomID: inviteNumber, email: email)
            }, label: {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.yellow)
                    .overlay(
                        Text(firebaseOfRoomdata.playerself.isHost ? "開 始 遊 戲" : firebaseOfRoomdata.playerself.isready ? "取消準備" : "準    備")
                            .foregroundColor(.black)
                            .font(.title)
                            
                    )
                    
            })
            .frame(width: 250, height: 40)
            Spacer()
        }
        .background(
            Image("Image1")
                .resizable()
                .scaledToFill()
        )
        .onReceive(exitNotificaiton, perform: { _ in
                   print("Host Exit")

//                   appSettings.view = "LobbyView"
//                   AVPlayer.waitQueuePlayer.removeAllItems()
//                   AVPlayer.setupLobbyMusic()
//                   AVPlayer.lobbyQueuePlayer.volume = Float(0.5)
//                   AVPlayer.lobbyQueuePlayer.play()
                   
               })
               .onReceive(startNotificaiton, perform: { _ in
                   print("Start")
//                   print(gameSettings.room.GameID)
//                   gameSettings.roomListener!.remove()
//                   gameSettings.myIndex = gameSettings.user.roomIndex
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                       appSettings.view = "GameView"
//                       AVPlayer.waitQueuePlayer.removeAllItems()
//                       AVPlayer.setupGameMusic()
//                       AVPlayer.gameQueuePlayer.volume = Float(0.5)
//                       AVPlayer.gameQueuePlayer.play()
                   }
               })
        .onAppear(){
            fetchplayerInformation(roomID: inviteNumber, email: email) { result in
                switch result{
                case .success(let playerInformation):
                    firebaseOfRoomdata.playerself = playerInformation
                case .failure(_):
                    break
                }
            }
            firebaseOfRoomdata.checkRoomsChange(roomID: inviteNumber){ result in
//                switch result{
//                case .success(let changetype):
//                    if changetype == "added"{
////                        frtchplayerInformation(roomID: inviteNumber) { result in
////                            switch result {
////                            case .success(let playerInformation):
////                                firebaseOfRoomdata.player.removeAll()
////                                for i in playerInformation.indices{
////                                    let j = playerInformation.count-1-i
////                                    firebaseOfRoomdata.player.append(playerInformation[j])
////                                    fetchPlayersPhoto(email: firebaseOfRoomdata.player[i].personalemail){ result in
////                                        switch result {
////                                        case .success(let playerPhoto):
////                                            firebaseOfRoomdata.playerphoto.append(playerPhoto)
////                                            print("成功")
////
////                                        case .failure(let error):
////                                            print("錯誤",error)
////                                            break
////                                        }
////                                    }
////                                }
////                                print("確認人數",firebaseOfRoomdata.player)
////                            case .failure(_):
////                                print("錯誤")
////                                break
////                            }
//                        }
//                    }else if changetype == "modified"{
//
//                    }else if changetype == "removed"{
//
//                    }
//
//                case .failure(_):
//                    break
//                }
            }

            
            
        }
            
            
        
    }
}

struct GameWaitView_Previews: PreviewProvider {
    static var previews: some View {
        GameWaitView(currentpage: .constant(pages.GameWaitView), email: .constant(""), inviteNumber: .constant(""), firebaseData: FirebaseData())
            .previewLayout(.fixed(width: 651, height: 297))
            .environmentObject(FirebaseDataOfRoom())
            .environmentObject(FirebaseData())
           
    }
}

 

struct PlayrtView: View {
    @State var showChangeRole = false
    @State var uiImage = ""
    @State var nickName = ""

    @EnvironmentObject var firebaseOfRoomdata : FirebaseDataOfRoom
    var index: Int = 0
    var body: some View {
        VStack{
            HStack{
                if index < firebaseOfRoomdata.playerphoto.count && index < firebaseOfRoomdata.player.count{
                    Spacer()
                    KFImage(firebaseOfRoomdata.playerphoto[index].photoURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Text(firebaseOfRoomdata.player[index].personalnickName)
                    Spacer()
                   
                }else{
                    Spacer()
                       Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Text("等待加入")
                    Spacer()
                        
                }
                   
                
            }
            .frame(width: 150)
            .background(Color.orange)
            if index < firebaseOfRoomdata.player.count{
                RoleView(showChangeRole: $showChangeRole, roleChose: $firebaseOfRoomdata.player[index].personalChoseRole)
            }
            
            if index < firebaseOfRoomdata.player.count{
                Text(firebaseOfRoomdata.player[index].isHost ? "室長": "準備")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .frame(width: 150)
                    .background(
                        Capsule()
                            .foregroundColor(firebaseOfRoomdata.player[index].isready ? .yellow : .gray)
                    )
            }else{
                
                Text("準備")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .frame(width: 150)
                    .background(
                        Capsule()
                            .foregroundColor(Color.gray)
                    )
            }
            
        }
        .frame(width: 160)
        
            
        
        
    }
}

struct RoleView: View {
    @Binding var showChangeRole:Bool
    @Binding var roleChose: Int
    var body: some View {
        VStack{
            
            HStack{
                Spacer()
                if showChangeRole{
                    Button(action: {
                        if roleChose != 0{
                            roleChose = roleChose - 1
                        }
                    }) {
                        Image(systemName: "arrow.left.square.fill")
                            .background(Color.secondary)
                    }
                    .foregroundColor(.white)
                }
                Spacer()
                Text(Role[roleChose])
                Spacer()
                if showChangeRole{
                    Button(action: {
                        if roleChose != Role.count - 1{
                            roleChose = roleChose + 1
                        }
                    }) {
                        Image(systemName: "arrow.right.square.fill")
                            .background(Color.secondary)
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
            .background(Color.red)
            Image(Role[roleChose])
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


