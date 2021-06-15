//
//  PageController.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/13.
//

import SwiftUI
import FirebaseAuth

enum pages{
    case LoginView, PlayerWaitView, RegisteView, CreateRoleView
}
struct PageController: View {
    @State var currentPage = pages.LoginView
    @State var email = ""
    @State var name = ""
    @State var date = Date()
    @State var showEidtorView = true
    @State var image : UIImage?
    @StateObject private var firebaseData = FirebaseData()
    var body: some View {
        ZStack{
            switch currentPage
            {
            case pages.LoginView: LoginView(currentPage: $currentPage, playerAccound: $email, name: $name, date: $date, showEidtorView: $showEidtorView, image: $image, firebaseData: firebaseData)
            case pages.PlayerWaitView: PlayerWaitView(currentPage: $currentPage, email: $email, playerName: $name, date: $date, showEidtorView: $showEidtorView, image: $image, firebaseData: firebaseData)
            case pages.RegisteView: RegisteView(currentpage: $currentPage, showEidtorView: $showEidtorView, playerName: $name, playerAccoundRegiste: $email, showRegisteView: .constant(false))
            case pages.CreateRoleView: CreateRoleView(currentpage: $currentPage, uiImage: $image, email: $email)
            }
        }
//        .onAppear(){
//            do {
//                try Auth.auth().signOut()
//                currentPage = pages.LoginView
//            } catch {
//                print(error)
//            }
//        }
        
    }
}

struct PageController_Previews: PreviewProvider {
    static var previews: some View {
        PageController( image: UIImage(systemName: "photo")!)
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
