//
//  HomeViewModel.swift
//  DealsApp
//
//  Created by renupunjabi on 7/3/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var deals: [Deal] = []
    @Published var isLowestToHighest: Bool = true

    private var originalDeals: [Deal] = []

    private let service = DealsService()

    func getDeals() {
        do {
            let deals = try service.fetchDeals()
            self.deals = deals
            sortDeals() // Add this line to sort the deals initially
        } catch {
            print("Error: \(error)")
        }
    }

    func sortDeals() {
        if isLowestToHighest {
            deals.sort { $0.price < $1.price }
        } else {
            deals.sort { $0.price > $1.price }
        }
    }

    func toggleSorting() {
        isLowestToHighest.toggle()
        sortDeals()
    }
}
