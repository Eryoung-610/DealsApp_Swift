//
//  ContentView.swift
//  DealsApp
//
//  Created by renupunjabi on 7/3/23.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject var cart = Cart()
    
    @State private var isDarkMode = false
    @State private var isFilterApplied = false
    @State private var isMenuVisible = false
    
    @State private var path = NavigationPath()
    
    
    let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    topBar(isDarkMode: $isDarkMode, isMenuVisible: $isMenuVisible, cart : cart)
                    dealsOfTheDay()
                    
                    Divider()
                    
                    filters(isDarkMode: $isDarkMode, viewModel:viewModel)
                    
                    if !viewModel.deals.isEmpty {
                        LazyVGrid(columns: gridItemLayout, spacing: 16) {
                            ForEach(viewModel.deals) { deal in
                                NavigationLink(destination: ProductPage(deal: deal, cart: cart, path: $path)) {
                                    ProductCard(deal: deal)
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.getDeals()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .navigationBarItems(trailing: menuButton)
        .navigationDestination(for: Deal.self) { deal in
            ProductPage(deal: deal,cart: cart, path: $path)
        }
        .environmentObject(cart)
    }
    
    var menuButton: some View {
            Button(action: {
                isMenuVisible.toggle()
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            .contextMenu {
                Button(action: {}) {
                    Text("Profile")
                }
                Button(action: {}) {
                    Text("Purchases")
                }
                Button(action: {}) {
                    Text("Settings")
                }
            }
        }
}
    
    
struct topBar: View {
    @Binding var isDarkMode: Bool
    @Binding var isMenuVisible: Bool
    @ObservedObject var cart: Cart
    @State private var isCartVisible = false
    
    var body: some View {
        HStack {
            Button(action: { isMenuVisible.toggle() }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: {
                isCartVisible.toggle()
            }) {
                Image(systemName: "cart")
                    .font(.title)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $isCartVisible) {
            CartView().environmentObject(cart)
        }
    }
}

    
struct dealsOfTheDay : View {
    var body : some View {
        HStack {
            Text("Deals Of The Day")
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
    }
}
    
struct filters: View {
    @Binding var isDarkMode: Bool
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("Filter")
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            
            Divider()
            
            Button(action: {
                viewModel.toggleSorting()
            }) {
                Text("By Lowest")
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .padding()
                    .background(viewModel.isLowestToHighest ? Color.blue : Color.clear)
                    .cornerRadius(10)
            }
            
            Button(action: {
                viewModel.toggleSorting()
            }) {
                Text("By Highest")
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .padding()
                    .background(!viewModel.isLowestToHighest ? Color.blue : Color.clear)
                    .cornerRadius(10)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
