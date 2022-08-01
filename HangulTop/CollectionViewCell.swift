//
//  CollectionViewCell.swift
//  HangulTop
//
//  Created by kimjimin on 2022/07/19.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellButton: UIButton!
    
    override var isSelected: Bool {
        didSet {
            self.cellButton.backgroundColor = self.isSelected ? UIColor(named: "study-button") : .white
        }
    }
}
