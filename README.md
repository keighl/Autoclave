# Autoclave

[![Build Status](https://travis-ci.org/keighl/Autoclave.png?branch=master)](https://travis-ci.org/keighl/Autoclave)
[![codecov.io](https://codecov.io/github/keighl/Autoclave/coverage.svg?branch=master)](https://codecov.io/github/keighl/Autoclave?branch=master)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Autoclave.svg)](https://img.shields.io/cocoapods/v/Autoclave.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Autoclave is your easygoing Autolayout friend. It condenses your constraint definitions into simple chained methods.

You can write this:

```
AC(button).make(.CenterX, .CenterY).sameAs(view).addTo(view)
```

Instead of this:

```
view.addConstraint(NSLayoutConstraint(
    item: button,
    attribute: .CenterX,
    relatedBy: .Equal,
    toItem: view,
    attribute: .CenterX,
    multiplier: 1,
    constant: 0))

view.addConstraint(NSLayoutConstraint(
    item: button,
    attribute: .CenterY,
    relatedBy: .Equal,
    toItem: view,
    attribute: .CenterY,
    multiplier: 1,
    constant: 0))
```

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Autoclave into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Autoclave'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Autoclave into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "keighl/Autoclave"
```

Run `carthage` to build the framework and drag the built `Autoclave.framework` into your Xcode project.

## Usage

#### Basic

Constrain `CenterX` of `button` as equal to `view`. Add the constraint to `view`.

```swift
AC(button).make(.CenterX).sameAs(view).addTo(view)
```

*Note:* `addTo()` returns generated constraints if you need to reference them. E.g:

```swift
let buttonConstraints = AC(button)
	.make(.CenterX)
	.sameAs(view).addTo(view)
```

#### Multiple views

Constrain the `Width` of each item (`button`, `image`, `label`) to be the same as `view`. Add the constraints to `view`.

```swift
AC(button, image, label)
	.make(.Width)
	.sameAs(view)
	.addTo(view)
```

#### Multiple attributes

Constrains the button's `CenterX`, `CenterY`, `Width`, `Height` to the respective attributes of `view`. Add the constraints to `view`.

```swift
AC(button).make(.CenterX, .CenterY, .Width, .Height)
	.sameAs(view)
	.addTo(view)
```
Bonus! Lots of attributes on lots of views.

```swift
AC(button, image, label)
	.make(.CenterX, .CenterY, .Width, .Height)
	.sameAs(view)
	.addTo(view)
```

#### Specific target-view attribute

Constrain the `Width` of each item (`button`, `image`, `label`) to be the same as `view` `Height`. Add the constraints to `view`.

```swift
AC(button, image, label)
	.make(.Width)
	.sameAs(view, attr: .Height)
	.addTo(view)
```

#### lessThan(), greaterThan()

```swift
AC(button).make(.Height)
	.lessThan(view)
	.addTo(view)
```

```swift
AC(button).make(.Height)
	.greaterThan(view)
	.addTo(view)
```

#### multiplier()

```swift
AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.multiplier(0.8)
	.addTo(view)
```

#### constant()

```swift
AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.constant(-30.0)
	.addTo(view)
```

#### priority()

The priority method will set a specific priority for all generated constraints.

```swift
AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.priority(UILayoutPriorityRequired)
	.addTo(view)
```

#### constraints()

```swift
let constraints = AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.constraints()
```

## Usage (Visual Format)

### Format

With Autoclave, you can chain multiple calls to `format()` which will produce multiple constraint sets for the same view dictionary. `addTo()` will add the produced constraints to a view.

```swift
let views = [
    "title": titleLabel,
    "body": bodyLabel,
]

AC.visual(views)
    .format("V:|-[title]-[body]-|")
    .format("|[title]|")
    .format("|[body]|")
    .addTo(view)
```

*Note:* `addTo()` returns generated constraints if you need to reference them. E.g:

```swift
let constraints = AC.visual(views)
	.format("V:|-[title]-[body]-|")
    .addTo(view)
```

#### metrics()

```swift
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

#### options()

If you need to supply format options to your constraints, use `options()` to supply and options mask.

```swift
AC.visual(views)
    .format("|[image][caption]|")
    .options(.AlignAllCenterX)
    .addTo(view)
```

#### constraints()

```swift
let constraints = AC.visual(views)
    .format("V:|-[title]-[body]-|")
    .format("|[title]|")
    .format("|[body]|")
    .constraints()
```


