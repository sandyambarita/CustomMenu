//
//  ViewController.swift
//  MenuRealm
//
//  Created by Sandy Ambarita on 22/06/21.
//

import UIKit
import RealmSwift

struct MenuRD {
    let name: String?
    let image: String?
}

protocol UpdateMenuActiveDelegate: AnyObject {
    func updateMenuActive(cell: UICollectionViewCell)
}

protocol updateMenuInactiveDelegate: AnyObject {
    func updateMenuInActive(cell: UICollectionViewCell)
}


class ViewController: UIViewController {
    @IBOutlet weak var collectionViewMainMenu: UICollectionView!
    @IBOutlet weak var collectionViewMainMenuInActive: UICollectionView!
    @IBOutlet weak var btnEdit: UIButton!
    
    var menuRealm: Results<MenuRealm>!
    var activeMenuRealm: Results<MenuRealm>!
    var inActiveMenuRealm: Results<MenuRealm>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMainMenu?.register(UINib(nibName:"MenusCell", bundle: nil), forCellWithReuseIdentifier: "menusCell")
        collectionViewMainMenuInActive?.register(UINib(nibName:"MenusCell", bundle: nil), forCellWithReuseIdentifier: "menusCell")

        let realm = RealmService.shared.realm
        menuRealm = realm.objects(MenuRealm.self)
        
        if menuRealm.count == 0 {
            guard let url = Bundle.main.url(forResource: "Menu", withExtension: "json") else { return  }
            let data = try! Data(contentsOf: url)
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            print(json)
            
            try! realm.write{
                for menu in json {
                    realm.create(MenuRealm.self, value: menu)
                }
            }
            
        }
        updateMenu()
    }
    
    func updateMenu() {
        let realm = RealmService.shared.realm
        activeMenuRealm = realm.objects(MenuRealm.self).filter("isHiddenMenu = false").sorted(byKeyPath: "name")
        inActiveMenuRealm = realm.objects(MenuRealm.self).filter("isHiddenMenu = true").sorted(byKeyPath: "name")
        refreshMenus()
    }
    
    func refreshMenus() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                let indexSet = IndexSet(integer: 0)
                self.collectionViewMainMenu.reloadSections(indexSet)
                self.collectionViewMainMenuInActive.reloadSections(indexSet)
            }
        }
    }
    
    
    @IBAction func btnEditOnClicked(_ sender: Any) {
        if btnEdit.currentTitle == "Edit" {
            btnEdit.setTitle("Simpan", for: .normal)
        } else {
            btnEdit.setTitle("Edit", for: .normal)
        }
        refreshMenus()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMainMenu {
            return activeMenuRealm.count
        } else if collectionView == collectionViewMainMenuInActive {
            return inActiveMenuRealm.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMainMenu {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menusCell", for: indexPath) as? MenusCell
            cell?.configureCellMenuRD(menu: activeMenuRealm[indexPath.row])
            cell?.updateMenuActiveDelegate = self
            cell?.btnEdit.setImage(UIImage(named: "illu_delete"), for: .normal)
            if btnEdit.currentTitle == "Edit" {
                cell?.btnEdit.isHidden = true
            } else {
                cell?.btnEdit.isHidden = false
            }
            return cell!
        } else if collectionView == collectionViewMainMenuInActive {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menusCell", for: indexPath) as? MenusCell
            cell?.configureCellMenuRD(menu: inActiveMenuRealm[indexPath.row])
            cell?.updateMenuInactiveDelegate = self
            cell?.btnEdit.setImage(UIImage(named: "baseline-add_box"), for: .normal)
            if btnEdit.currentTitle == "Edit" {
                cell?.btnEdit.isHidden = true
            } else {
                cell?.btnEdit.isHidden = false
            }
            return cell!
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UpdateMenuActiveDelegate {
    func updateMenuActive(cell: UICollectionViewCell) {
        let indexPath = collectionViewMainMenu.indexPathForItem(at: cell.center)
        RealmService.shared.update(activeMenuRealm[indexPath!.row], with: ["isHiddenMenu" : !activeMenuRealm[indexPath!.row].isHiddenMenu])
        updateMenu()
        
    }
}

extension ViewController: updateMenuInactiveDelegate {
    func updateMenuInActive(cell: UICollectionViewCell) {
        let indexPath = collectionViewMainMenuInActive.indexPathForItem(at: cell.center)
         RealmService.shared.update(inActiveMenuRealm[indexPath!.row], with: ["isHiddenMenu" : !inActiveMenuRealm[indexPath!.row].isHiddenMenu])
        updateMenu()
        
    }
}

