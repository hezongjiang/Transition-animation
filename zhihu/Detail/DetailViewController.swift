//
//  DetailViewController.swift
//  zhihu
//
//  Created by he on 2017/7/21.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {

    var model: Model?
    
    @IBOutlet weak var webView: UIWebView!
    
    lazy var headImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
//        headImageView.contentMode = .scaleAspectFit
        headImageView.clipsToBounds = true
        webView.scrollView.addSubview(headImageView)
        
        
        
        DetailModel.loadDetailData(id: (model?.id ?? 0)) { data in
            
            guard let data = data else { return }
            
            self.headImageView.kf.setImage(with: URL(string: data.image))
            
            let html = "<head><link rel=\"stylesheet\" type=\"text/css\" href=\"" + data.css[0] + "\"></head>" + "<body>" + data.body + "</body>"
            
            self.webView.loadHTMLString(html, baseURL: nil)
            
        }
    }
}

extension DetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return NaviTransition(type: (operation == .push) ? NaviOneTransitionType.push : NaviOneTransitionType.pop)
    }
    
    
}
