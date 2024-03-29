import Foundation

class LayoutSchemaRenderer {
    
    static func render(layoutSchema: LayoutSchema, highlightColor: NSColor) -> NSImage {
        let layoutSchemaPreviewView = LayoutSchemaPreviewView(frame: NSRect(x: 0, y: 0, width: 24, height: 24))
        layoutSchemaPreviewView.addLayoutPreviews(layoutSeparators: layoutSchema.separators)
        layoutSchemaPreviewView.strokeColor = highlightColor
        layoutSchemaPreviewView.verticalPadding = 0.2
        layoutSchemaPreviewView.horizontalPadding = 0.15
        layoutSchemaPreviewView.borderWidth = 2
        layoutSchemaPreviewView.gridWidth = 1.5
        return layoutSchemaPreviewView.asImage()
    }
    
    static func render(layoutSchema: LayoutSchema, strokeColor: NSColor, highlightedArea: NSRect, highlightColor: NSColor) -> NSImage {
        let layoutSchemaPreviewView = LayoutSchemaPreviewView(frame: NSRect(x: 0, y: 0, width: 24, height: 24))
        layoutSchemaPreviewView.addLayoutPreviews(layoutSeparators: layoutSchema.separators)
        layoutSchemaPreviewView.highlightArea(area: highlightedArea)
        layoutSchemaPreviewView.strokeColor = strokeColor
        layoutSchemaPreviewView.highlightColor = highlightColor
        layoutSchemaPreviewView.verticalPadding = 0.2
        layoutSchemaPreviewView.horizontalPadding = 0.15
        layoutSchemaPreviewView.borderWidth = 2
        layoutSchemaPreviewView.gridWidth = 1.5
        return layoutSchemaPreviewView.asImage()
    }
    
}
