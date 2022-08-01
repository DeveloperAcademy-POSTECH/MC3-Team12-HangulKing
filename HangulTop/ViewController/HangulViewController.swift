//
//  HangulViewController.swift
//  HangulTop
//
//  Created by 이주화 on 2022/07/28.
//

import UIKit
import AVFoundation

class HangulViewController: UIViewController{
    
    @IBOutlet weak var megaphoneLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var mainLetter: UILabel!
    @IBOutlet weak var captionView: UIStackView!
    var check: Int = 0
    var setLet = [[14, 20, 21, 22, 23, 24, 25, 26, 27],[14, 22, 23, 24, 25, 26, 27],[1]]
    var hangul: String = "앙"
    let letters = ["\u{1100}","\u{110f}","\u{1101}"]
    let syllableArray = [["\u{1100}","\u{1102}","\u{1103}","\u{1105}","\u{1106}","\u{1107}", "\u{1109}","\u{110b}", "\u{110c}", "\u{110e}","\u{110f}","\u{1110}", "\u{1111}","\u{1112}","\u{1101}","\u{1104}","\u{1108}", "\u{110a}","\u{110d}"], ["ㅏ", "ㅑ", "ㅓ", "ㅕ", "ㅗ", "ㅛ", "ㅜ", "ㅠ", "ㅡ", "ㅣ", "ㅐ", "ㅒ", "ㅔ", "ㅖ", "ㅘ", "ㅙ", "ㅚ", "ㅝ", "ㅞ", "ㅟ", "ㅢ"], ["\u{11a7}", "\u{11a8}", "\u{11ab}", "\u{11ae}", "\u{11af}", "\u{11b7}", "\u{11b8}", "\u{11ba}", "\u{11bc}", "\u{11bd}", "\u{11be}", "\u{11bf}", "\u{11c0}", "\u{11c1}", "\u{11c2}", "\u{11a9}", "\u{11bb}", "\u{11aa}", "\u{11ac}", "\u{11ad}", "\u{11b0}", "\u{11b1}", "\u{11b2}", "\u{11b3}", "\u{11b4}", "\u{11b5}", "\u{11b6}",  "\u{11b9}"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLetter.text = hangul
        setButton()
        importButton()
        setLabel()
        setCaption()
        // Do any additional setup after loading the view.
    }
    
    //    func setButton() {
    //        for i in 0..<syllableArray[0].count {
    //            buttons[i].setTitle(syllableArray[0][i], for: .normal)
    //        }
    //    }
    //    func setBatchim() {
    //        for i in 0..<syllableArray[2].count {
    //            batchims[i].setTitle(syllableArray[0][i], for: .normal)
    //        }
    //    }
    func setLabel() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "megaphone.fill")

        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        megaphoneLabel.attributedText = fullString
    }
    
    func setCaption() {
        captionView.layer.borderColor =  UIColor.black.cgColor
        captionView.layer.borderWidth = 0.5
        captionView.layer.cornerRadius = 10
    }
    
    @IBAction func viewSelect(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            check = 0
            setButton()
            importButton()
        }else if(sender.selectedSegmentIndex == 1) {
            check = 1
            setButton()
            importButton()
        }else if(sender.selectedSegmentIndex == 2) {
            check = 2
            setButton()
            importButton()
        }
    }
    
    @IBAction func selectButton(_ sender: UIButton){
        let mainUni = UnicodeScalar(hangul)?.value
        let buttonUni = UnicodeScalar(sender.titleLabel!.text ?? "\u{1100}")?.value ?? 0x1100
        if(buttonUni < 0x1113){ //자음일때
            let uni = buttonUni - 0x1100
            let vowelUni = ((mainUni ?? 0xac01) - 0xac00) / 28 % 21
            let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
            let letter = ((uni * 21) + vowelUni) * 28 + batUni + 0xAC00
            hangul = String(UnicodeScalar(letter)!)
        }
        else if(buttonUni < 0x11c3){ //받침일때
            let uni = buttonUni - 0x11a7
            let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
            let vowelUni = ((mainUni ?? 0xac01) - 0xac00) / 28 % 21
            let letter = ((conUni * 21) + vowelUni) * 28 + uni + 0xAC00
            hangul = String(UnicodeScalar(letter)!)
        }
        else{ //모음일때
            let uni = buttonUni - 0x314f
            print("\(uni)")
            let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
            print("\(conUni)")
            let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
            print("\(batUni)")
            let letter = ((conUni * 21) + uni) * 28 + batUni + 0xAC00
            print("\(letter)")
            hangul = String(UnicodeScalar(letter)!)
            print("\(hangul)")
        }
        mainLetter?.text = hangul
        print("\(hangul)")
        pronounce(hangul)
    }
    
    func pronounce(_ letter: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: letter)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        
        let audioSession = AVAudioSession.sharedInstance() //녹음 및 재생이 점유하고 있는 오디오 다시 가져오기
        try! audioSession.setCategory(
            AVAudioSession.Category.playback,
            options: AVAudioSession.CategoryOptions.mixWithOthers
        )
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func setButton() {
        for i in 0..<buttons.count {
            buttons[i].isHidden = false
        }
        if(check != 2){
            for j in 0..<setLet[check].count{
                buttons[setLet[check][j]].isHidden = true
            }
        }
        
    }
    
    func importButton(){
        var j = 0
        for i in 0..<buttons.count {
            if(buttons[i].isHidden == false){
                if(UnicodeScalar(syllableArray[check][j])?.value == 0x11a7){
                    buttons[i].setTitle(syllableArray[check][j], for: .normal)
                    buttons[i].layer.borderWidth = 1
                    buttons[i].layer.borderColor = UIColor.black.cgColor
                    buttons[i].setTitleColor(UIColor.white, for: .normal)
                    buttons[i].layer.cornerRadius = 15
                    buttons[i].titleLabel?.font = UIFont(name: "EBS훈민정음R", size: 30) ?? .systemFont(ofSize: 30, weight: .regular)
                    buttons[i].backgroundColor = .white
                    j += 1
                }else{
                    buttons[i].setTitle(syllableArray[check][j], for: .normal)
                    //                    buttons[i].titleLabel?.shadowColor = UIColor.black.cgColor
                    buttons[i].titleLabel?.shadowOffset = CGSize(width: 0, height: 4)
                    //                   btn.layer.shadowColor = UIColor.black.cgColor // 색깔
                    buttons[i].layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
                    buttons[i].layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
                    buttons[i].layer.shadowRadius = 1 // 반경
                    buttons[i].layer.shadowOpacity = 0.3 // alpha값 buttons[i].titleLabel?.shadowOpacity = 0.5
                    buttons[i].layer.borderWidth = 1
                    buttons[i].layer.borderColor = UIColor.black.cgColor
                    buttons[i].setTitleColor(UIColor.black, for: .normal)
                    buttons[i].layer.cornerRadius = 15
                    buttons[i].titleLabel?.font = UIFont(name: "EBSHunminjeongeumL", size: 30) ?? .systemFont(ofSize: 30, weight: .regular)
                    buttons[i].backgroundColor = .white
                    j += 1
                }
            }
        }
    }
    
    @IBAction func speakLetter(_ sender: Any) {
        pronounce(hangul)
    }
}
