//
//  Date+.swift
//  SeSACRxThreads
//
//  Created by Taekwon Lee on 2023/11/02.
//

import Foundation

extension Date {
    func fetchAge(birthDate: Date) -> Int {
        let calendar = NSCalendar(identifier: .gregorian)
        
        if let age = calendar?.components(.year, from: birthDate, to: .now).year {
            return age
        }
        
        return -1
    }
}
