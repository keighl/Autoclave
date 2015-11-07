//
//  AutoclaveTests.swift
//  AutoclaveTests
//
//  Created by Kyle Truscott on 11/6/15.
//  Copyright © 2015 keighl. All rights reserved.
//

import XCTest
@testable import Autoclave

class VisualTests: XCTestCase {
    
    let superview = View()
    let view1 = View()
    let view2 = View()
    var views = [String: View]()
    let optsNone = NSLayoutFormatOptions(rawValue: 0)
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
    
    func testBasic() {
        let constraints = AC.visual(views)
            .format("|[view1][view2]|")
            .constraints()
        let regConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[view1][view2]|", options: optsNone, metrics: nil, views: views)
        XCTAssertEqual(constraints.count, regConstraints.count)
    }
    
    func testExtraProperties() {
        let constraints = AC.visual(views)
            .format("[view1(width)][view2(width)]")
            .metrics(metrics)
            .options(.AlignAllLastBaseline)
            .constraints()
        let regConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[view1(width)][view2(width)]", options: .AlignAllLastBaseline, metrics: metrics, views: views)
        XCTAssertEqual(constraints.count, regConstraints.count)
    }
    
    func testFormatChain() {
        let constraints = AC.visual(views)
            .format("[view1][view2]")
            .format("V:|[view1][view2]|")
            .constraints()
        let regConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[view1][view2]", options: optsNone, metrics: nil, views: views)
        let regVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view1][view2]|", options: optsNone, metrics: nil, views: views)

        XCTAssertEqual(constraints.count, regConstraints.count + regVConstraints.count)
    }
    
    func testAddTo() {
        let constraints = AC.visual(views)
            .format("|[view1][view2]|")
            .addTo(superview)

        XCTAssertEqual(superview.constraints.count, constraints.count)
    }
}
