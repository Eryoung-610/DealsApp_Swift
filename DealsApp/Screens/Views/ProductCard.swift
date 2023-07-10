//
//  ProductCard.swift
//  DealsApp
//
//  Created by Eric Young on 7/5/23.
//

import SwiftUI

struct ProductCard: View {
    let deal: Deal
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            // Product Image
            loadImage(from: deal.product.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            // Title
            Text(deal.title)
                .font(.title2.bold())
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            // Likes
            HStack {
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("\(deal.likes.count)")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                // Price
                Text("$\(deal.price)")
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? .clear : Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: colorScheme == .dark ? 2 : 1)
        )
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
}





//struct ProductCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCard()
//    }
//}
