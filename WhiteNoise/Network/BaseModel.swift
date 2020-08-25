//
//  BaseModel.swift
//  RealTimeBid
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import HandyJSON

class BaseModel: HandyJSON {
    
    var code: Int?
    var msg: String?
    
    required init() {}
}

/// data : T?
class BaseDataModel<T: HandyJSON>: BaseModel {
    
    var data: T?
    
}

/// data : [T]?
class DataArrModel<T: HandyJSON>: BaseModel {
    
    var data: [T]?
    
}

class BaseListModel<T: HandyJSON>: HandyJSON {
    
    var totalCount : Int?
    var pageSize : Int?
    var totalPage : Int?
    var currPage : Int?
    var list : [T]?
    
    required init() { }
}


class DataModel: HandyJSON {
    
    var token : String?
    
    required init() { }
}


