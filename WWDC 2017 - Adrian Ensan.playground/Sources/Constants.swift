import SpriteKit

public let fps: CGFloat = 60
public let leftKey: UInt16 = 123
public let rightKey: UInt16 = 124
public let aKey: UInt16 = 0
public let dKey: UInt16 = 2
public let spaceKey: UInt16 = 49
public let enterKey: UInt16 = 36
public let backspaceKey: UInt16 = 51

public func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let a = point2.x - point1.x
    let b = point2.y - point1.y
    return sqrt(a * a + b * b)
}
