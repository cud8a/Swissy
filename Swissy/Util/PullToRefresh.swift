//
//  PullToRefresh.swift
//  Swissy
//
//  Created by Tamas Bara on 07.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

protocol PullToRefreshDelegate: class {
    func refresh()
}

class PullToRefresh: NSObject {

    weak var delegate: PullToRefreshDelegate?
    @objc private let _tableView: UITableView
    private let view = PullToRefreshView()
    private var oldOffset = CGFloat(0)
    
    private var canResetFromRefresh = false {
        didSet {
            guard canResetFromRefresh else {return}
            _reloadTable()
        }
    }
    
    private var canResetFromUI = false {
        didSet {
            guard canResetFromUI else {return}
            _reloadTable()
        }
    }
    
    private var state = State.ready {
        didSet {
            if state == .pulling {
                view.centerPoints()
            }
        }
    }
    
    private weak var tableTopConstraint: NSLayoutConstraint?
    
    var limit: CGFloat {
        return CGFloat(92)
    }
    
    enum State {
        case ready
        case pulling
        case refreshing
    }
    
    init(tableView: UITableView) {
        _tableView = tableView
        super.init()
        addObserver(self, forKeyPath: #keyPath(_tableView.contentOffset), options: [.old, .new], context: nil)
        view.configure(withTableView: tableView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard state != .refreshing else {return}
        
        let offset = _tableView.contentOffset.y * -1
        let height = max(0, offset)
        view.updateHeight(height)
        if state == .ready {
            view.adaptConstraints(toHeight: height)
        }
        
        if offset > oldOffset && offset > limit && state == .ready {
            delegate?.refresh()
            state = .pulling
        } else if offset < oldOffset && offset < limit && state == .pulling {
            state = .refreshing
            let constraint = tableTopConstraint ?? _tableView.superview?.constraints.first(where: {$0.firstAttribute == .top})
            constraint?.isActive = false
            tableTopConstraint = _tableView.topToBottom(of: view)
            delay(closure: { self.canResetFromUI = true }, after: .seconds(1))
        } else if offset == 0 && state == .refreshing {
            view.reset()
        }
        
        oldOffset = offset
    }
    
    func reloadTable() {
        canResetFromRefresh = true
    }
    
    private func _reloadTable() {
        guard canResetFromRefresh, canResetFromUI else {return}
        _tableView.reloadData()
        canResetFromRefresh = false
        canResetFromUI = false
        view.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.prepareReset()
            self.view.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.tableTopConstraint?.isActive = false
            self.tableTopConstraint = self._tableView.topToSuperview()
            self.view.reset()
            self.state = .ready
        })
    }
}

private class PullToRefreshView: UIView {
    
    weak var heightConstraint: NSLayoutConstraint?
    
    weak var pointLeftTopConstraint: NSLayoutConstraint?
    weak var pointLeftCenterConstraint: NSLayoutConstraint?
    
    weak var pointCenterTopConstraint: NSLayoutConstraint?
    weak var pointCenterTopConstraint2: NSLayoutConstraint?
    weak var pointCenterBottomConstraint: NSLayoutConstraint?
    
    weak var pointRightTopConstraint: NSLayoutConstraint?
    weak var pointRightTopConstraint2: NSLayoutConstraint?
    weak var pointRightBottomConstraint: NSLayoutConstraint?
    weak var pointRightCenterConstraint: NSLayoutConstraint?
    
    var pointLeft: UIView?
    var pointCenter: UIView?
    var pointRight: UIView?
    
    let size = CGFloat(12)
    let padding = CGFloat(16)
    let spacing = CGFloat(20)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.init(named: "Pull")
        clipsToBounds = true
    }
    
    func updateHeight(_ height: CGFloat) {
        heightConstraint?.constant = height
    }
    
    func adaptConstraints(toHeight height: CGFloat) {
        
        if height < 2 * padding + size {
            
            if let _ = pointCenterBottomConstraint {
                pointCenterBottomConstraint?.isActive = false
            }
            
            if let _ = pointRightBottomConstraint {
                pointRightBottomConstraint?.isActive = false
            }
            
            if let _ = pointCenterTopConstraint2 {
                pointCenterTopConstraint2?.isActive = false
            }
            
            if pointCenterTopConstraint == nil {
                pointCenterTopConstraint = pointCenter?.topToSuperview(offset: padding, relation: .equalOrGreater)
            }
            
            if pointRightTopConstraint == nil {
                pointRightTopConstraint = pointRight?.topToSuperview(offset: padding, relation: .equalOrGreater)
            }
        }
        
        if height > 2 * padding + size {
            
            if pointCenterBottomConstraint == nil, pointCenterTopConstraint2 == nil {
                pointCenterBottomConstraint = pointCenter?.bottomToSuperview(offset: -padding)
            }
            
            if pointRightBottomConstraint == nil, pointRightTopConstraint2 == nil {
                pointRightBottomConstraint = pointRight?.bottomToSuperview(offset: -padding)
            }
        }
        
        if height < 2 * padding + size + 20, pointCenterTopConstraint2 != nil {
            pointCenterTopConstraint2?.isActive = false
            pointCenterBottomConstraint = pointCenter?.bottomToSuperview(offset: -padding)
        }
        
        if height > 2 * padding + size + 20, pointCenterTopConstraint2 == nil {
            pointCenterBottomConstraint?.isActive = false
            pointCenterTopConstraint?.isActive = false
            pointCenterTopConstraint2 = pointCenter?.topToSuperview(offset: padding + 20)
        }
        
        if height < 2 * padding + size + 40, pointRightTopConstraint2 != nil {
            pointRightTopConstraint2?.isActive = false
            pointRightBottomConstraint = pointRight?.bottomToSuperview(offset: -padding)
        }
        
        if height > 2 * padding + size + 40, pointRightTopConstraint2 == nil {
            pointRightBottomConstraint?.isActive = false
            pointRightTopConstraint?.isActive = false
            pointRightTopConstraint2 = pointRight?.topToSuperview(offset: padding + 40)
        }
    }
    
    func centerPoints() {
        superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.pointLeftTopConstraint?.isActive = false
            self.pointRightTopConstraint2?.isActive = false
            if let pointCenter = self.pointCenter {
                self.pointLeftCenterConstraint = self.pointLeft?.centerY(to: pointCenter)
                self.pointRightCenterConstraint = self.pointRight?.centerY(to: pointCenter)
            }
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.animatePoints()
        })
    }
    
    func animatePoints() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.pointLeft?.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.1, options: [.repeat, .autoreverse], animations: {
            self.pointCenter?.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.pointRight?.alpha = 0
        }, completion: nil)
    }
    
    func prepareReset() {
        heightConstraint?.constant = 0
    }
    
    func reset() {
        pointLeft?.layer.removeAllAnimations()
        pointCenter?.layer.removeAllAnimations()
        pointRight?.layer.removeAllAnimations()
        pointLeft?.alpha = 1
        pointCenter?.alpha = 1
        pointRight?.alpha = 1
        pointLeftCenterConstraint?.isActive = false
        pointCenterBottomConstraint?.isActive = false
        pointCenterTopConstraint2?.isActive = false
        pointRightBottomConstraint?.isActive = false
        pointRightTopConstraint2?.isActive = false
        pointRightCenterConstraint?.isActive = false
        pointLeftTopConstraint = pointLeft?.topToSuperview(offset: padding, relation: .equalOrGreater)
        pointCenterTopConstraint = pointCenter?.topToSuperview(offset: padding, relation: .equalOrGreater)
        pointRightTopConstraint = pointRight?.topToSuperview(offset: padding, relation: .equalOrGreater)
    }
    
    func configure(withTableView tableView: UITableView) {
        tableView.superview?.addSubview(self)
        leftToSuperview()
        topToSuperview()
        rightToSuperview()
        heightConstraint = height(0)
        
        pointCenter = createPoint()
        pointCenter?.centerXToSuperview()
        pointCenterTopConstraint = pointCenter?.topToSuperview(offset: padding, relation: .equalOrGreater)
        
        if let pointCenter = pointCenter {
            pointLeft = createPoint()
            pointLeft?.rightToLeft(of: pointCenter, offset: -spacing)
            pointLeftTopConstraint = pointLeft?.topToSuperview(offset: padding, relation: .equalOrGreater)
        }
        
        if let pointCenter = pointCenter {
            pointRight = createPoint()
            pointRight?.leftToRight(of: pointCenter, offset: spacing)
            pointRightTopConstraint = pointRight?.topToSuperview(offset: padding, relation: .equalOrGreater)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPoint() -> UIView {
        let point = UIView()
        addSubview(point)
        point.height(size)
        point.width(size)
        point.layer.cornerRadius = size / 2
        point.backgroundColor = .white
        return point
    }
}
