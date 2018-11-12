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
    private var state = State.ready
    private var oldOffset = CGFloat(0)
    private var canResetFromRefresh = false
    private var canResetFromUI = false
    private weak var tableTopConstraint: NSLayoutConstraint?
    
    var limit: CGFloat {
        return CGFloat(72)
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
        view.updateHeight(max(0, offset))
        
        if offset > oldOffset && offset > limit && state == .ready {
            delegate?.refresh()
            state = .pulling
        } else if offset < oldOffset && offset < limit && state == .pulling {
            state = .refreshing
            let constraint = tableTopConstraint ?? _tableView.superview?.constraints.first(where: {$0.firstAttribute == .top})
            constraint?.isActive = false
            tableTopConstraint = _tableView.topToBottom(of: view)
            canResetFromUI = true
            _reloadTable()
        } else if offset == 0 {
            view.reset()
        }
        
        oldOffset = offset
    }
    
    func reloadTable() {
        canResetFromRefresh = true
        _reloadTable()
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
    
    weak var pointCenterTopConstraint: NSLayoutConstraint?
    weak var pointCenterTopConstraint2: NSLayoutConstraint?
    weak var pointCenterBottomConstraint: NSLayoutConstraint?
    
    weak var pointRightTopConstraint: NSLayoutConstraint?
    weak var pointRightTopConstraint2: NSLayoutConstraint?
    weak var pointRightBottomConstraint: NSLayoutConstraint?
    
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
        
        if height > 2 * padding + size {
            
            if pointCenterBottomConstraint == nil, pointCenterTopConstraint2 == nil {
                pointCenterBottomConstraint = pointCenter?.bottomToSuperview(offset: -padding)
            }
            
            if pointRightBottomConstraint == nil, pointRightTopConstraint2 == nil {
                pointRightBottomConstraint = pointRight?.bottomToSuperview(offset: -padding)
            }
        }
        
        if height > 2 * padding + size + 10, pointCenterTopConstraint2 == nil {
            pointCenterBottomConstraint?.isActive = false
            pointCenterTopConstraint?.isActive = false
            pointCenterTopConstraint2 = pointCenter?.topToSuperview(offset: padding + 10)
        }
        
        if height > 2 * padding + size + 20, pointRightTopConstraint2 == nil {
            pointRightBottomConstraint?.isActive = false
            pointRightTopConstraint?.isActive = false
            pointRightTopConstraint2 = pointRight?.topToSuperview(offset: padding + 20)
        }
    }
    
    func prepareReset() {
        heightConstraint?.constant = 0
    }
    
    func reset() {
        pointCenterBottomConstraint?.isActive = false
        pointCenterTopConstraint2?.isActive = false
        pointRightBottomConstraint?.isActive = false
        pointRightTopConstraint2?.isActive = false
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
            pointLeft?.topToSuperview(offset: padding)
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
