//
//  Function.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/6/13.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseDataOfRoom: ObservableObject {
    
    @Published var player = [roomData]()
    @Published var playerphoto = [PlayerPhoto]()
    @Published var playerself = roomData(roomNumber: "", personalemail: "", personalnickName: "", personalChoseRole: 0, isHost: true, isready: false)
    let db = Firestore.firestore()
//    func gameDetect(id: String, completion: @escaping (Game) -> Void) {
//           print("start game detect")
//           if self.gameListener != nil {
//               self.gameListener!.remove()
//           }
//
//           self.gameListener = db.collection("games").document(id).addSnapshotListener { snapshot, error in
//               guard let snapshot = snapshot else { return }
//               guard let game = try? snapshot.data(as: Game.self) else { return }
//               print("game modified")
//               completion(game)
//           }
//       }
       
    func checkRoomsChange(roomID: String , completion:  @escaping (Result<String,Error>)-> Void ) {
        
        db.collection("rooms").document(roomID).collection("playerInformation").addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else { completion(.failure("error" as! Error)) ; return }
            snapshot.documentChanges.forEach { documentChange in
                switch documentChange.type {
                case .added:
                    print("added")
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    self.player.append(player)
                    fetchPlayersPhoto(email: player.personalemail) { result in
                        switch result{
                        case .success(let playerPhoto):
                            self.playerphoto.append(playerPhoto)
                        case .failure(_):
                            break
                        }
                    }
                    completion(.success("added"))
                    print(player)
                case .modified:
                    print("modified")
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    guard let index = self.player.firstIndex(where: {
                        $0.id == player.id
                    }) else { return }
                    self.player[index] = player
                    completion(.success("modified"))
                case .removed:
                    print("removed")
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    guard let index = self.player.firstIndex(where: {
                        $0.id == player.id
                    }) else { return }
                    self.player.remove(at: index)
                    self.playerphoto.remove(at: index)
                    completion(.success("removed"))
                }
            }
        }
    }
    func changeIsReady(roomID:String, email:String) {
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("playerInformation").document(email)
        docureference.getDocument{snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var playerself = try?snapshot.data(as: roomData.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            playerself.isready = self.playerself.isready
            do{
                try docureference.setData(from: playerself)
            }catch{
                print(error)
            }

    //        print(roomDataes)
        }
    }
    func deleteplayer(roomID:String, email:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("rooms").document(roomID).collection("playerInformation").document(email)
        documentReference.delete()
    }
    
}

struct roomData: Codable,Identifiable {
    @DocumentID var id: String?
    var roomNumber: String
    var personalemail: String
    var personalnickName: String
    var personalChoseRole: Int
    var isHost: Bool
    var isready:Bool
    
}
struct roomCheck:  Codable,Identifiable{
    @DocumentID var id: String?
    var roomNumber: String
}
func createRoom(roomData:roomData ,roomNumber:String, email: String) {
    let db = Firestore.firestore()
    let playerroomData = roomData
    let roomCheck = roomCheck(roomNumber: playerroomData.roomNumber)
    do {
        //        let documentReference = try db.collection("players").addDocument(from: player) // 不指定文件id
        //        print(documentReference.documentID)
        try db.collection("rooms").document(roomNumber).collection("playerInformation").document(email).setData(from: playerroomData)
        try db.collection("roomsnumber").document("InviteNumber").setData(from: roomCheck)
    } catch {
        print(error)
    }
}

func checkRoomexist(roomID:String, completion: @escaping(Result<Bool,Error>) -> Void) {
    if roomID.isEmpty{
        completion(.success(false))
    }else{
    let db = Firestore.firestore()
        db.collection("roomsnumber").whereField("roomNumber", isEqualTo: roomID).getDocuments{querySnapshot, error in
            print(roomID)
            if let querySnapshot = querySnapshot {
                if !querySnapshot.isEmpty{
                    print("進入房間")
                    completion(.success(true))
                }else{
                    print("房間不存在")
                    completion(.success(false))
                }
            }else{
                if let error = error{
                    completion(.failure(error))
                }
            }
            
            
        }
    }
}


func fetchplayerInformation(roomID:String, email:String,completion: @escaping(Result<roomData,Error>) -> Void) {
    let db = Firestore.firestore()
    db.collection("rooms").document(roomID).collection("playerInformation").document(email).getDocument{snapshot, error in
        guard let snapshot = snapshot,snapshot.exists,let playerself = try?snapshot.data(as: roomData.self)else
        {
            if let error = error{
                print("錯誤訊息：",error)
                completion(.failure(error))
            }
            return
        }
        completion(.success(playerself))
//        print(roomDataes)
    }
}



////載入
//func fetchPlayersOnce(email:String,completion: @escaping(Result<PlayerOnce,Error>)->Void){
//    let db = Firestore.firestore()
//    db.collection("playersOnce").document(email).getDocument { document, error in
//
//        guard let document = document,document.exists,let player = try?document.data(as: PlayerOnce.self)else
//        {
//            if let error = error{
//                print("錯誤訊息：",error)
//                completion(.failure(error))
//            }
//            return
//        }
//
//        completion(.success(player))
//
//    }
//
//}

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
