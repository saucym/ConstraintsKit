Extremely simplified constraint component, one line of code solves constraint layout.

## Requirements

- Xcode 9.0+
- iOS 9.0+
- Interoperability with Swift 4.0+

## Installation

### CocoaPods

The preferred installation method is with [CocoaPods](https://cocoapods.org). Add the following to your `Podfile`:

```ruby
pod 'ConstraintsKit'
```

## Quick Start
### Objc
```Swift
#import <ConstraintsKit/ConstraintsKit.h>

view.wy_left(button).wy_right(button).wy_top(button.bottomAnchor).offset(5).wy_height(30);

//Or like this
view
.wy_left(button)
.wy_right(button)
.wy_top(button.bottomAnchor).offset(5)
.wy_height(30);

//Or like this
[view wy_makeConstraints:^(WYConstraints *make) {
   make.wy_left(button);
   make.wy_right(button);
   make.wy_height(30);
   make.wy_top(button.bottomAnchor).offset(5);
}];        

//You can modify the height you just set
view.wy.heightConstant.constant = 50;
```
### Swift
```Swift
import ConstraintsKit

view.wy_left(button).wy_right(button).wy_top(button.bottomAnchor).offset(5).wy_height(30)
//Or like this
view.wy_makeConstraints { (make) in
    make.wy_left(button)
    make.wy_right(button)
    make.wy_height(30)
    make.wy_top(button.bottomAnchor).offset(5)
}                 
```
## License

`ConstraintsKit`  is [MIT-licensed](./LICENSE).
