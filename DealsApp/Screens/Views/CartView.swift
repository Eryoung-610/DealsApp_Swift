//
//  CartView.swift
//  DealsApp
//
//  Created by Eric Young on 7/10/23.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: Cart
    
    var body: some View {
        List {
            Section(header: Text("Cart").font(.title).fontWeight(.bold)) {
                ForEach(cart.items) { cartItem in
                    DealItemView(cartItem: cartItem)
                }
            }
            
            Section {
                HStack {
                    Text("Total Price:")
                        .font(.headline)
                    Spacer()
                    Text("$\(cart.totalPrice)")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            
            Section {
                Button(action: {
                    // Proceed button action
                }) {
                    Text("Proceed")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
    }
}


struct DealItemView: View {
    let cartItem: CartItem
    
    var body: some View {
        HStack {
            // Product Image
            Image(systemName:  cartItem.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            // Deal Title
            Text(cartItem.deal.title)
                .font(.headline)
            
            Spacer()
            
            // Deal Price
            Text("$\(cartItem.deal.price)")
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}



struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
