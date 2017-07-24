//
//  NaviTransition.swift
//  zhihu
//
//  Created by he on 2017/7/23.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit

enum NaviOneTransitionType {
    case push
    case pop
}

fileprivate var indexPath: IndexPath?

class NaviTransition: NSObject {

    
    fileprivate var type: NaviOneTransitionType
    
    init(type: NaviOneTransitionType) {
        self.type = type
        
        super.init()
    }
    
}


extension NaviTransition: UIViewControllerAnimatedTransitioning {
    
    /// 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    /// 所有的过渡动画事务都在这个方法里面完成
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch type {
        case .push:
            pushAnimation(transitionContext: transitionContext)
        case .pop:
            popAnimation(transitionContext: transitionContext)
        }
    }
    
    /// 实现 push 动画逻辑代码
    private func pushAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是被push的控制器、fromVC就是push控制器
            let fromVC = transitionContext.viewController(forKey: .from) as? ViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController,
            let idx = fromVC.tableView.indexPathForSelectedRow,
            let cell = fromVC.tableView.cellForRow(at: idx) as? TableViewCell,
            let cellImage = cell.iconImage,
            // snapshotViewAfterScreenUpdates可以对某个视图截图，我们采用对这个截图做动画代替直接对vc1做动画
            let snapView = cellImage.snapshotView(afterScreenUpdates: false)
            else { return }
        
        indexPath = idx
        
        // 这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let containerView = transitionContext.containerView
        
        snapView.frame = cellImage.convert(cellImage.bounds, to: containerView)
        
        cellImage.isHidden = true
        toVC.view.alpha = 0
        toVC.headImageView.isHidden = true
        
        // 将截图视图和toVC的view都加入ContainerView中
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapView)
        
        UIView.animate(withDuration: 0.5, animations: { 
            snapView.frame = toVC.headImageView.convert(toVC.headImageView.bounds, to: containerView)
            print(snapView.frame)
            toVC.view.alpha = 1
        }) { (_) in
            snapView.isHidden = true
            toVC.headImageView.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
    
    /// 实现 pop 动画逻辑代码
    private func popAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? DetailViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? ViewController,
            
            let cell = toVC.tableView.cellForRow(at: indexPath!) as? TableViewCell
        else { return }
        
        let containerView = transitionContext.containerView
        
        let snapView = containerView.subviews.last
        
        fromVC.headImageView.isHidden = true
        snapView?.isHidden = false
        
        containerView.insertSubview(toVC.view, at: 0)
        
        UIView.animate(withDuration: 0.5, animations: { 
            snapView?.frame = cell.iconImage.convert(cell.iconImage.bounds, to: containerView)
            fromVC.view.alpha = 0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                snapView?.isHidden = true
                fromVC.view.isHidden = false
            } else {
                cell.iconImage.isHidden = false
                snapView?.removeFromSuperview()
            }
        }
    }
}
