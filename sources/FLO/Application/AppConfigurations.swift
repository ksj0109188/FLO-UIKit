//
//  AppConfiguration.swift
//  FLO
//
//  Created by 김성준 on 4/21/24.
//

import Foundation

final class AppConfigurations {
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL is nil")
        }
        return apiBaseURL
    }()
}
