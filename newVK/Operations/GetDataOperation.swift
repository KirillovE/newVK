//
//  GetDataOperation.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire

class GetDataOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Data?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
}
