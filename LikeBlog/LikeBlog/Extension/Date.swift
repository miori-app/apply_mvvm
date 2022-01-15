//
//  Date.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/15.
//

import Foundation

extension Date {
    static func parse<T : CodingKey>(_ values : KeyedDecodingContainer<T>, key : T) -> Date? {
        guard let dateString = try? values.decode(String?.self, forKey: key),
              let date = convertStringtoDate(dateString : dateString) else {
                  return nil
              }
        return date
    }
    
    static func convertStringtoDate(dateString : String) -> Date? {
        let dateFromatter = DateFormatter()
        
        dateFromatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFromatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFromatter.date(from: dateString) {
            return date
        }
        //없으면
        return nil
    }
}
