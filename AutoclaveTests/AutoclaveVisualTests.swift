//
//  AutoclaveTests.swift
//  AutoclaveTests
//
//  Created by Kyle Truscott on 11/6/15.
//  Copyright © 2015 keighl. All rights reserved.
//

import XCTest
@testable import Autoclave

class AutoclaveVisualTests: XCTestCase {
    
    let superview = UIView()
    let view1 = UIView()
    let view2 = UIView()
    var views = [String: UIView]()
    let metrics = [
        "width": 200,
    ]
    
    override func setUp() {
        super.setUp()
        superview.addSubview(view1)
        superview.addSubview(view2)
        self.views = [
            "view1": view1,
            "view2": view2,
        ]
    }
    
    func testVisual_Basic() {
        let constraints = AC.visual(views)
            .format("|[view1][view2]|")
            .constraints()
        let regConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[view1][view2]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        XCTAssertEqual(constraints.count, regConstraints.count)
    }
    
    func testVisual_Robusto() {
        let constraints = AC.visual(views)
            .format("[view1(width)][view2(width)]")
            .metrics(metrics)
            .options(.AlignAllLastBaseline)
            .constraints()
        let regConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[view1(width)][view2(width)]", options: .AlignAllLastBaseline, metrics: metrics, views: views)
        XCTAssertEqual(constraints.count, regConstraints.count)
    }
    
    func testVisual_AddTo() {                
        let constraints = AC.visual(views)
            .format("|[view1][view2]|")
            .addTo(superview)

        XCTAssertEqual(superview.constraints.count, constraints.count)
    }
}
