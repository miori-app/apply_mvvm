//
//  SearchBlogAPI.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/15.
//

import Foundation

struct SearchBlogAPI {
    //https://dapi.kakao.com/v2/search/blog?query=rxswift
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/search/"
    
    func searchBlog(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchBlogAPI.scheme
        components.host = SearchBlogAPI.host
        components.path = SearchBlogAPI.path + "blog"
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        return components
    }
}
