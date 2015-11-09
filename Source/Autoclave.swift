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

/**
 Alias of Autoclave
 */
public typealias AC = Autoclave

public class Autoclave {
    let views: [View]

    /**
     Prepare a set of views to be constrained. Must be followed by the make() method.
     
     - parameter views: view objects to be constrained (variadic)
     */
    public init(_ views: View...) {
        self.views = views
    }

    /**
     Declare which layout attributes are going to be constrained.
     
     ```
     AC(button1, button2)
        .make(.Width, CenterY)
        .sameAs(view)
        .addTo(view)
     ```
     
     - parameter attrs: layout attributes (variadic)
     */
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

    /**
     Prepare a dictionary of views to be constrained with VFL.
     
     ```
     let views = ["image": imageView]
     AC.visual(views)
        .format("|[image]|")
        .format("V:|[image]|")
        .addTo(view)
     ```
     
     - parameter views: dictionary of views
     */
    public class func visual(views: [String: View]) -> AutoclaveVisualCursor {
        return AutoclaveVisualCursor(views: views, metrics: nil, formats: [], options: NSLayoutFormatOptions(rawValue: 0))
    }
}

/**
 Holds parameter values to be used in constraint construction.
 */
public struct AutoclaveCursor {
    let views: [View]
    var attrs: [NSLayoutAttribute] = []
    var toAttr: NSLayoutAttribute?
    var toView: View?
    var relation: NSLayoutRelation = .Equal
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0.0
    var priority: Priority?

    /**
    Sets up the cursor to produce NSLayoutRelationEqual relation constraints.
     
    - parameter view: The view for the "right" side of the constraint
    - parameter attr: The attribute for the "right" side of the constraint. By default this value will be equal to the attribute(s) received by `make()`
    */
    public func sameAs(view: View, attr: NSLayoutAttribute? = nil) -> AutoclaveCursor {
        var cursor = self
        cursor.toView = view
        cursor.toAttr = attr
        cursor.relation = .Equal
        return cursor
    }

    /**
     Sets up the cursor to produce NSLayoutRelationLessThanOrEqual relation constraints.
     
     - parameter view: The view for the "right" side of the constraint
     - parameter attr: The attribute for the "right" side of the constraint. By default this value will be equal to the attribute(s) received by `make()`
     */
    public func lessThan(view: View, attr: NSLayoutAttribute? = nil) -> AutoclaveCursor {
        var cursor = self
        cursor.toView = view
        cursor.toAttr = attr
        cursor.relation = .LessThanOrEqual
        return cursor
    }

    /**
     Sets up the cursor to produce NSLayoutRelationGreaterThanOrEqual relation constraints.
     
     - parameter view: The view for the "right" side of the constraint
     - parameter attr: The attribute for the "right" side of the constraint. By default this value will be equal to the attribute(s) received by `make()`
     */
    public func greaterThan(view: View, attr: NSLayoutAttribute? = nil) -> AutoclaveCursor {
        var cursor = self
        cursor.toView = view
        cursor.toAttr = attr
        cursor.relation = .GreaterThanOrEqual
        return cursor
    }

    /**
     Sets up the cursor to produce constraint(s) with a multiplier. By default, the multiplier is 1.0.
     
     - parameter multiplier: The multiplier
     */
    public func multiplier(multiplier: CGFloat) ->  AutoclaveCursor {
        var cursor = self
        cursor.multiplier = multiplier
        return cursor
    }

    /**
     Sets up the cursor to produce constraint(s) with a constant. By default, the constant is 0.0.
     
     - parameter constant: The constant
     */
    public func constant(constant: CGFloat) ->  AutoclaveCursor {
        var cursor = self
        cursor.constant = constant
        return cursor
    }

    /**
     Sets up the cursor to produce constraint(s) with a priority. By default, there is no priority added to constraints.
     
     - parameter priority: The priority
     */
    public func priority(priority: Priority) ->  AutoclaveCursor {
        var cursor = self
        cursor.priority = priority
        return cursor
    }

    /**
     Generates constraints, and adds them to the supplied view using `view.addConstraints()`.
     
     - parameter view: The view that will receive the generated constraints
     - returns: The added constraints
     */
    public func addTo(view: View) -> [NSLayoutConstraint] {
        let cs = constraints()
        view.addConstraints(cs)
        return cs
    }

    /**
     Generates the constraints!
     
     - returns: The generated constraints
     */
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

/**
 Holds parameter values to be used in constraint construction.
 */
public struct AutoclaveVisualCursor {
    let views: [String: View]
    var metrics: [String: NSNumber]?
    var formats: [String] = []
    var options: NSLayoutFormatOptions = NSLayoutFormatOptions(rawValue: 0)

    /**
     Add VFL to the cursor. Can be chained!
     
     ```
     let views = ["image": imageView]
     AC.visual(views)
        .format("|[image]|")
        .format("V:|[image]|")
        .addTo(view)
     ```
     
     - parameter format: VFL string
     */
    public func format(format: String) -> AutoclaveVisualCursor {
        var cursor = self
        cursor.formats.append(format)
        return cursor
    }

    /**
     Add metrics dictionary to be used in visual constraints
     
     ```
     let metrics = [
        "imageWidth": 100,
        "captionWidth": 300,
        "space": 5,
     ]
     
     AC.visual(views)
        .metrics(metrics)
        .format("|[image(imageWidth)]-space-[caption(captionWidth)]|")
        .addTo(view)
     ```
     
     - parameter metrics: metrics dictionary
     */
    public func metrics(metrics: [String: NSNumber]) ->  AutoclaveVisualCursor {
        var cursor = self
        cursor.metrics = metrics
        return cursor
    }
    
    /**
     Add an options mask to the constraints to be generated. Defaults to 0
     
     - parameter format: VFL string
     */
    public func options(options: NSLayoutFormatOptions) ->  AutoclaveVisualCursor {
        var cursor = self
        cursor.options = options
        return cursor
    }

    /**
     Generates constraints, and adds them to the supplied view using `view.addConstraints()`.
     
     - parameter view: The view that will receive the generated constraints
     - returns: The added constraints
     */
    public func addTo(view: View) -> [NSLayoutConstraint] {
        let cs = constraints()
        view.addConstraints(cs)
        return cs
    }

    /**
     Generates the constraints!
     
     - returns: The generated constraints
     */
    public func constraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for format in formats {
            let cs = NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views)
            constraints.appendContentsOf(cs)
        }
        return constraints
    }
}



