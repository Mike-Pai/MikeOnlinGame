//
//  CreateGameView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/16.
//

//待處理 ： Firebase資料上傳、讀取及等待室建立的想法～

import SwiftUI

struct CreateGameView: View {
    @ObservedObject var firebaseData : FirebaseData
    
    @Binding var showCreategame : Bool
    @Binding var currentPage: pages
    @Binding var isCreater:Bool
    @Binding var radius:CGFloat
    @Binding var buttondisable:Bool
    @Binding var roomNumber :String
    
    
    
    @State var money :CGFloat = 30000
    @State var showAlert = false
    @State var alertMessage = ""
    @State var roleChose = 0
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.1)
            Rectangle()
                .cornerRadius(30)
                .frame(width: 500, height: 250, alignment: .center)
                .foregroundColor(.orange)
                .opacity(0.8)
                .overlay(
                    VStack{
                        HStack{
                            Spacer()
                            Text("遊戲設定")
                                .padding(10.0)
                            Spacer()
                            Button(action: {
                                
                                buttondisable = false
                                radius = 0
                                showCreategame = false
                                
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                            })
                            .frame(width: 30, height: 30, alignment: .center)
                            .offset(x:-20)
                            
                            
                        }
                        HStack(alignment: .center){
                            Spacer()
                            RoleView(showChangeRole: .constant(true), roleChose: $roleChose)
                            Spacer()
                            if isCreater {
                                VStack{
                                    Text("初始財產：\(Int(money)) ＄")
                                    Slider(value: $money, in: 10000...100000, step: 1000 )
                                }
                                .frame(width: 200)
                            }else{
                                VStack{
                                    Text("輸入房號：")
                                    TextField("", text: $roomNumber)
                                        .background(
                                            Capsule()
                                                .stroke()
                                        )
                                }
                                .frame(width: 200)
                            }
                            
                            Spacer()
                        }
                        if isCreater {
                            Button(action: {
                                    buttondisable = false
                                    radius = 0
                                    showCreategame = false
                                    let roomNumberID = Int.random(in: 1000...10000)
                                    roomNumber = String(roomNumberID)
                                    print(roomNumberID)
                                    let roomData = roomData(roomNumber: String(roomNumberID), personalemail: firebaseData.playerOnce.email, personalnickName: firebaseData.player.nickName, personalChoseRole: roleChose, isHost: true, isready: false)
                                    createRoom(roomData: roomData, roomNumber: String(roomNumberID), email: firebaseData.playerOnce.email)
                               
                                   
 
                                   
                                
                                    currentPage = pages.GameWaitView
                                   
                                
                            }, label: {
                                Text("完成")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .opacity(0.8)
                            })
                            .frame(width: 150)
                            .background(
                                Capsule()
                                    .foregroundColor(.red)
                                
                            )
                            Spacer()
                        }else{
                            Button(action: {
                                checkRoomexist(roomID: roomNumber) { result in
                                    switch result {
                                    case .success(let isExist):
                                        if isExist{
                                            let roomData = roomData(roomNumber: roomNumber, personalemail: firebaseData.playerOnce.email, personalnickName: firebaseData.player.nickName, personalChoseRole: roleChose, isHost: false, isready: false)
                                            createRoom(roomData: roomData, roomNumber: roomNumber, email: firebaseData.playerOnce.email)
                                           
                                           
                                            
                                            currentPage = pages.GameWaitView
                                            
                                        }else{
                                            alertMessage = "房間不存在"
                                            showAlert = true
                                        }
                                        
                                        
                                    case .failure(let error):
                                        
                                        alertMessage = "房間不存在"
                                        showAlert = true
                                        print(error)
                                        
                                        break
                                    }
                                }
                            }, label: {
                                Text("加入")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .opacity(0.8)
                                
                                
                            })
                            .frame(width: 150)
                            .background(
                                Capsule()
                                    .foregroundColor(.blue)
                                
                            )
                            Spacer()
                        }
                        
                    }
                )
            
        }
        .alert(isPresented: $showAlert, content: {() -> Alert in
            let answer = alertMessage
            return Alert(title: Text(answer))
        })
        
    }
}

struct CreateGameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGameView(firebaseData: FirebaseData(), showCreategame: .constant(true), currentPage: .constant(pages.PlayerWaitView), isCreater: .constant(true), radius: .constant(0), buttondisable: .constant(false), roomNumber: .constant("") )
            .previewLayout(.fixed(width: 651, height: 297))
            .environmentObject(FirebaseDataOfRoom())
    }
}
