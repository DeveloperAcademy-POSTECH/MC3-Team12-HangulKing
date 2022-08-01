//
//  ConsonantEndViewController.swift
//  HangulTop
//
//  Created by kimjimin on 2022/07/21.
//

import UIKit
import Lottie

struct Info {
    var indexCount: Int
}

class ConsonantEndViewController: UIViewController {
    var data: Int? = 0
    let messageArray = ["You have learned\nthe vowels of Hangul!", "You have learned\nthe consonants of Hangul!", "You have learned\nthe batchim of Hangul!"]
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet var animationView: AnimationView!
    @IBOutlet weak var goToStudy: UIButton!
    @IBAction func goToMenu(_ sender: Any) {
        //네비게이션 스택 중 원하는 지점으로 보내줌
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is StudyMenuViewController {
                _ = self.navigationController?.popToViewController(vc as! StudyMenuViewController, animated: true)
            }
        }
    }
    
    @IBAction func goToStudy(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if(appDelegate?.infos.indexCount ?? 0 > 1) {
            appDelegate?.infos.indexCount = 2
        }
        appDelegate?.infos.indexCount = (appDelegate?.infos.indexCount ?? 0) + 1
        let controllers = self.navigationController?.viewControllers
        if appDelegate?.infos.indexCount == 3 {
            let vc:UIViewController = UIStoryboard(name: "Quiz", bundle:nil).instantiateViewController(withIdentifier: "QuizViewController") as UIViewController
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            for vc in controllers! {
                if vc is SyllableStartViewController {
                    _ = self.navigationController?.popToViewController(vc as! SyllableStartViewController, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = messageArray[data ?? 0]
        if(data == 0){
            goToStudy.setTitle("Learn Consonant", for: .normal)
        }else if(data == 1){
            goToStudy.setTitle("Learn Batchim", for: .normal)
        }else{
            goToStudy.setTitle("Go to Quiz", for: .normal)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
    }
}
