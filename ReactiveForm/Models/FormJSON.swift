//
//  FormJSON.swift
//  
//
//  Created by Gunter Hager on 26/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation

public struct FormJSON {
    
    public struct Form: Decodable {
        public let identifier: String
        public let fields: [FormJSON.Field]
        public let actions: [FormJSON.Action]
        
        public enum CodingKeys : String, CodingKey {
            case identifier = "id"
            case fields
            case actions
        }
        
        public var primaryAction: Action? {
            return actions.filter { $0.type == .primary }.first
        }
        
        public var secondaryAction: Action? {
            return actions.filter { $0.type == .secondary }.first
        }
        
    }
    
    public struct Field: Decodable {
        public let type: FormFieldType
        public let title: String
        public let image: String?
    }
    
    public enum ActionType: String, Decodable {
        case primary
        case secondary
        case back
    }
    
    public  enum ActionExecute: String, Decodable {
        case show
        case cancel
        case success
    }
    
    public struct Action: Decodable {
        public let type: ActionType
        public let title: String?
        public let execute: ActionExecute
        public let card: String?
    }
}

