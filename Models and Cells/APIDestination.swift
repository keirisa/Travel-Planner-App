//
//  APIDestination.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import Foundation

struct APIDestination: Codable {
    let id: String
    let name: String
    let description: String?
    let category: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case imageURL = "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let stringId = try? container.decode(String.self, forKey: .id) {
            id = stringId
        } else if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(
                codingPath: [CodingKeys.id],
                debugDescription: "Expected id to be String or Int"
            ))
        }

        name = try container.decode(String.self, forKey: .name)
        description = try? container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        imageURL = try? container.decode(String.self, forKey: .imageURL)
    }
}
