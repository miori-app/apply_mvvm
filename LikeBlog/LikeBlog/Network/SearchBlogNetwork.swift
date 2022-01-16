//
//  SearchBlogNetwork.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/16.
//

import RxSwift
import Foundation

class SearchBlogNetwork {
    private let session : URLSession
    let api = SearchBlogAPI()
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - 통신을 하고 파싱까지 하는 함수 구현
    
    // Network 는 주로 성공/ 실패 -> single
    // Single의 사용 예로 보며 응답, 오류만 반환할수 있는 HTTP 요청을 수행하는데 사용됨
    func searchNetwork(query : String) -> Single<Result<DaumBlog, SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(APIKeys.kakaoAuth)", forHTTPHeaderField: "Authorization")
        //func data(request: URLRequest) -> Observable<Data>
        return session.rx.data(request: request as URLRequest)
            .map { data in
                //json decoding
                do {
                    let blogData = try JSONDecoder().decode(DaumBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            } // single로 만들건데, 여기까지 observalbe
            .asSingle()
    }
}
