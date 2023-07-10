////
////  ProductPage.swift
////  DealsApp
////
////  Created by Eric Young on 7/3/23.
////
///

/*
 
 Turned off dark/light mode for simplicity sake.
 */

import SwiftUI

struct ProductPage: View {
    let deal: Deal
    let service = DealsService()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var cart: Cart
    
    @State private var foundDeals: [Deal] = []
    @State private var isAddedToCart = false
    @State private var isConfirmationVisible = false
    
    @Binding var path : NavigationPath
    
    
    init(deal: Deal, cart: Cart, path : Binding<NavigationPath>) {
        self.deal = deal
        self.cart = cart
        self._path = path
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        loadImage(from: deal.product.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.top)
                        
                        description(deal: deal, foundDeals : foundDeals, path : $path, cart: cart)
                        
                    }
                    .onAppear {
                        foundDeals = findDealsForUserLikes()
                    }
                }
                addToCartSection(deal: deal)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarItems(leading: BackButton(action: {
                presentationMode.wrappedValue.dismiss()
                path.removeLast(path.count)
            }), trailing: cartButton)
        }
        .navigationBarBackButtonHidden(true)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .foregroundColor(.black)
    }
    
    private func loadImage(from urlString: String) -> Image {
        guard let url = URL(string: urlString),
              let imageData = try? Data(contentsOf: url),
              let uiImage = UIImage(data: imageData)
        else {
            return Image(systemName: "photo")
        }
        
        return Image(uiImage: uiImage)
    }
    
    private var cartButton: some View {
        NavigationLink(destination: CartView().environmentObject(cart)) {
            Image(systemName: "cart")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.black)
                .padding(.all, 12)
                .background(.ultraThinMaterial)
                .cornerRadius(8.0)
        }
    }

    
    private func findDealsForUserLikes() -> [Deal] {
        var deals: Set<Deal> = Set()
        
        for like in deal.likes {
            if let userLikes = like.user.likes {
                for userLike in userLikes {
                    let dealID = userLike.likedDeal.dealID
                    if let foundDeal = service.searchDealByID(dealID) {
                        deals.insert(foundDeal)
                    }
                }
            }
        }
        
        return Array(deals)
    }
    
    private func addToCartAction(deal: Deal) {
        cart.addItem(deal: deal)
        isAddedToCart = true
        isConfirmationVisible = true
        print("Item added to cart: \(deal.title)")
        cart.printCart()
    }

    private func addToCartSection(deal: Deal) -> some View {
        VStack {
            Spacer()
            
            HStack {
                Text("$\(deal.price)")
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    addToCartAction(deal: deal)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: isAddedToCart ? "checkmark" : "cart")
                        Text(isAddedToCart ? "Added to Cart" : "Add to Cart")
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
                }
            }
            .padding()
            .padding(.horizontal)
            .background(Color(red: 193/255, green: 216/255, blue: 255/255))
            .cornerRadius(60.0, corners: .topLeft)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }




}

struct description : View {
    let deal : Deal
    let foundDeals : [Deal]
    @Binding var path : NavigationPath
    @ObservedObject var cart: Cart
    
    var body : some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack (alignment: .leading){
                    Text(deal.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text(String(deal.likes.count))
                            .font(.system(size: 18).bold())
                        Spacer()
                        
                        Image(systemName : "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text(String(deal.dislikes.count))
                            .font(.system(size: 18).bold())
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.vertical, 8)
                        
                        BulletPointListView(description: deal.product.description)
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Reviews")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.vertical, 8)
                        
                        if deal.comments.isEmpty {
                            Text("There are No Reviews at this time")
                                .font(.body)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(deal.comments) { comment in
                                CommentView(comment: comment)
                            }
                            .padding(.bottom)
                        }
                        
                        Divider()
                        
                        foundDealsScrollView(cart: cart)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
            }
            .frame(height: .infinity)
            .padding()
            .padding(.top)
            .background(Color(red: 255/255, green: 232/255, blue: 193/255))
            .cornerRadius(40.0)
        }
    }
    
    private func foundDealsScrollView(cart : Cart) -> some View {
        VStack(alignment: .leading) {
            Text("Users who have liked this Deal also like")
                .font(.title2)
                .padding(.bottom, 8)
            
            Divider()
            
            if foundDeals.isEmpty {
                Text("There are no liked items at this time")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(foundDeals, id: \.id) { foundDeal in
                            NavigationLink(destination: {
                                ProductPage(deal: foundDeal, cart: cart, path: $path)
                            }) {
                                ProductCard(deal: foundDeal)
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.bottom, 70)
    }
    
}

struct BulletPointListView: View {
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(splitDescriptionIntoSentences(), id: \.self) { sentence in
                BulletPointItemView(sentence: sentence)
            }
        }
    }

    private func splitDescriptionIntoSentences() -> [String] {
        return description.components(separatedBy: ".")
                           .map { $0.trimmingCharacters(in: .whitespaces) }
                           .filter { !$0.isEmpty }
    }
}

struct BulletPointItemView: View {
    let sentence: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 6, height: 6)

            Text(sentence)
                .font(.body)
                .opacity(0.7)
        }
    }
}

struct CommentBulletPointListView: View {
    let comments: [Comment]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(comments) { comment in
                BulletPointItemView(sentence: comment.text)
            }
        }
    }
}


struct BackButton : View {
    let action: () -> Void
    var body : some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .padding(.all, 12)
                .background(.ultraThinMaterial)
                .cornerRadius(8.0)
        }
    }
}

struct CommentView: View {
    let comment: Comment

    var body: some View {
        VStack(alignment: .leading) {

            Text(comment.text)
                .font(.body)
                .opacity(0.7)

            Text(comment.user.name)
                .font(.body)
        }
        .padding(.vertical, 8)
    }
}

struct RoundedCorner : Shape {

    var radius : CGFloat = .infinity
    var corners : UIRectCorner = .allCorners

    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width : radius, height : radius))

        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners : UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners : corners))
    }
}

