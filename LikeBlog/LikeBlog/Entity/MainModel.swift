//
//  MainModel.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/20.
//

import RxSwift
import Foundation

struct MainModel {
    // 네트워크 로직 자체
    let network = SearchBlogNetwork()
    
    // flatMapLatest와 동일
    func searchBlog(_ query:String) -> Single<Result<DaumBlog,SearchNetworkError>> {
        return network.searchNetwork(query: query)
    }
    
    func getBlogValue(_ result : Result<DaumBlog, SearchNetworkError>) -> DaumBlog? {
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getBlogError(_ result : Result<DaumBlog, SearchNetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
    }
    
    func getBlogListCellData(_ value : DaumBlog?) -> [BlogListCellData] {
        guard let value = value else {
            return []
        }
        
        return value.documents
            .map {
                let thumbnailURL = URL(string: $0.thumbnail ?? "")
                return BlogListCellData(
                    thumbnailURL: thumbnailURL,
                    name: $0.blogname?.deleteMarkDown(),
                    title: $0.title?.deleteMarkDown(),
                    datetime: $0.datetime
                )
            }
    }
    
    func sort(by type : MainViewController.AlertAction, of data : [BlogListCellData]) -> [BlogListCellData] {
        switch type {
        case .title :
            return data.sorted { $0.title ?? "" < $1.title ?? ""}
        case .datetime :
            return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
        default :
            return data
        }
    }
}
