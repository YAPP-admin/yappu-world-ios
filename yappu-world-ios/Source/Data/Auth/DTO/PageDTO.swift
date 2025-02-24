//
//  PageDTO.swift
//  yappu-world-ios
//
//  Created by Tabber on 2/23/25.
//

import Foundation

struct PageDTO<data: Decodable>: Decodable {
    let content: data
    let pageable: PageableDTO
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: SortDTO
    let first: Int
    let numberOfElements: Int
    let empty: Bool
}

struct PageableDTO: Decodable {
    let sort: SortDTO
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
    
}

struct SortDTO: Decodable {
    let sorted: Bool
    let unsorted: Bool
    let empty: Bool
}
