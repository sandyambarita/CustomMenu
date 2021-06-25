//
//  LocalOnlyQsTask.swift
//  MenuRealm
//
//  Created by Sandy Ambarita on 22/06/21.
//

import Foundation
import RealmSwift

class MenuRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var isHiddenMenu: Bool = false
    override static func primaryKey() -> String? {
            return "name"
        }
    convenience init(name: String, image: String, isHiddeenMenu: Bool) {
        self.init()
        self.name = name
        self.image = image
        self.isHiddenMenu = isHiddenMenu
    }
}

