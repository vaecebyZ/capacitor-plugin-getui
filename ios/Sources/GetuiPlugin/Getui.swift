import Foundation

@objc public class Getui: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
