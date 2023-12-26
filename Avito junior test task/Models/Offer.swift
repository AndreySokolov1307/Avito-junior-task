//
//  Offer.swift
//  Avito junior test task
//
//  Created by Андрей Соколов on 25.12.2023.
//

import Foundation

struct OffersInfo: Codable, Hashable {
    var result: Offer
}

struct Offer: Codable, Hashable {
    
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    var list: [OfferList]
}

struct OfferList: Codable, Hashable {
    let id: String
    let title: String
    let description: String?
    let icon: Icon
    let price: String
    var isSelected: Bool
}

struct Icon: Codable, Hashable  {
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "52x52"
    }
}
