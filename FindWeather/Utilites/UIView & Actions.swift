//
//  UIActions.swift
//  SaiNiketh
//
//  Created by Kathiravan on 12/01/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView


private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10
public enum closureActions : Int{
    case none = 0
    case tap = 1
    case swipe_left = 2
    case swipe_right = 3
    case swipe_down = 4
    case swipe_up = 5
}
public struct closure {
    typealias emptyCallback = ()->()
    static var actionDict = [Int:[closureActions : emptyCallback]]()
    static var btnActionDict = [Int:[String: emptyCallback]]()
}


public extension UIView{
    private static var loaderView: UIView?
    
    func startLoader() {
        if UIView.loaderView != nil {
            return
        }
        let loaderView = UIView(frame: self.bounds)
        loaderView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(loaderView)
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: .ballClipRotateMultiple, color: .cyan)
        loader.center = loaderView.center
        loaderView.addSubview(loader)
        loader.startAnimating()
        UIView.loaderView = loaderView
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            UIView.loaderView?.removeFromSuperview()
            UIView.loaderView = nil
        }
    }
    
    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func actionHandleBlocks(_ type : closureActions = .none,action:(() -> Void)? = nil) {
        
        if type == .none{
            return
        }
        // print("∑type : ",type)
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }
    
    @objc public func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
    @objc public func triggerSwipeLeftActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_left)
    }
    @objc public func triggerSwipeRightActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_right)
    }
    @objc public func triggerSwipeUpActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_up)
    }
    @objc public func triggerSwipeDownActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_down)
    }
    public func addTap(Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    public func addAction(for type: closureActions ,Action action:@escaping() -> Void){
        
        self.isUserInteractionEnabled = true
        self.actionHandleBlocks(type,action:action)
        switch type{
        case .none:
            return
        case .tap:
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_left:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.left
            gesture.addTarget(self, action: #selector(triggerSwipeLeftActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_right:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.right
            gesture.addTarget(self, action: #selector(triggerSwipeRightActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_up:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.up
            gesture.addTarget(self, action: #selector(triggerSwipeUpActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_down:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.down
            gesture.addTarget(self, action: #selector(triggerSwipeDownActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        }
    }
    
    public func bottomview(){
        var lable : UILabel = UILabel()
        lable.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        lable.backgroundColor = .green
        lable.textAlignment = .center
        lable.text = "good try"
        self.addSubview(lable)
    }
}

extension UIButton {
    var btnClosureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &ButtonAssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &ButtonAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private func actionHandleBlock(_ control : UIControl.Event,action:(()->())? = nil) {
        
        var actionDict : [String : closure.emptyCallback]
        print("∑type : ","\(control.rawValue.description)")
        if self.btnClosureId == Int(){
            self.btnClosureId = closure.btnActionDict.count + 1
            closure.btnActionDict[self.btnClosureId] = [:]
        }
        if action != nil {
            actionDict = closure.btnActionDict[self.btnClosureId]!
            actionDict["\(control)"] = action
            closure.btnActionDict[self.btnClosureId] = actionDict
        } else {
            let valueForId = closure.btnActionDict[self.btnClosureId]
            if let exe = valueForId!["\(control)"]{
                exe()
            }
        }
    }
    
    @objc private func triggerActionHandleBlock(_ control: UIControl.Event) {
        self.actionHandleBlock(control)
    }
}

