//
//  Autoclave.swift
//  Autoclave
//
//  Created by Kyle Truscott on 11/6/15.
//  Copyright © 2015 keighl. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(iOS)
    import UIKit
    public typealias View = UIView
    public typealias Priority = UILayoutPriority
#else
    import AppKit
    public typealias View = NSView
    public typealias Priority = NSLayoutPriority
#endif

public typealias AC = Autoclave

public class Autoclave {    
    let views: [View]
    
    public init(_ views: View...) {
        self.views = views
    }
    
    public func make(attrs: NSLayoutAttribute...) -> AutoclaveCursor {
        return AutoclaveCursor(
            views: views,
            attrs: attrs,
            toAttr: nil,
            toView: nil,
            relation: .Equal,
            multiplier: 1.0,
            constant: 0.0,
            priority: nil
        )
    }
    
    public class func visual(views: [String: View]) -> AutoclaveVisualCursor {
        return AutoclaveVisualCursor(views: views, metrics: nil, formats: [], options: NSLayoutFormatOptions(rawValue: 0))
    }
}

public struct AutoclaveCursor {
    let views: [View]
    var attrs: [NSLayoutAttribute] = []
    var toAttr: NSLayoutAttribute?
    var toView: View?
    var relation: NSLayoutRelation = .Equal
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0.0
    var priority: Priority?
    
    public func sameAs(view: View, attr: NSLayoutAttribute? = nil) -> AutoclaveCursor {
        var cursor = self
        cursor.toView = view
        cursor.toAttr = attr
        cursor.relation = .Equal
        return cursor
    }
    
    public func lessThan(view: View, attr: NSLayoutAttribute? = nil) -> AutoclaveCursor {
        var cursor = self
        cursor.toView = view
        cursor.toAttr = attr
        cursor.relation = .LessThanOrEqual
        return cursor
    }
    
    public func greaterThan(view: View, attr: NSLayoutAttribute? = nil) -> AutoclaveCursor {
        var cursor = self
        cursor.toView = view
        cursor.toAttr = attr
        cursor.relation = .GreaterThanOrEqual
        return cursor
    }
    
    public func multiplier(multiplier: CGFloat) ->  AutoclaveCursor {
        var cursor = self
        cursor.multiplier = multiplier
        return cursor
    }
    
    public func constant(constant: CGFloat) ->  AutoclaveCursor {
        var cursor = self
        cursor.constant = constant
        return cursor
    }
    
    public func priority(priority: Priority) ->  AutoclaveCursor {
        var cursor = self
        cursor.priority = priority
        return cursor
    }
    
    public func addTo(view: View) -> [NSLayoutConstraint] {
        let cs = constraints()
        view.addConstraints(cs)
        return cs
    }
    
    public func constraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []        
        for view in views {
            for attr in attrs {
                var targetAttr = attr
                if let toa = toAttr {
                    targetAttr = toa
                }
                let c = NSLayoutConstraint(item: view, attribute: attr, relatedBy: relation, toItem: toView, attribute: targetAttr, multiplier: multiplier, constant: constant)
                if let prior = priority {
                    c.priority = prior
                }
                constraints.append(c)
            }
        }
        
        return constraints
    }
}

public struct AutoclaveVisualCursor {
    let views: [String: View]
    var metrics: [String: NSNumber]?
    var formats: [String] = []
    var options: NSLayoutFormatOptions = NSLayoutFormatOptions(rawValue: 0)
    
    public func format(format: String) -> AutoclaveVisualCursor {
        var cursor = self
        cursor.formats.append(format)
        return cursor
    }
    
    public func metrics(metrics: [String: NSNumber]) ->  AutoclaveVisualCursor {
        var cursor = self
        cursor.metrics = metrics
        return cursor
    }
    
    public func addTo(view: View) -> [NSLayoutConstraint] {
        let cs = constraints()
        view.addConstraints(cs)
        return cs
    }
    
    public func options(options: NSLayoutFormatOptions) ->  AutoclaveVisualCursor {
        var cursor = self
        cursor.options = options
        return cursor
    }
    
    public func constraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for format in formats {
            let cs = NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views)
            constraints.appendContentsOf(cs)
        }
        return constraints
    }
}



