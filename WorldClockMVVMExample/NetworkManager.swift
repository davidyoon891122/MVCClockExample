//
//  NetworkManager.swift
//  WorldClockMVVMExample
//
//  Created by iMac on 2022/03/04.
//

import Foundation
import Alamofire


struct NetworkManager {
    func requestTime(completionHandler: @escaping (TimeModel) -> Void) {
        guard let url = URL(string: "http://worldtimeapi.org/api/timezone/Asia/Seoul") else { return }
        
        AF.request(url, method: .get)
            .responseDecodable(of: TimeModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
