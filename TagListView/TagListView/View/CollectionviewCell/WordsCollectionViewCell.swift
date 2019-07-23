//
//  WordsCollectionViewCell.swift
//  CollectionViewDynamicwidthDemo
//
//  Created by Tristate Technology on 17/07/19.
//  Copyright © 2019 Tristate Technology. All rights reserved.
//

import UIKit

protocol DelegateWordsCollectionViewCell {
    func btnCloseClicked(index: Int)
}

class WordsCollectionViewCell: UICollectionViewCell {

    // MARK: - Variable Declaration
    var delegateBtnClose : DelegateWordsCollectionViewCell?
    var position : Int = 0
    
    // MARK: - IB Outlets
    @IBOutlet weak var lblWords: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewContainer: UIView!

    // MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.layer.borderColor = UIColor.white.cgColor
        btnClose.layer.borderWidth = 2.0
        lblWords.layer.cornerRadius =  lblWords.frame.height/2
    }
    
    // MARK: - Addtional Function Declaration
    func cellConfig(arrData : Array<String> , index : Int){
        position = index
        lblWords.text = arrData[index]
    }
    
    // MARK: - IB Action
    @IBAction func btnCloseAction(_ sender: Any) {
        delegateBtnClose?.btnCloseClicked(index: position)
    }
    
    
    func getInteresticSize(strText:String,cv:UICollectionView)-> CGSize{
        let font = (Name:lblWords.font.fontName,Size:lblWords.font.pointSize)
        let textSize = lblWords.textSize(font: UIFont(name: font.Name, size: font.Size)!, text: strText)
        
        // 50 - Label Padding
        if textSize.width + 50 >= cv.frame.size.width{
            let height = lblWords.heightForView(text: strText, font: UIFont(name: font.Name, size: font.Size+1)!, width: cv.frame.size.width - 15)
            return CGSize(width: cv.frame.size.width, height: height + 35)
        }else{
            return CGSize(width: textSize.width + 40 , height: textSize.height + 35)
        }
    }
    
}
