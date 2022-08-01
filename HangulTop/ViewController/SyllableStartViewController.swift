//
//  SyllableStartViewController.swift
//  HangulTop
//
//  Created by 이주화 on 2022/07/26.
//

import UIKit
import Lottie

class SyllableStartViewController: UIViewController{
    let captionArray = ["Vowels were modeled after:\n•(sky), ㅡ(earth),ㅣ(human), also called “cheonjiin”, representing the basis of the universe.\n\n• is not solely used these days, as it does not have a sound on its own.", "Consonants were modeled after the shape of the human pronunciation organ.\n\nFive basic consonants ‘ㄱ, ㄷ, ㅂ, ㅅ, ㅈ' were created, and by adding strokes to these letters, consonants with stronger sounds were created.", "Batchim is an additional consonant that comes after a consonant vowel combination.\n\nMost consonants can be batchim, but they are always pronounced as one of the 7 consonants, 'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅇ’"]
    let imageArray = ["vowel", "consonant", "batchim"]
    let extraCaptionArray = ["Vowels are not used alone. 'ㅇ' here indicates a phonetic blank in front of each vowel.", "A double consonant is a form of writing the basic consonants ‘ㄱ, ㄷ, ㅂ, ㅅ, ㅈ’ twice.", "There are double batchims that are not used as initial consonant, but they are rarely used, so don't worry!"]
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
