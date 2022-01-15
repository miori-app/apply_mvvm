//
//  DaumBlog.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/15.
//

import Foundation

struct DaumBlog : Decodable {
    let documents : [Documents]
    let meta : MetaDatas
}


struct Documents : Decodable {
    let blogname : String?
    //let contents  : String
    let datetime : Date?
    let thumbnail : String?
    let title : String?
    //let url : String
    
    private enum CodingKeys : String, CodingKey {
        case blogname, datetime, thumbnail, title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.blogname = try? values.decode(String?.self, forKey: .title)
        self.thumbnail = try? values.decode(String?.self, forKey: .thumbnail)
        self.title = try? values.decode(String?.self, forKey: .title)
        self.datetime = Date.parse(values, key: .datetime)
    }
}

struct MetaDatas : Decodable {
    let isEnd : Bool
    let pageableCount : Int
    let totalCount : Int
    
    // snake -> camel
    enum CodingKeys : String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
