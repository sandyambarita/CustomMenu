//
//  MenusCell.swift
//  MenuRealm
//
//  Created by Sandy Ambarita on 23/06/21.
//

import UIKit

class MenusCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    
    weak var updateMenuActiveDelegate: UpdateMenuActiveDelegate?
    weak var updateMenuInactiveDelegate: updateMenuInactiveDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCellMenuRD(menu: MenuRealm) {
        lblName.text = menu.name
        img.image = UIImage(named: menu.image)
    }
    
    @IBAction func btnEditOnClicked(_ sender: Any) {
        if updateMenuActiveDelegate != nil {
            updateMenuActiveDelegate?.updateMenuActive(cell: self)
        } else if updateMenuInactiveDelegate != nil {
            updateMenuInactiveDelegate?.updateMenuInActive(cell: self)
        }
        
    }
    
}
