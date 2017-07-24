//
//  Model.swift
//  zhihu
//
//  Created by he on 2017/7/21.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Model: NSObject {

    var images: [String]?
    
    var type = 0
    
    var id = 0
    
    var ga_prefix = ""
    
    var title = ""
    
    override var description: String {
        return yy_modelDescription()
    }
    
    class func loadData(_ data: @escaping (_ dataSource: [Model]?) -> ()) {
        Alamofire.request("https://news-at.zhihu.com/api/4/stories/latest").responseJSON { (response) in
            
            guard let result = response.result.value else { return }
            
            let json = JSON(result)
            guard let stories = json["stories"].arrayObject else { return }
            
            data(NSArray.yy_modelArray(with: Model.self, json: stories) as? [Model])
        }
    }
}
