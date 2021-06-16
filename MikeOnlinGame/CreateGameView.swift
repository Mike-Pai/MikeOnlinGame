//
//  CreateGameView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/16.
//

//待處理 ： Firebase資料上傳、讀取及等待室建立的想法～

import SwiftUI

struct CreateGameView: View {
    @Binding var showCreategame : Bool
    @Binding var currentPage: pages
    @Binding var isCreater:Bool
    @Binding var radius:CGFloat
    @Binding var buttondisable:Bool
    
    @State var money :CGFloat = 30000
    @State var roomNumber = ""
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
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .offset(x:-20)
                            
                        }
                        HStack(alignment: .center){
                            Spacer()
                            RoleView(showChangeRole: .constant(true))
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
    }
}

struct CreateGameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGameView(showCreategame: .constant(true), currentPage: .constant(pages.PlayerWaitView), isCreater: .constant(true), radius: .constant(0), buttondisable: .constant(false))
            .previewLayout(.fixed(width: 651, height: 297))
    }
}
