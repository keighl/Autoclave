# Autoclave

[![Build Status](https://travis-ci.org/keighl/Autoclave.png?branch=master)](
https://travis-ci.org/keighl/Autoclave) [![codecov.io](https://codecov.io/github/keighl/Autoclave/coverage.svg?branch=master)](https://codecov.io/github/keighl/Autoclave?branch=master)

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

## Usage

#### Basic

Constrain `CenterX` of `button` as equal to `view`. Add the constraint to `view`.

```
AC(button).make(.CenterX).sameAs(view).addTo(view)
```

*Note:* `addTo()` returns generated constraints if you need to reference them. E.g: 

```
let buttonConstraints = AC(button)
	.make(.CenterX)
	.sameAs(view).addTo(view)
```

#### Multiple views

Constrain the `Width` of each item (`button`, `image`, `label`) to be the same as `view`. Add the constraints to `view`.

```
AC(button, image, label)
	.make(.Width)
	.sameAs(view)
	.addTo(view)		
```

#### Multiple attributes

Constrains the button's `CenterX`, `CenterY`, `Width`, `Height` to the respective attributes of `view`. Add the constraints to `view`.

```
AC(button).make(.CenterX, .CenterY, .Width, .Height)
	.sameAs(view)
	.addTo(view)		
```
Bonus! Lots of attributes on lots of views. 

```
AC(button, image, label)
	.make(.CenterX, .CenterY, .Width, .Height)
	.sameAs(view)
	.addTo(view)		
```

#### Specific target-view attribute

Constrain the `Width` of each item (`button`, `image`, `label`) to be the same as `view` `Height`. Add the constraints to `view`.

```
AC(button, image, label)
	.make(.Width)
	.sameAs(view, attr: .Height)
	.addTo(view)		
```

#### lessThan(), greaterThan()

```
AC(button).make(.Height)
	.lessThan(view)
	.addTo(view)		
```

```
AC(button).make(.Height)
	.greaterThan(view)
	.addTo(view)		
```

#### multiplier()

```
AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.multiplier(0.8)
	.addTo(view)		
```

#### constant()

```
AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.constant(-30.0)
	.addTo(view)		
```

#### priority()

The priority method will set a specific priority for all generated constraints. 

```
AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.priority(UILayoutPriorityRequired)
	.addTo(view)			
```

#### constraints()

```
let constraints = AC(image)
	.make(.Width, .Height)
	.sameAs(view)
	.constraints()
```

## Usage (Visual Format)




