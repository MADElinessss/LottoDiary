//
//  SearchResult.swift
//  LottoDiary
//
//  Created by Madeline on 3/16/24.
//

import Foundation

struct SearchResult: Decodable {
    let documents: [Document]?
    let meta: Meta?
}

struct Document: Decodable {
    let addressName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let categoryName: String
    let distance: String
    let id: String
    let phone: String
    let placeName: String
    let placeUrl: String
    let roadAddressName: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance
        case id
        case phone
        case placeName = "place_name"
        case placeUrl = "place_url"
        case roadAddressName = "road_address_name"
        case x
        case y
    }
}

struct Meta: Decodable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    let sameName: SameName
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case sameName = "same_name"
    }
}

struct SameName: Decodable {
    let keyword: String
    let region: [String]
    let selectedRegion: String
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case region
        case selectedRegion = "selected_region"
    }
}

