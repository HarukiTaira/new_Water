//
//  itemDetail.swift
//  Watercharger
//
//  Created by 平良悠貴 on 2020/07/25.
//  Copyright © 2020 平良悠貴. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class itemDetail: Object {
    
    static let realm = try! Realm()
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var bottle = ""
    @objc dynamic var time = ""
    @objc dynamic var month = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create() -> itemDetail {
        let ItemDetail = itemDetail()
        ItemDetail.id = lastId()
        return ItemDetail
    }
    
    static func loadAll() -> [itemDetail] {
        let items = realm.objects(itemDetail.self).sorted(byKeyPath: "time", ascending: false)
        var itemArray: [itemDetail] = []
        for item in items {
            itemArray.append(item)
        }
        return itemArray
    }
    
    static func lastId() -> Int {
        if let item = realm.objects(itemDetail.self).last {
            return item.id + 1
        } else {
            return 1
        }
    }
    
    func save(){
        try! itemDetail.realm.write{
            itemDetail.realm.add(self)
        }
    }
}
