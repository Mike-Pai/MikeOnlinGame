//
//  LoginView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/10.
//

//  待處理 ： 帳號及密碼輸錯的 Alert ～

import SwiftUI
import FirebaseAuth
import AVFoundation

struct LoginView: View {
    @Binding var currentPage:pages
    @Binding var playerAccound: String
    @Binding var name: String
    @Binding var date:Date
    @Binding var showEidtorView:Bool
    @Binding var image:UIImage?
    @State private var playerPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = "歡迎～請先註冊～"
    @State var showregisteView = false
    @State private var showPassword = false
    @State private var showpasswords = "eye.slash"
    @ObservedObject  var firebaseData : FirebaseData
    
    //音效處理：背景音樂播放的切換
    static var bgQueuePlayer = AVQueuePlayer()
    
    static var bgPlayerLooper: AVPlayerLooper!
    
    static func setupBgMusic() {
        guard let url = Bundle.main.url(forResource: "背景音樂", withExtension:"mp3")
        else {
            fatalError("Failed to find sound file.")
            
        }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    
    //這裡是按下登入後會跑得function ，記得直接登入做的function這裡也須要有。
    func login(playerAccoundLogin:String, playerPasswordLogin:String) {
        Auth.auth().signIn(withEmail: playerAccound, password: playerPassword) { result, error in
             guard error == nil else {
                if playerAccound.isEmpty || playerPassword.isEmpty {
                    alertMessage = "請輸入正帳號/密碼"
                    showAlert = true
                }
                print(error?.localizedDescription)
                return
             }
            fetchPlayers(email: playerAccound){ result in
                switch result {
                    case .success(let player):
                        firebaseData.player = player
                        
                    case .failure(let error):
                        print(error)
                    break
                }
            }
            fetchPlayersOnce(email: playerAccound){ result in
                switch result {
                    case .success(let playerOnce):
                        firebaseData.playerOnce = playerOnce
                        name = playerOnce.playername
                        date = playerOnce.joinDate
                    case .failure(let error):
                        print(error)
                    break
                }
            }
            fetchPlayersPhoto(email: playerAccound){ result in
                switch result {
                    case .success(let playerPhoto):
                        downloadUserImage(str:"role", url: playerPhoto.photoURL){ result in
                            switch result {
                            case .success(let downloadImage):
                                image = downloadImage
                            case .failure(_):
                                break
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                    break
                }
            }
            showEidtorView = false
            currentPage = pages.PlayerWaitView
           
        }
    }
    
    func buttonTap() {
            fatalError()
        }

    var body: some View {
        VStack{
            Spacer()
            Text("名探偵コナンＸ大富翁")
                .foregroundColor(.black)
                .font(.body)
                .fontWeight(.heavy)
                .padding(.horizontal, 6.0)
                .background(Color.white)
                .cornerRadius(30)
                .overlay(Capsule().stroke(Color.blue, lineWidth: 4))
                .scaleEffect(2.5)
                .offset(x: 10, y: -15)
                .shadow(radius: 30)
            HStack{
                Text("帳號：")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 50)
                    .foregroundColor(.white)
                TextField("********@email", text: $playerAccound)
                    .font(.title2)
                    .background(
                        Rectangle()
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                    )
                    
            }
            .padding(.top, 35)
            HStack{
                Text("密碼：")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .padding(.leading, 50)
                    .foregroundColor(.white)
                if showPassword {
                    TextField("請輸入至少六位數密碼", text: $playerPassword)
                        .font(.title2)
                        .background(
                            Rectangle()
                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        )
                } else {
                    SecureField("請輸入至少六位數密碼", text: $playerPassword)
                        .font(.title2)
                        .background(
                            Rectangle()
                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        )
                }
                Image(systemName: showpasswords)
                    .background(
                        Rectangle()
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                    )
                    .foregroundColor(.gray)
                    .onTapGesture {
                        showPassword.toggle()
                        if showPassword {
                            showpasswords = "eye"
                        }else{
                            showpasswords = "eye.slash"
                        }
                    }
            }
            
            
            HStack{
                Spacer()
                Button(action: {
                    login(playerAccoundLogin: playerAccound, playerPasswordLogin: playerPassword)
                }, label: {
                    Text("登入")
                        .foregroundColor(.white)
                })
                .padding(.all, 10.0)
                .background(
                    Capsule()
                        .foregroundColor(.red)
                )
                Spacer()
                Button(action: {
                    showregisteView = true
                }, label: {
                    Text("註冊")
                        .foregroundColor(.white)
                })
                .padding(.all, 10.0)
                .background(
                    Capsule()
                        .foregroundColor(.blue)
                )
                Spacer()
                Button(action: buttonTap, label: {
                            Text("Crash")
                                .foregroundColor(.white)
                        })
                .background(
                    Capsule()
                        .foregroundColor(.blue)
                )
            }
            .offset(y: 30)
            Spacer()
            
        }
        .padding()
        .fullScreenCover(isPresented: $showregisteView, content: {
            RegisteView(currentpage: $currentPage, showEidtorView: $showEidtorView, playerName: $name, playerAccoundRegiste: $playerAccound, showRegisteView: $showregisteView)
        })
        .alert(isPresented: $showAlert, content: {() -> Alert in
            let answer = alertMessage
            return Alert(title: Text(answer))
        })
       
        .onAppear(){
            AVPlayer.setupBgMusic()
//            AVPlayer.bgQueuePlayer.play()
            AVPlayer.bgQueuePlayer.volume = 0.3
            if let user = Auth.auth().currentUser {
                print("\(user.uid) login")
                playerAccound = user.email!
                fetchPlayers(email: playerAccound){ result in
                    switch result {
                        case .success(let player):
                            firebaseData.player = player
                            print("Datashow:",firebaseData.player)
                        case .failure(let error):
                            print(error)
                        break
                    }
                }
                fetchPlayersOnce(email: playerAccound){ result in
                    switch result {
                        case .success(let playerOnce):
                            name = playerOnce.playername
                            date = playerOnce.joinDate
                            firebaseData.playerOnce = playerOnce
                        case .failure(let error):
                            print(error)
                        break
                    }
                }
                fetchPlayersPhoto(email: playerAccound){ result in
                    switch result {
                        case .success(let playerPhoto):
                            downloadUserImage(str:"role", url: playerPhoto.photoURL){ result in
                                switch result {
                                case .success(let downloadImage):
                                    image = downloadImage
                                case .failure(_):
                                    break
                                }
                            }
                            
                        case .failure(let error):
                            print(error)
                        break
                    }
                }
                showEidtorView = false
                currentPage = pages.PlayerWaitView
            } else {
                print("not login")
            }
        }
        .background(
            Image("Image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentPage: .constant(pages.LoginView), playerAccound: .constant(""), name: .constant(""), date: .constant(Date()), showEidtorView: .constant(false), image: .constant(UIImage(systemName: "photo")), firebaseData: FirebaseData())
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
