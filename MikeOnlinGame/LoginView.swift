//
//  LoginView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/10.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var currentPage:pages
    @State private var playerAccound = ""
    @State private var playerPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = "歡迎～請先註冊～"
    @State var showregisteView = false
    @State private var showPassword = false
    @State private var showpasswords = "eye.slash"
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
            currentPage = pages.PlayerWaitView
           
        }
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
                .background(
                    Image("彌豆子")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: -30))
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: -185, y: -70)
                )
                .background(
                    Image("善逸")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: 30))
                        .frame(width: 90, height: 90, alignment: .center)
                        .offset(x: 190, y: -70)
                )
            
            HStack{
                Text("帳號：")
                    .font(.title2)
                    .padding(.leading, 100.0)
                TextField("********@gmail.com", text: $playerAccound)
                    .font(.title2)
                    .background(
                        Rectangle()
                            .stroke()
                    )
            }
            .padding(.top, 35)
            HStack{
                Text("密碼：")
                    .font(.title2)
                    .padding(.leading, 100.0)
                if showPassword {
                    TextField("請輸入至少六位數密碼", text: $playerPassword)
                        .font(.title2)
                        .background(
                            Rectangle()
                                .stroke()
                        )
                } else {
                    SecureField("請輸入至少六位數密碼", text: $playerPassword)
                        .font(.title2)
                        .background(
                            Rectangle()
                                .stroke()
                        )
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
            }
            .offset(y: 30)
            Spacer()
            
        }
        .padding()
        .fullScreenCover(isPresented: $showregisteView, content: {
            RegisteView(currentpage: $currentPage, showRegisteView: $showregisteView)
        })
        .alert(isPresented: $showAlert, content: {() -> Alert in
            let answer = alertMessage
            return Alert(title: Text(answer))
        })
        .onAppear(){
          
            if let user = Auth.auth().currentUser {
                print("\(user.uid) login")
                currentPage = pages.PlayerWaitView
            } else {
                print("not login")
            }
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentPage: .constant(pages.LoginView))
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
