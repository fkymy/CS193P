//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let center = NotificationCenter.default
var observer = center.addObserver(
    forName: Notification.Name.UIContentSizeCategoryDidChange,
    object: UIApplication.shared,
    queue: OperationQueue.main
) { notification in
    let c = notification.userInfo?[UIContentSizeCategoryNewValueKey]
}
