//
//  PlayerWaitView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/12.
//

import SwiftUI
import FirebaseAuth

struct PlayerWaitView: View {
    @Binding var currentPage : pages
    @Binding var email : String
    @Binding var playerName: String
    @Binding var date : Date
    @State var playerInformations = [PlayerOnce]()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Binding  var showEidtorView :Bool
    @State private var gender = "男"
    @State private var Constellation = "請選擇星座"
    @State private var birthday = Date()
    @State private var nickname = ""
    @Binding var image:UIImage?
    @ObservedObject var firebaseData : FirebaseData
    let genders = ["男", "女","其他"]
    let constellations = ["未公開","魔羯座", "水瓶座", "雙魚座", "牡羊座", "金牛座", "雙子座", "巨蟹座", "獅子座", "處女座", "天秤座", "天蠍座", "射手座", ]
    var textView: some View {
        WebView()
    }
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("登入資訊：")
                    .font(.title)
                Text(email)
                    .font(.title)
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
            if showEidtorView{
                HStack{
                    VStack{
                        Text("創建角色")
                            .font(.title)
                        
                        Button(action: {
                            
                            currentPage = pages.CreateRoleView
                            
                        }, label: {
                            Image(uiImage: image ?? UIImage(systemName: "photo")! )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 200, alignment: .center)
                        })
                        
                        HStack{
                            Spacer()
                            Text("姓名：")
                                .font(.title)
                            Text(playerName)
                                .font(.title)
                            Spacer()
                        }
                    }
                    
                    VStack{
                        Text("編輯個人資訊")
                            .font(.title)
                        VStack(alignment: .leading){
                            
                            HStack{
                                Text("綽號：")
                                    .font(.title)
                                TextField("小白ZZZ~",text: $nickname)
                                    .font(.title)
                                    .background(
                                        Rectangle()
                                            .stroke(lineWidth: 3)
                                            .cornerRadius(10)
                                    )
                            }
                            HStack{
                                
                                Text("性別 : ")
                                    .font(.title)
                                Picker("",selection: $gender) {
                                    ForEach(genders, id: \.self) { (gender) in
                                        Text(gender)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 200)
                                
                            }
                            //                            HStack{
                            //                                //                        Spacer()
                            //                                Text("星座 : ")
                            //                                    .font(.title)
                            //
                            //                                Picker(selection: $Constellation,label:Text(Constellation).font(.title)) {
                            //                                    ForEach(constellations, id: \.self) { (constellation) in
                            //                                        Text(constellation)
                            //                                    }
                            //                                }
                            //                                .clipped()
                            //                                .shadow(radius: 30)
                            //                                .pickerStyle(MenuPickerStyle())
                            //                                .frame(width: 240)
                            //
                            //                            }
                            HStack{
                                Text("生日 : ")
                                    .font(.title)
                                DatePicker("", selection: $birthday, displayedComponents: .date)
                                    .font(.title)
                                    .frame(width: 180)
                            }
                            HStack{
                                Text("加入時間：")
                                    .font(.title)
                                Text(date,style: .date)
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal, 3)
                        .background(
                            Color.white.opacity(0.8).cornerRadius(20)
                        )
                        Button(action: {
                            
                            let player = Player(constellation: Constellation, birthday: birthday, nickName: nickname, gender: gender)
                            createPlayer(storeData: player, email: email)
                            showEidtorView = false
                            fetchPlayers(email: email){ result in
                                switch result {
                                    case .success(let player):
                                        firebaseData.player = player
                                        
                                    case .failure(let error):
                                        print(error)
                                    break
                                }
                            }
                        }, label: {
                            Text("確認")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            
                        })
                        .padding(.all, 3)
                        .background(Color.secondary)
                        .cornerRadius(20)
                        
                    }
                    .padding(.bottom, 3.0)
                    .background(
                        Color.yellow.opacity(0.8).cornerRadius(20)
                    )
                }
                
                
                
            }else{
                
                HStack{
                    VStack{
                        Button(action: {
                            
                            currentPage = pages.CreateRoleView
                            
                        }, label: {
                            Image(uiImage: image ?? UIImage(systemName: "photo")! )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 200, alignment: .center)
                        })
                        
                        HStack{
                            Spacer()
                            Text(playerName)
                                .font(.title)
                            Spacer()
                        }
                    }
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text("個人檔案")
                                .font(.title)
                                .offset(x:35)
                            Spacer()
                            Button(action: {
                                showEidtorView = true
                                fetchPlayers(email: email){ result in
                                    switch result {
                                        case .success(let player):
                                            firebaseData.player = player
                                            let nameTempUse = firebaseData.player.nickName
                                            let genderTempUse = firebaseData.player.gender
                                            let birthdayTempUse = firebaseData.player.birthday
                                            nickname = nameTempUse
                                            gender = genderTempUse
                                            birthday = birthdayTempUse
                                            
                                        case .failure(let error):
                                            print(error)
                                        break
                                    }
                                }
                            }, label: {
                                Image("Editor")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 20)
                            })
                            
                        }
                        .padding(.top, 5.0)
                        VStack(alignment: .leading){
                            
                            HStack{
                                Text("綽號：")
                                    .font(.title)
                                Text(firebaseData.player.nickName)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 200)
                            }
                            HStack{
                                
                                Text("性別 : ")
                                    .font(.title)
                               Text(firebaseData.player.gender)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .frame(width: 240)
                                
                            }
                            //                            HStack{
                            //                                //                        Spacer()
                            //                                Text("星座 : ")
                            //                                    .font(.title)
                            //
                            //                                Picker(selection: $Constellation,label:Text(Constellation).font(.title)) {
                            //                                    ForEach(constellations, id: \.self) { (constellation) in
                            //                                        Text(constellation)
                            //                                    }
                            //                                }
                            //                                .clipped()
                            //                                .shadow(radius: 30)
                            //                                .pickerStyle(MenuPickerStyle())
                            //                                .frame(width: 240)
                            //
                            //                            }
                            HStack{
                                Text("生日 : ")
                                    .font(.title)
                                Text(firebaseData.player.birthday, style: .date)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 230)
                                
                                
                            }
                            HStack{
                                Text("加入時間：")
                                    .font(.title)
                                Text(date,style: .date)
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal, 3)
                        .background(
                            Color.white.opacity(0.8).cornerRadius(20)
                        )
                        
                        
                    }
                    .padding(.bottom, 3.0)
                    .background(
                        Color.yellow.opacity(0.8).cornerRadius(20)
                    )
                }
                
            }
            
            
            Spacer()
            
        }
        .alert(isPresented: $showAlert, content: {() -> Alert in
            let answer = alertMessage
            return Alert(title: Text(answer))
        })
       
    }
    
    
    
    
    
    
}

struct PlayerWaitView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerWaitView(currentPage: .constant(pages.PlayerWaitView), email: .constant(""), playerName: .constant(""), date: .constant(Date()), showEidtorView: .constant(false), image: .constant(UIImage(systemName: "photo")!), firebaseData: FirebaseData())
            .previewLayout(.fixed(width: 651, height: 335))
        
    }
}
