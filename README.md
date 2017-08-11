# SlidingSideView

Tool for displaying any kind of side views by sliding them out of the edge of the screen, written in Swift 3. It supports every screen egde(left, right, top and bottom)and handles the presentation programmaticaly.

To use it, you have to provide your own view or view controller's view that you want to display and embed it in `SlidingSideView`. 

It can be treated as a regular `UIView` subclass, and be embedded in regular `UIView` to achieve similar effects in different contexts.

## Requirements

* iOS 8.0+
* Swift 3 (Objective-C currently unsupported)
* Xcode 8.x (previous versions not tested)

## Installation

### Manual install
Download the latest version from the release section. Then copy SlidingSideView folder to your project.

### CocoaPods
Add the following lines to your `Podfile`:
```ruby
use_frameworks!

pod 'SlidingSideView', :git => 'https://github.com/fredyshox/SlidingSideView.git', :tag => '0.3.0'
```

## Usage

Firstly we have to initialize SlidingSideView instance. It supports every edge of its container which you can specify by passing `SlidingSideViewAnchor` enum instance which can be `.top` , `.bottom`, `.right`, `.left`.

You also have to pass appropriate height `CGFloat` values, for standard(normal) height and expanded(optional) height. These are height values for view when being slided out.

```swift
    import SlidingSideView

    ...

    let normalHeight = 100.0 
    let expandedHeigth = 200.0
    let slidingSideView = SlidingSideView(.bottom ,withNormalHeight: normalHeight, expandedHeight: expandedHeight)
```
Then just add it as subview. SlidingSideView will now create relevant constraints and it will be ready to use!

```swift
    self.view.addSubview(slidingSideView)
```

### Sliding Out

To slide the view out just set `currentState` property. The SlidingSideView will now adjust its visibility and height: not visible for `.collapsed`, visible with normalHeight for `.normal`, visible with expandedHeight for `.expanded`(or the same as normal if expandedHeight is nil).

```swift
    slidingSideView.currentState = .normal //slide out with height equal to normalHeight
    ...
    slidingSideView.currentState = .collapsed //slide off the screen and gets hidden
```

### Layout relative to ViewController's layoutGuides

SlidingSideView can be positioned with respect to viewController layoutGuides. To do this you have to set its `topLayoutGuide` of `bottomLayoutGuide` properties to proper ViewController's ones.
Note that it should be done before adding SlidingSideView as a subview. 

It's especially helpful when using `UINavigationController`, `UITabBarController` or just status bar.

```swift
    slidingSideView.topLayouyGuide = self.topLayoutGuide
    slidingSideView.bottomLayoutGuide = self.bottomLayoutGuide
    ...
    //after setting layoutGuides add it as a subview
    self.view.addSubview(slidingSideView) 
```
### Delegate

You can be notified about views `currentState` changes that occured or will occure by providing delegate - object conforming SlidingSideViewDelegate. 

### Demo 
Try out example project - SlidingSideViewDemo.

## Future

Tool is still under development and not all planned functionality is implemented. 

List of future capabilities:

* gestures support(`UIPanGestureRecognizer` and `UITapGestureRecognizer`)
* slide animation options and customization
* Container View Controller with several SlidingSideViews embedded
