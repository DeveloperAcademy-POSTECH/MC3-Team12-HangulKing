//
//  SyllableStartViewController.swift
//  HangulTop
//
//  Created by 이주화 on 2022/07/26.
//

import UIKit
import Lottie

class SyllableStartViewController: UIViewController{
    let captionArray = ["vowelPrinciple".localized, "consonantPrinciple".localized, "batchimPrinciple".localized]
    let imageArray = ["vowel", "consonant", "batchim"]
    let extraCaptionArray = ["vowelExplanation1".localized, "doubleConsonantExplanation".localized, "batchimExplanation".localized]
    var indexCount: Int?
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var extraCaption: UILabel!
    @IBOutlet var animationViewArray: [AnimationView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        indexCount = appDelegate?.infos.indexCount
        caption.text = captionArray[indexCount ?? 0]
        extraCaption.text = extraCaptionArray[indexCount ?? 0]
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        indexCount = appDelegate?.infos.indexCount
        caption.text = captionArray[indexCount ?? 0]
        extraCaption.text = extraCaptionArray[indexCount ?? 0]
        for animationView in animationViewArray {
            animationView.isHidden = true
        }
        animationViewArray[indexCount ?? 0].isHidden = false
        animationViewArray[indexCount ?? 0].contentMode = .scaleAspectFit
        animationViewArray[indexCount ?? 0].loopMode = .loop
        animationViewArray[indexCount ?? 0].animationSpeed = 1
        animationViewArray[indexCount ?? 0].play()
    }
}
