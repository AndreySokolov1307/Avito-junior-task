//
//  OfferController.swift
//  Avito junior test task
//
//  Created by Андрей Соколов on 25.12.2023.
//

import Foundation
import UIKit

class OfferController {
    
    static let shared = OfferController()
    
    func fetchOffersInfo() throws -> OffersInfo {
        let path = Bundle.main.path(forResource: "AvitoJSON", ofType: "json")!
        let url = URL(filePath: path)
        
        let data = try Data(contentsOf: url)
        let offersInfo = try JSONDecoder().decode(OffersInfo.self, from: data)
        return offersInfo
    }
    
    func fetchIconImage(with url: URL) async throws -> UIImage {
        
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        guard let httpResponce = responce as? HTTPURLResponse,
              httpResponce.statusCode == 200 else {
            throw OfferInfoError.imageDataMissing
        }
        
        guard let image = UIImage(data: data ) else {
            throw OfferInfoError.imageDataMissing
        }
        
        return image
    }
}

enum OfferInfoError: Error {
    case imageDataMissing
}
