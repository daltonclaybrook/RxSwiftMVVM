//
//  API.swift
//  RxSwiftMVVM
//
//  Created by Dalton Claybrook on 10/6/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Moya

enum API {
    case posts
    case comments(postId: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .comments(let postId):
            return "/posts/\(postId)/comments"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [ "Accept": "application/json" ]
    }
}
