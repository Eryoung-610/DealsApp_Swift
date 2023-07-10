//
//  DealModel.swift
//  DealsApp
//
//  Created by Eric Young on 7/3/23.
//

import Foundation

struct DealsResponse: Decodable {
    let data : Deals
}

struct Deals : Decodable {
    let deals: [Deal]
}

struct Deal: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let url: String
    let price: Int
    let description: String
    let product: Product
    let createdAt: String
    let updatedAt: String
    let likes: [Like]
    let dislikes: [Dislike]
    let comments: [Comment]

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Deal, rhs: Deal) -> Bool {
        return lhs.id == rhs.id
    }
    
//        static let mockDeal = Deal(
//            id: "1",
//            title: "My Arcade All-Star Stadium Pico Player, Universal",
//            url: "https://www.officedepot.com/a/products/9025577/My-Arcade-All-Star-Stadium-Pico/",
//            price: 999,
//            description: "What a fantastic price on a must-have product - you should totally buy this right now!",
//            product: Product(
//                availability: "IN STOCK",
//                image: "https://media.officedepot.com/images/t_extralarge%2Cf_auto/products/9025577/9025577_o01.png",
//                description: "Enjoy endless fun when you bring along the My Arcade All-Star Stadium Pico Player. This game console features an ergonomic design and a full-color 2\" screen with a built-in speaker. It includes 7 officially licensed Jaleco titles and 100 retro-style bonus games for versatile fun.  Handheld console with an ergonomic and compact design.  Offers 7 officially licensed Jaleco titles including BASES LOADED 1, 2, 3, and 4, GOAL!, RACKET ATTACK and HOOPS.  Bonus 100 retro-style games for added fun.  Full-color 2\" screen.  Built-in speaker with volume control.  Portable console is ideal for long road trips, commuting to work, travel and more.  Powered by 3 AAA batteries (not included).  Includes a user guide.",
//                sku: "123456",
//                updatedAt: "2023-07-01 12:34:56"
//            ),
//            createdAt: "1688149416821",
//            updatedAt: "1688149416821",
//            likes: [
//                Like(
//                    id: "1",
//                    user: User(
//                        name: "John Doe"
//                    )
//                ),
//                Like(
//                    id: "2",
//                    user: User(
//                        name: "Jane Smith"
//                    )
//                )
//            ],
//            dislikes: [],
//            comments: [
//                Comment(
//                    id: "1",
//                    createdAt: "1688149416928",
//                    text: "This is a mock comment.",
//                    user: User(
//                        name: "John Doe"
//                    )
//                )
//            ]
//        )
    
}

struct Product: Decodable {
    let availability: String
    let image: String
    let description: String
    let sku: String
    let updatedAt: String
}

struct User: Decodable {
    let id : String?
    let name: String
    let likes : [UserLikes]?
}

struct Like: Decodable {
    let id: String
    let user: User
}

struct UserLikes : Codable, Hashable {
    let likedDeal : LikedDeal
    
    enum CodingKeys : String, CodingKey {
        case likedDeal = "deal"
    }
}

struct LikedDeal : Codable, Hashable {
    let dealID : String
    
    enum CodingKeys : String, CodingKey {
        case dealID = "id"
    }
}

struct Dislike: Decodable {
    let user: User
}

struct Comment: Decodable, Identifiable {
    let id: String
    let createdAt: String
    let text: String
    let user: User
}

struct CartItem : Equatable, Identifiable{
    let id = UUID()
    let deal: Deal
    let quantity: Int

    var title: String {
        return deal.title
    }

    var price: Double {
        return Double(deal.price)
    }

    var image: String {
        return deal.product.image
    }
}

class Cart: ObservableObject {
    @Published var items: [CartItem] = []
    
    var totalPrice: Double {
        getTotalPrice()
    }
    
    func addItem(deal: Deal) {
        let cartItem = CartItem(deal: deal, quantity: 1)
        items.append(cartItem)
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func getTotalPrice() -> Double {
        return items.reduce(0.0) { $0 + $1.price }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    func printCart() {
        print("Cart contents:")
        for item in items {
            print("- \(item.title)")
        }
    }
}


