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
    let messageArray = ["vowelDone".localized, "consonantDone".localized, "batchimDone".localized]
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet var animationView: AnimationView!
    @IBOutlet weak var goToStudy: UIButton!
    @IBOutlet weak var goToMain: UIButton!
    
    @IBAction func goToMain(_ sender: Any) {
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
        addBottomBorder()
        message.text = messageArray[data ?? 0]
        if(data == 0){
            goToStudy.setTitle("learnConsonant".localized, for: .normal)
        }else if(data == 1){
            goToStudy.setTitle("learnBatchim".localized, for: .normal)
        }else{
            goToStudy.setTitle("goToQuiz".localized, for: .normal)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
    }
    
    func addBottomBorder() {
        let thickness: CGFloat = 1.0
        let bottomBorder = CALayer()
        
        bottomBorder.frame = CGRect(x:0, y: self.goToMain.frame.size.height - thickness, width: self.goToMain.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        goToMain.layer.addSublayer(bottomBorder)
    }
}
