//
//  Usedatas.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/18.
//

import Foundation
import SwiftUI

struct offsetXY : Identifiable{
    var id = UUID()
    var x :CGFloat
    var y :CGFloat
}

struct mapItem :Identifiable{
    var id = UUID()
    var index : Int
    var itemlevel:Int
    var itemName:String
    var x :CGFloat
    var y :CGFloat
    var playerColorIndex : Int
}

let Role = [
    "灰原0",
    "灰原1",
    "柯南0",
    "柯南1",
    "新一",
]

struct house {
    var level1 : String
    var level2 : String
    var level3 :String
}

var playerColor = [
    Color.clear,
    Color.red,
    Color.blue,
    Color.yellow,
    Color.orange,
]

//let map2 = [
//    mapItem(itemlevel: 0, itemName: "帝丹小學(起點)", x: 0, y: -140),
//    mapItem(itemlevel: 0, itemName: "工藤宅", x: -55, y: -110),
//    mapItem(itemlevel: 0, itemName: "米花公園", x: 55, y: -110),
//    mapItem(itemlevel: 0, itemName: "米花大酒店", x: -110, y: -80),
//    mapItem(itemlevel: 0, itemName: "米花警察署", x: 110, y: -80),
//    mapItem(itemlevel: 0, itemName: "毛利偵探事務所", x: -165, y: -50),
//    mapItem(itemlevel: 0, itemName: "米花圖書館", x: 165, y: -50),
//    mapItem(itemlevel: 0, itemName: "東都電視塔", x: -220, y: -20),
//    mapItem(itemlevel: 0, itemName: "多羅碧加樂園",x: 220, y: -20),
//    mapItem(itemlevel: 0, itemName: "鈴木宅", x: -165, y: 10),
//    mapItem(itemlevel: 0, itemName: "帝丹高中", x: 165, y: 10),
//    mapItem(itemlevel: 0, itemName: "米花美術館", x: -110, y: 40),
//    mapItem(itemlevel: 0, itemName: "米花綜合醫院", x: 110, y: 40),
//    mapItem(itemlevel: 0, itemName: "南部水族館", x: -55, y: 70),
//    mapItem(itemlevel: 0, itemName: "米花車站", x: 55, y: 70),
//    mapItem(itemlevel: 0, itemName: "阿笠宅", x: 0, y: 100),
//
//]

let roleOffset = [
    offsetXY(x: 0, y: 0),
    offsetXY(x: 30, y: -15),
    offsetXY(x: 0, y: -30),
    offsetXY(x: -30, y: -15)
]




struct PlayerMove {
    var targetLocation = 0
    var currentLocation = 0
}
