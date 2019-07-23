//
//  ViewController.swift
//  CollectionViewDynamicwidthDemo
//
//  Created by Tristate Technology on 17/07/19.
//  Copyright © 2019 Tristate Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Variable Declaration
    var arrWords: Array<String> = Array<String>()
    
    // MARK: -  IB Outlets
    @IBOutlet weak var tfWords: UITextField!
    @IBOutlet weak var wordsCollectionview: UICollectionView!
    @IBOutlet weak var btnAddWords: UIButton!
    @IBOutlet weak var constBottomOFCollectionView: NSLayoutConstraint!
    
    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(keyboardWillShow)
        NotificationCenter.default.removeObserver(keyboardWillHide)
    }
    
    // MARK: - Additional Function Declaration
    func setUpUI(){
        btnAddWords.layer.cornerRadius = 5
        wordsCollectionview.register(UINib(nibName: "WordsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WordsCollectionViewCell")
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        self.wordsCollectionview.collectionViewLayout = layout
    }
    
    func trimString(string : String) -> String {
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    func addWordsToCollection(){
        if self.trimString(string: tfWords.text!).count != 0 {
            arrWords.insert(tfWords.text!, at: 0)
            wordsCollectionview.reloadData()
            wordsCollectionview.layoutIfNeeded()
            tfWords.text = ""
        }
    }
    
    //keyboard Scroll
    @objc func keyboardWillShow(notification: NSNotification){
        let info = notification.userInfo
        let keyboardSize: CGSize? = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        let keyboardHeight = Float((keyboardSize?.height ?? 0.0) < (keyboardSize?.width ?? 0.0) ? (keyboardSize?.height)! : keyboardSize?.width ?? 0.0)
        print(keyboardHeight)
        self.constBottomOFCollectionView.constant =  335
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constBottomOFCollectionView.constant =  20
    }
    
    // MARK: - IB Action
    @IBAction func btnAddAction(_ sender: UIButton) {
        addWordsToCollection()
    }
}

// MARK: - Collectionview Methods
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordsCollectionViewCell", for: indexPath) as! WordsCollectionViewCell
            cell.cellConfig(arrData: arrWords, index: indexPath.row)
            cell.delegateBtnClose = self
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath : IndexPath) -> CGSize {
        
        let strText = arrWords[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordsCollectionViewCell", for: indexPath) as! WordsCollectionViewCell
        
        return cell.getInteresticSize(strText: strText, cv: collectionView)
   
    }
}

// MARK: - Textfield Delegate Methods
extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfWords.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addWordsToCollection()
    }
}

// MARK: - Delegate of Collection Cell
extension ViewController : DelegateWordsCollectionViewCell{
    func btnCloseClicked(index: Int) {
        arrWords.remove(at: index)
        wordsCollectionview.reloadData()
    }
}
