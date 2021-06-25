//
//  LocalOnlyQsTask.swift
//  MenuRealm
//
//  Created by Sandy Ambarita on 22/06/21.
//

import Foundation
import RealmSwift

class LocalOnlyQsTask: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var owner: String?
    @objc dynamic var status: String = ""
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
