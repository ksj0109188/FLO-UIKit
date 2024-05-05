//
//  Font.swift
//  FLO
//
//  Created by 김성준 on 5/5/24.
//

import Foundation

enum FontSize {
    case title
    case subtitle
    case content
    
    func description() -> Double {
        switch self {
            case .title:
                return 30.0
            case .subtitle:
                return 24.0
            case .content:
                return 20.0
        }
    }
}
