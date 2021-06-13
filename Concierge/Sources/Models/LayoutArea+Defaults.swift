import Foundation

extension LayoutArea {
    private static let keyMain = "title_area_main"
    private static let keyLeft = "title_area_left"
    private static let keyRight = "title_area_right"
    private static let keyTop = "title_area_top"
    private static let keyBottom = "title_area_bottom"
    private static let keyTopLeft = "title_area_top_left"
    private static let keyTopRight = "title_area_top_right"
    private static let keyBottomLeft = "title_area_bottom_left"
    private static let keyBottomRight = "title_area_bottom_right"
    private static let keyOne = "title_area_one"
    private static let keyTwo = "title_area_two"
    private static let keyThree = "title_area_three"
    
    static let main = LayoutArea(titleKey: LayoutArea.keyMain, activeKey: .space, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 1, height: 1))
    static let left = LayoutArea(titleKey: LayoutArea.keyLeft, activeKey: .leftArrow, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1))
    static let right = LayoutArea(titleKey: LayoutArea.keyRight, activeKey: .rightArrow, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
    static let top = LayoutArea(titleKey: LayoutArea.keyTop, activeKey: .upArrow, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0.5, width: 1, height: 0.5))
    static let bottom = LayoutArea(titleKey: LayoutArea.keyBottom, activeKey: .downArrow, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 1, height: 0.5))
    static let topLeft = LayoutArea(titleKey: LayoutArea.keyTopLeft, activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0.5, width: 0.5, height: 0.5))
    static let topRight = LayoutArea(titleKey: LayoutArea.keyTopRight, activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
    static let bottomLeft = LayoutArea(titleKey: LayoutArea.keyBottomLeft, activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 0.5))
    static let bottomRight = LayoutArea(titleKey: LayoutArea.keyBottomRight, activeKey: .four, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
    static let verticalOneThird = LayoutArea(titleKey: LayoutArea.keyOne, activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: (1.0/3.0), height: 1))
    static let verticalTwoThird = LayoutArea(titleKey: LayoutArea.keyTwo, activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 1.0 / 3.0, y: 0, width: (1.0/3.0), height: 1))
    static let verticalThreeThird = LayoutArea(titleKey: LayoutArea.keyThree, activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: (2.0 / 3.0), y: 0, width: (1.0/3.0), height: 1))
}
