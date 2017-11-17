//
//  Item.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 17.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation
import ReactiveSwift
import DataSource

public extension Form {
    
    public enum ItemType: Decodable, Equatable {
        
        // Decoration
        case title
        case bodyText
        case image
        case button
        case activityIndicator
        case spacer

        // Custom
        case custom(String)

        
        public var rawValue: String {
            switch self {
            case let .custom(identifier):
                return identifier
            default:
                return String(describing: self)
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case "title": self = .title
            case "bodyText": self = .bodyText
            case "image": self = .image
            case "button": self = .button
            case "activityIndicator": self = .activityIndicator
            case "spacer": self = .spacer
                
            default: return nil
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            guard let value = ItemType(rawValue: rawValue) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value not found in enum cases.")
            }
            self = value
        }
        
        public var cellIdentifier: String {
            guard let first = rawValue.first else { return "" }
            let upperFirst = String(first).localizedUppercase + rawValue.dropFirst()
            return "\(String(upperFirst))Cell"
        }
        
        // MARK: Equatable
        
        public static func ==(lhs: ItemType, rhs: ItemType) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }

    }

}
