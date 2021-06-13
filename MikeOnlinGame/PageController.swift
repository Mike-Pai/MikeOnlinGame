//
//  PageController.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/13.
//

import SwiftUI
enum pages{
    case LoginView, PlayerWaitView,RegisteView
}
struct PageController: View {
    @State var currentPage = pages.LoginView
    var body: some View {
        ZStack{
            switch currentPage
            {
                case pages.LoginView: LoginView(currentPage: $currentPage)
                case pages.PlayerWaitView: PlayerWaitView(currentPage: $currentPage)
                case pages.RegisteView: RegisteView(currentpage: $currentPage, showRegisteView: .constant(true))
            }
        }
    }
}

struct PageController_Previews: PreviewProvider {
    static var previews: some View {
        PageController()
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
