//
//  data.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 8/7/24.
//

import Foundation

struct Title {
    var name : String
    var ima : String
}

struct TitleName {
    var tỉtleSection : String
    var tilteIma : String
    var titleNameSection : [Title]
}

struct DataFood {
    var data : [MenuFood]
}

struct MenuFood : Codable {
    var avatar : String
    var name : String
    var id : String
    var intro : String?
    var price : String?
    var call : String?
    var callOne : String?
    var callTwo : String?
    var callThree: String
    var callFour : String?
    var postID: String?
    var isHearted: Bool? = false
  
}



struct Post: Codable {
    let avatar: String
    let name: String
    let id: String
    var intro : String?
    var price : String?
    var call : String?
    var callOne : String?
    var callTwo : String?
    var callThree : String?
    var callFour : String?
    var quantity: String?
    var isHearted: Bool? = false // Thuộc tính mới để lưu trạng thái heart
}


import Foundation

func createPost(from menuFood: MenuFood, completion: @escaping (Result<Post, Error>) -> Void) {
    guard let url = URL(string: "https://6684122e56e7503d1adf3ba7.mockapi.io/postApi") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let post = Post(
        avatar: menuFood.avatar,
        name: menuFood.name,
        id: menuFood.id,
        intro: menuFood.intro,
        price: menuFood.price,
        call: menuFood.call,
        callOne: menuFood.callOne,
        callTwo: menuFood.callTwo,
        callThree: menuFood.callThree,
        callFour: menuFood.callFour,
        isHearted: false
    )

    do {
        let jsonData = try JSONEncoder().encode(post)
        request.httpBody = jsonData
    } catch {
        print("Failed to encode post: \(error)")
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            print("No data received")
            return
        }

        do {
            let decodedPost = try JSONDecoder().decode(Post.self, from: data)
            completion(.success(decodedPost))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


func deletePost(postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let url = URL(string: "https://6684122e56e7503d1adf3ba7.mockapi.io/postApi/\(postID)") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        completion(.success(()))
    }.resume()
}

//    func scrollViewDidScrollTwo(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 0 {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.customView.alpha = 0
//            }) { _ in
//                self.customView.isHidden = true
//            }
//        } else {
//            if self.customView.isHidden {
//                self.customView.isHidden = false
//                UIView.animate(withDuration: 1) {
//                    self.customView.alpha = 1
//                }
//            }
//        }
//    }

