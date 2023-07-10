//
//  DealsService.swift
//  DealsApp
//
//  Created by renupunjabi on 7/3/23.
//

import Foundation

class DealsService {
    
    func fetchDeals() throws -> [Deal] {
        
        guard let url = Bundle.main.url(forResource: "getDealsWithAugments", withExtension: "json") else {
            throw APIError.invalidUrl
        }
        
        let data = try! Data(contentsOf: url)
        
        do {
            let response = try JSONDecoder().decode(DealsResponse.self, from: data)
            return response.data.deals
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }

    func searchDealByID(_ dealID: String) -> Deal? {
        do {
            let deals = try fetchDeals()
            return deals.first { $0.id == dealID }
        } catch {
            print("Error fetching deals: \(error)")
            return nil
        }
    }
}
