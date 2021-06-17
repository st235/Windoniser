import Foundation

class LayoutSchemaRenderer {
    
    static func render(layoutSchema: LayoutSchema, appearance: NSAppearance) -> NSImage {
        let layoutSchemaPreviewView = LayoutSchemaPreviewView(frame: NSRect(x: 0, y: 0, width: 24, height: 24))
        layoutSchemaPreviewView.addLayoutPreviews(layoutSeparators: layoutSchema.separators)
        layoutSchemaPreviewView.highlightColor = NSColor.from(name: .iconPrimary)
        layoutSchemaPreviewView.verticalPadding = 0.2
        layoutSchemaPreviewView.horizontalPadding = 0.15
        layoutSchemaPreviewView.borderWidth = 2
        layoutSchemaPreviewView.gridWidth = 1.5
        layoutSchemaPreviewView.appearance = appearance
        return layoutSchemaPreviewView.asImage()
    }
    
}
