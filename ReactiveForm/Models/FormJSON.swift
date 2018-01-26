//
//  FormJSON.swift
//  
//
//  Created by Gunter Hager on 26/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation

public struct FormJSON {
    
    public enum FieldType: String, Decodable {
        // Input
        case textField
        case picker
        case segmented
        case stepper
        case toggle
        
        // Decoration
        case title
        case bodyText
        case image
        case button
        case activityIndicator
        case spacer
    }
    
    public struct Form: Decodable {
        public let identifier: String
        public let fields: [FormJSON.Field]
        public let actions: [FormJSON.Action]
        
        public enum CodingKeys: String, CodingKey {
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
        
        public var tertiaryAction: Action? {
            return actions.filter { $0.type == .tertiary }.first
        }
        
    }
    
    public struct Field: Decodable {
        public let type: FormJSON.FieldType
        public let title: String
        public let image: String?
    }
    
    public enum ActionType: String, Decodable {
        case primary
        case secondary
        case tertiary
        case back
    }
    
    public  enum ActionExecute: String, Decodable {
        case show
        case cancel
        case success
        case tertiary
        case exit
    }
    
    public struct Action: Decodable {
        public let type: ActionType
        public let title: String?
        public let execute: ActionExecute
        public let card: String?
        public let screen: String?
    }
}
