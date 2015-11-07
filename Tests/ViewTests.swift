//
//  AutoclaveTests.swift
//  Autoclave
//
//  Created by Kyle Truscott on 11/6/15.
//  Copyright © 2015 keighl. All rights reserved.
//

import XCTest
@testable import Autoclave

class ViewTests: XCTestCase {

    let superview = View()
    let view1 = View()
    let view2 = View()
    
    override func setUp() {
        super.setUp()
        superview.addSubview(view1)
        superview.addSubview(view2)
    }

    func basicTester(relation: NSLayoutRelation) {
        var cur = AC(view1, view2).make(.CenterX, .Width)
        if relation == .Equal {
           cur = cur.sameAs(superview)
        }
        
        if relation == .GreaterThanOrEqual {
            cur = cur.greaterThan(superview)
        }
        
        if relation == .LessThanOrEqual {
            cur = cur.lessThan(superview)
        }

        let constraints = cur.constraints()
        XCTAssertEqual(constraints.count, 4)
        
        let views = [view1, view1, view2, view2]
        let attrs: [NSLayoutAttribute] = [.CenterX, .Width, .CenterX, .Width]
        
        for (i, c) in constraints.enumerate() {
            XCTAssertEqual(c.relation, relation)
            XCTAssertEqual(c.firstAttribute, attrs[i])
            XCTAssertEqual(c.secondAttribute, attrs[i])
            
            if !c.firstItem.isEqual(views[i]) {
                XCTFail("First item is incorrect")
            }
            if let second = c.secondItem {
                if !second.isEqual(superview) {
                    XCTFail("Second item is not supeview")
                }
            } else {
                XCTFail("Second item is nil")
            }
        }
    }
    
    func testEqual() {
        basicTester(.Equal)
    }
    
    func testLessThan() {
        basicTester(.LessThanOrEqual)
    }
    
    func testGreaterThan() {
        basicTester(.GreaterThanOrEqual)
    }
    
    func testAltTargetAttr() {
        let constraints = AC(view1, view2)
            .make(.Width, .Height)
            .sameAs(superview, attr: .Width)
            .constraints()
        
        XCTAssertEqual(constraints.count, 4)
        let views = [view1, view1, view2, view2]
        let attrs: [NSLayoutAttribute] = [.Width, .Height, .Width, .Height]
        
        for (i, c) in constraints.enumerate() {
            XCTAssertEqual(c.firstAttribute, attrs[i])
            XCTAssertEqual(c.secondAttribute, NSLayoutAttribute.Width)
            
            if !c.firstItem.isEqual(views[i]) {
                XCTFail("First item is incorrect")
            }
            if let second = c.secondItem {
                if !second.isEqual(superview) {
                    XCTFail("Second item is not supeview")
                }
            } else {
                XCTFail("Second item is nil")
            }
        }
    }
    
    func testExtraProperties() {
        let constraints = AC(view1, view2)
            .make(.Width, .Height)
            .sameAs(superview)
            .multiplier(0.6)
            .constant(200)
            .priority(1000)
            .addTo(superview)

        XCTAssertEqual(constraints.count, 4)
        let views = [view1, view1, view2, view2]
        let attrs: [NSLayoutAttribute] = [.Width, .Height, .Width, .Height]
        
        for (i, c) in constraints.enumerate() {
            XCTAssertEqual(c.firstAttribute, attrs[i])
            XCTAssertEqual(c.secondAttribute, attrs[i])
            XCTAssertEqualWithAccuracy(c.multiplier, 0.6, accuracy: 0.001)
            XCTAssertEqual(c.priority, 1000)
            XCTAssertEqual(c.constant, 200)
            
            if !c.firstItem.isEqual(views[i]) {
                XCTFail("First item is incorrect")
            }
            if let second = c.secondItem {
                if !second.isEqual(superview) {
                    XCTFail("Second item is not supeview")
                }
            } else {
                XCTFail("Second item is nil")
            }
        }
        
        XCTAssertEqual(superview.constraints.count, constraints.count)
    }
    
    func testNoSecondView() {
        let constraints = AC(view1, view2).make(.Width).constant(200).constraints()
        XCTAssertEqual(constraints.count, 2)
        let views = [view1, view2]
        for (i, c) in constraints.enumerate() {
            XCTAssertEqual(c.relation, NSLayoutRelation.Equal)
            XCTAssertEqual(c.firstAttribute, NSLayoutAttribute.Width)
            XCTAssertEqual(c.secondAttribute, NSLayoutAttribute(rawValue: 0))
            XCTAssertEqual(c.constant, 200)
            if !c.firstItem.isEqual(views[i]) {
                XCTFail("First item is incorrect")
            }
            if c.secondItem != nil {
                XCTFail("Second item should be nil")
            }
        }
    }
}
