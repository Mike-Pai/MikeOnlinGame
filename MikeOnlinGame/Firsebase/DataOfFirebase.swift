//
//  DataOfFirebase.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Player: Codable, Identifiable {
    @DocumentID var id: String?
    var constellation: String
    var birthday: Date
    var nickName: String
    
}

struct PlayerOnce: Codable, Identifiable {
    @DocumentID var id: String?
    let playername: String
    let joinDate: Date
    let email: String
    
}

//新增(可更動)
func createPlayer(storeData:Player) {
    let db = Firestore.firestore()
    let player = storeData
    do {
//        let documentReference = try db.collection("players").addDocument(from: player) // 不指定文件id
//        print(documentReference.documentID)
        try db.collection("players").document("玩家資訊").setData(from: player) // 指定id的寫法
    } catch {
        print(error)
    }
}
//新增(不可更動)
func createPlayerOnce(storeData:PlayerOnce) {
    let db = Firestore.firestore()
    let PlayerOnce = storeData
    do {
//        let documentReference = try db.collection("players").addDocument(from: player) // 不指定文件id
//        print(documentReference.documentID)
        try db.collection("players").document("玩家資訊").setData(from: PlayerOnce) // 指定id的寫法
    } catch {
        print(error)
    }
}

//載入
func fetchPlayersOnce()->[PlayerOnce]{
    let db = Firestore.firestore()
    var players = [PlayerOnce]()
    
    db.collection("players").getDocuments { snapshot, error in
        
        guard let snapshot = snapshot else {
                print(error)
                return
            
        }
        
         players = snapshot.documents.compactMap { snapshot in
            try? snapshot.data(as: PlayerOnce.self)
        }
        
        print(players[0],"殘念啊")
        
    }
    return players
}

func fetchPlayers()->[Player]{
    let db = Firestore.firestore()
    var players = [Player]()
    
    db.collection("players").getDocuments { snapshot, error in
        
        guard let snapshot = snapshot else { return }
        
         players = snapshot.documents.compactMap { snapshot in
            try? snapshot.data(as: Player.self)
        }
        
        print(players)
        
    }
    return players
}

// Check 狀態
func checkPlayersChange() {
    let db = Firestore.firestore()
    db.collection("players").addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else { return }
        snapshot.documentChanges.forEach { documentChange in
            switch documentChange.type {
            case .added:
                print("added")
                guard let player = try? documentChange.document.data(as: Player.self) else { break }
                print(player)
            case .modified:
                print("modified")
            case .removed:
                print("removed")
            }
        }
    }
}
//修改
func modifyPlayer(constellation:String, nickName:String, birthday:Date) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("players").document("玩家資訊")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var player = try? document.data(as: Player.self)
          else {
                    return
          }
            player.constellation = constellation
            player.nickName = nickName
            player.birthday = birthday
          do {
             try documentReference.setData(from: player)
          } catch {
             print(error)
          }
                        
        }
}
//刪除
func deleteData(collection:String, document:String){
    let db = Firestore.firestore()
    let documentReference = db.collection(collection).document(document)
    documentReference.delete()
}
