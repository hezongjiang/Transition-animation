//
//  DetailModel.swift
//  zhihu
//
//  Created by he on 2017/7/21.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailModel: NSObject {

    var body = ""
    
    var image_source = ""
    
    var title = ""
    
    var image = ""
    
    var share_url = ""
    
    var ga_prefix = ""
    
    var images = [String]()
    
    var type = 0
    
    var id = 0
    
    var css = [String]()
    
    class func loadDetailData(id: Int, data: @escaping (_ model: DetailModel?) -> ()) {
        
        Alamofire.request("https://news-at.zhihu.com/api/4/story/\(id)").responseJSON { (result) in
            
            guard let result = result.result.value as? [String : Any] else { return }
            
            data(DetailModel.yy_model(with: result))
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
