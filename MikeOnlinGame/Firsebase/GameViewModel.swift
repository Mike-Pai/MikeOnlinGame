//
//  GameViewModel.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/21.
//

import SwiftUI
import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Game: ObservableObject {
    @Published var gamePlayers = [GamePlayer]()
    @Published var map = [GameMapInformation]()
    @Published var gamePlayerSelf = GamePlayer(rolePosition: 0, goAhead: 0, isChangeToYou: false, money: 0, house: "", playerIndex: 0)
    
    @Published var players = [PlayerMove(), PlayerMove(), PlayerMove(), PlayerMove()] // 與玩家順序加入關聯 ~
    
    @Published var map1 = [
        mapItem(index: 0, itemlevel: 1, itemName: "帝丹小學(起點)", x: 0, y: 100, playerColorIndex: 5),
        mapItem(index: 1, itemlevel: 0, itemName: "工藤宅", x: -55, y: 70, playerColorIndex: 0),
        mapItem(index: 2, itemlevel: 0, itemName: "米花圖書館", x: -110, y: 40, playerColorIndex: 0),
        mapItem(index: 3, itemlevel: 0, itemName: "赤井宅", x: -165, y: 10, playerColorIndex: 0),
        mapItem(index: 4, itemlevel: 1, itemName: "米花警察署", x: -220, y: -20, playerColorIndex: 5),
        mapItem(index: 5, itemlevel: 0, itemName: "毛利偵探事務所", x: -165, y: -50, playerColorIndex: 0),
        mapItem(index: 6, itemlevel: 0, itemName: "米花超市", x: -110, y: -80, playerColorIndex: 0),
        mapItem(index: 7, itemlevel: 0, itemName: "高木宅", x: -55, y: -110, playerColorIndex: 0),
        mapItem(index: 8, itemlevel: 1, itemName: "多羅碧加樂園",x: 0, y: -140, playerColorIndex: 5),
        mapItem(index: 9, itemlevel: 0, itemName: "鈴木宅", x: 55, y: -110, playerColorIndex: 0),
        mapItem(index: 10, itemlevel: 0, itemName: "帝丹高中", x: 110, y: -80, playerColorIndex: 0),
        mapItem(index: 11, itemlevel: 0, itemName: "青山宅", x: 165, y: -50, playerColorIndex: 0),
        mapItem(index: 12, itemlevel: 1, itemName: "米花綜合醫院", x: 220, y: -20, playerColorIndex: 5),
        mapItem(index: 13, itemlevel: 0, itemName: "宮野宅", x: 165, y: 10, playerColorIndex: 0),
        mapItem(index: 14, itemlevel: 0, itemName: "東都電視塔", x: 110, y: 40, playerColorIndex: 0),
        mapItem(index: 15, itemlevel: 0, itemName: "阿笠宅", x: 55, y: 70, playerColorIndex: 0),

    ]
    
    @Published var playerColor = [
        Color.white,
        Color.red,
        Color.blue,
        Color.yellow,
        Color.orange,
        Color.gray
    ]
    @Published var hosel1 = [
        house(level1: "帝丹小學(起點)1", level2: "帝丹小學(起點)1", level3: "帝丹小學(起點)1"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "圖書館1", level2: "圖書館2", level3: "圖書館3"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "米花警察署1", level2: "米花警察署1", level3: "米花警察署1"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "超市1", level2: "超市2", level3: "超市3"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "多羅碧加樂園1", level2: "多羅碧加樂園1", level3: "多羅碧加樂園1"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "帝丹高中1", level2: "帝丹高中1", level3: "帝丹高中1"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "米花綜合醫院1", level2: "米花綜合醫院2", level3: "米花綜合醫院2"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
        house(level1: "東都電視塔", level2: "東都電視塔", level3: "東都電視塔"),
        house(level1: "房子31", level2: "房子32", level3: "房子33"),
    ]
    
    var locationsCount = 16
    var timer: Timer.TimerPublisher?
    var anyCancellable: AnyCancellable?
  
    func roomDateOrder(){
        gamePlayers.sort {
            return $0.playerIndex < $1.playerIndex
        }
    }
    
    func mapOrder(){
        map.sort {
            return $0.mapIndex < $1.mapIndex
        }
    }
    
   
    
    func playerMove(currentPlayerIndex:Int, goAhead: Int,completion:  @escaping (String,Int)-> Void) {
        
        var player = players[currentPlayerIndex]
        player.targetLocation = (player.targetLocation + goAhead) % locationsCount
        players[currentPlayerIndex] = player
        
        anyCancellable = Timer.publish (every: 0.25, on: .main, in: .common).autoconnect().sink(receiveValue: {[self] _ in
            var player = players[currentPlayerIndex]
            if player.currentLocation != player.targetLocation {
                player.currentLocation += 1
                if player.currentLocation == locationsCount {
                    player.currentLocation = 0
                }
                players[currentPlayerIndex] = player
            } else {
                anyCancellable = nil
                completion("Move", currentPlayerIndex)
            }
        })
        
        
        
    }
    func checkGamePlayerChange(roomID: String ,completion:  @escaping (String,Int,Int)-> Void ) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomID).collection("game").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {  return }
            snapshot.documentChanges.forEach { documentChange in
                switch documentChange.type {
                case .added:
                    guard let gamePlayer = try? documentChange.document.data(as: GamePlayer.self) else { break }
                    self.gamePlayers.append(gamePlayer)
                    self.roomDateOrder()
                    print("added")
                   
                case .modified:
                    print("modified")
                    guard let gameplayer = try? documentChange.document.data(as: GamePlayer.self) else { break }
                    guard let index = self.gamePlayers.firstIndex(where: {
                        $0.id == gameplayer.id
                    }) else { return }
                    var move = gameplayer.rolePosition - self.gamePlayers[index].rolePosition
                    if move < 0{
                        
                        move = move + 16
                    }
                    if move > 0{
                    
                       
                        completion("Move", index, move)
                        
                        
                    }
                    self.gamePlayers[index] = gameplayer
                    
                case .removed:
                    print("removed")
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    guard let index = self.gamePlayers.firstIndex(where: {
                        $0.id == player.id
                    }) else { return }
                    self.gamePlayers.remove(at: index)
                    self.gamePlayers.remove(at: index)
                    
                   
                }
            }
        }
    }
    func checkGameMapChange(roomID: String ,completion:  @escaping (Result<String,Error>)-> Void ) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomID).collection("map").addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else { completion(.failure("error" as! Error)) ; return }
            snapshot.documentChanges.forEach { documentChange in
                switch documentChange.type {
                case .added:
                    print("added")
                    guard let map = try? documentChange.document.data(as: GameMapInformation.self) else { break }
                    self.map.append(map)
                    self.mapOrder()
                    completion(.success("added"))
                case .modified:
                    print("modified")
                    guard let map = try? documentChange.document.data(as: GameMapInformation.self) else { break }
                    guard let index = self.map1.firstIndex(where: {
                        $0.index == map.mapIndex
                    }) else { return }
                    self.map1[index].itemlevel = map.houseLevel
                    self.map1[index].playerColorIndex = map.whoBuyIndex
                    self.map[index] = map
                    completion(.success("modified"))
                case .removed:
                    print("removed")
                    completion(.success("removed"))
                }
            }
        }
    }
    func checkPlayerSelfChange(roomID: String ,email: String ,completion:  @escaping (Result<GamePlayer,Error>)-> Void ) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomID).collection("game").document(email).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("偵測失敗")
                return
            }
            guard let gamePlayer = try? snapshot.data(as: GamePlayer.self) else {
                print("偵測失敗")
                return
            }
            completion(.success(gamePlayer))
           
        }
    }
    func fetchselfGameInformation(roomID: String, email: String, completion:  @escaping (Result<GamePlayer,Error>)-> Void )   {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomID).collection("game").document(email).getDocument { snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,let gameplayerself = try?snapshot.data(as: GamePlayer.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                    completion(.failure(error))
                }
                return
            }
            completion(.success(gameplayerself))
        }
    }
    
    func playerGoahead(roomID: String, email: String, goahead:Int, completion:  @escaping (Result<Int,Error>)-> Void ){
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("game").document(email)
        docureference.getDocument{snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var playerself = try?snapshot.data(as: GamePlayer.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            playerself.rolePosition = playerself.rolePosition + goahead
            playerself.isChangeToYou = self.gamePlayerSelf.isChangeToYou
            if  playerself.rolePosition > 15{
                playerself.rolePosition =  playerself.rolePosition - 16
            }
            completion( .success(playerself.rolePosition))
            do{
                try docureference.setData(from: playerself)
            }catch{
                print(error)
            }

    //        print(roomDataes)
        }
    }
    func changToNextPlayer(roomID: String, email: String){
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("game").document(email)
        docureference.getDocument{snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var playerself = try?snapshot.data(as: GamePlayer.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            playerself.isChangeToYou.toggle()
            do{
                try docureference.setData(from: playerself)
            }catch{
                print(error)
            }

    //        print(roomDataes)
        }
    }
    func PayToPlayer(roomID: String, email: String){
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("game").document(email)
        docureference.getDocument{snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var playerself = try?snapshot.data(as: GamePlayer.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            playerself.money = self.gamePlayerSelf.money
            do{
                try docureference.setData(from: playerself)
            }catch{
                print(error)
            }

    //        print(roomDataes)
        }
    }
    func reciveMoney(roomID: String, email: String ,index:Int){
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("game").document(email)
        docureference.getDocument{snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var playerself = try?snapshot.data(as: GamePlayer.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            playerself.money = self.gamePlayers[index].money
            do{
                try docureference.setData(from: playerself)
            }catch{
                print(error)
            }

    //        print(roomDataes)
        }
    }
    func changeMap(roomID: String ,rolePosition: Int){
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("map").document(String(rolePosition))
        docureference.getDocument { snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var gameMap = try?snapshot.data(as: GameMapInformation.self) else {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            
            gameMap = self.map[rolePosition]
            
            do{
                try docureference.setData(from: gameMap)
            }catch{
                print(error)
            }
        }

    }
    
    func deletegameplayer(roomID:String, email:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("rooms").document(roomID).collection("game").document(email)
        documentReference.delete()
    }
    
}

struct GamePlayer: Codable {
    @DocumentID var id : String?
    var rolePosition : Int
    var goAhead: Int
    var isChangeToYou : Bool
    var money : Int
    var house : String
    var playerIndex : Int
}

struct GameMapInformation: Codable {
    @DocumentID var id : String?
    var mapIndex : Int
    var showBuy :Bool
    var whoBuyIndex : Int
    var whoBuyName : String
    var houseLevel : Int
}

func createGamePlayer(roomNumber: String, email: String , gamePlayer: GamePlayer){
    let db = Firestore.firestore()
    do {
        //        let documentReference = try db.collection("players").addDocument(from: player) // 不指定文件id
        //        print(documentReference.documentID)
        try db.collection("rooms").document(roomNumber).collection("game").document(email).setData(from: gamePlayer)
    } catch {
        print(error)
    }
}
func createGameMap(roomNumber: String ,mapItemNumbrt:Int ,gameMapInmformation: [GameMapInformation]){
    let db = Firestore.firestore()
    do{
        for i in 0..<mapItemNumbrt {
            try db.collection("rooms").document(roomNumber).collection("map").document(String(i)).setData(from: gameMapInmformation[i])
        }
    }catch{
        
        
        print(error)
    }
}

func checkPositionState(index: Int){
    
}
