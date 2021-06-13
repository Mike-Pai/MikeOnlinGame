//
//  RegisteView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/11.
//

import SwiftUI
import FirebaseAuth

struct RegisteView: View {
    
    @Binding var currentpage : pages
    @State private var alertMessage = ""
    @State var showAlert = false
    @State private var playerName = ""
    @State private var playerAccoundRegiste = ""
    @State private var playerPasswordRegister = ""
    @Binding var showRegisteView:Bool
    @State private var showPassword = false
    @State private var showpasswords = "eye.slash"
    @State var registerState = false
    
    func register(playerAccoundRegiste:String, playerPasswordRegister:String) {
        Auth.auth().createUser(withEmail: playerAccoundRegiste, password: playerPasswordRegister) { result, error in
            
            if let user = result?.user,
               error == nil{
                print(user.email, user.uid)
                
                let playerOnce = PlayerOnce(playername: playerName, joinDate: Date(), email: playerAccoundRegiste)
                createPlayerOnce(storeData: playerOnce)
                alertMessage = "😆註冊成功😆"
                registerState = true
                showAlert = true
                
                
            }else {
                print(error?.localizedDescription)
                registerState = false
                showAlert = true
                alertMessage = "😢註冊失敗，請再試一次😢"
                return
            }
            return
            
        }
    }
    var body: some View {
        VStack{
            Form{
                Text("註冊：")
                HStack{
                    Text("姓名")
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("請輸入姓名", text: $playerName)
                }
                HStack{
                    Text("信箱")
                    Image(systemName: "envelope")
                        .foregroundColor(.secondary)
                    TextField("********@email", text: $playerAccoundRegiste)
                }
                HStack{
                    Text("密碼")
                    Image(systemName: "lock")
                        .foregroundColor(.secondary)
                    if showPassword {
                        TextField("請輸入至少六位數密碼", text: $playerPasswordRegister)
                    } else {
                        SecureField("請輸入至少六位數密碼", text: $playerPasswordRegister)
                    }
                    Image(systemName: showpasswords)
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
                    Text("確定註冊")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            register(playerAccoundRegiste: playerAccoundRegiste, playerPasswordRegister: playerPasswordRegister)
                            
                        }
                    Spacer()
                    Text("取消重填")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            playerAccoundRegiste = ""
                            playerPasswordRegister = ""
                            playerName = ""
                        }
                    Spacer()
                }
            }
            Button(action: {
                showRegisteView = false
            }, label: {
                Text("已有帳號？按此處登入→")
            })
            Spacer()
        }
//        .alert(isPresented: $showAlert, content: {() -> Alert in
//            let answer = alertMessage
//            return Alert(title: Text(answer))
//        })
        .alert(isPresented: $showAlert, content: { Alert(
            title: Text(alertMessage),
            message: Text(""),
            dismissButton: .destructive(Text("確定")) {
                if registerState {
                    
                   
                    currentpage = pages.PlayerWaitView
                }
            }
        )
        })
        
    }
}

struct RegisteView_Previews: PreviewProvider {
    static var previews: some View {
        RegisteView(currentpage: .constant(pages.RegisteView), showRegisteView: .constant(true))
            .previewLayout(.fixed(width: 651, height: 297))
    }
}



//.alert(isPresented:$showInviteRoomAlert) {
//                            Alert(
//                                title: Text("建立遊戲或加入遊戲?"),
//                                message: Text(""),
//                                primaryButton: .destructive(Text("建立")) {
//                                    //print("Deleting...")
//                                    showHomePage = false
//                                    showCreateGamePage = true
//                                },
//                                secondaryButton: .destructive(Text("加入")) {
//                                    //print("Deleting...")
//                                    showHomePage = false
//                                    showJoinGamePage = true
//                                }
//                            )
//                        }
