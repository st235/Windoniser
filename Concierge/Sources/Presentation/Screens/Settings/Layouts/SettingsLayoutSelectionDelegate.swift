import Foundation

final class SettingsLayoutSelectionDelegate: NSObject, UiDelegate {
    
    private let header: NSTextField
    private let content: NSCollectionView
    
    private let layoutSchemasInteractor: LayoutSchemesInteractor
    
    private var selectedSchemas: [LayoutSchema] = []
    
    init(header: NSTextField,
         content: NSCollectionView,
         layoutSchemasInteractor: LayoutSchemesInteractor) {
        self.header = header
        self.content = content
        self.layoutSchemasInteractor = layoutSchemasInteractor
    }
    
    func update() {
        selectedSchemas = layoutSchemasInteractor.defaultSchemes()
        
        updateHeader()
        updateContent()
    }
    
    private func updateHeader() {
        
    }
    
    private func updateContent() {
        content.dataSource = self
        content.delegate = self
        content.enclosingScrollView?.horizontalScroller?.alphaValue = 0.0
        content.backgroundColors = [.clear]
        content.isSelectable = true
    }
    
}

extension SettingsLayoutSelectionDelegate: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSchemas.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("LayoutSchemesCollectionViewItem"), for: indexPath) as? LayoutSchemesCollectionViewItem else {
            fatalError("Cannot load")
        }
        
        let layoutScheme = selectedSchemas[indexPath.item]
        
        item.load(scheme: layoutScheme, isSelected: layoutSchemasInteractor.isSelected(schema: layoutScheme))

        return item
    }
    
}

extension SettingsLayoutSelectionDelegate: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {        
        onItemClick(collectionView, didSelectItemsAt: indexPaths)
        collectionView.deselectItems(at: indexPaths)
    }
    
    private func onItemClick(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            fatalError()
        }
        
        let item = selectedSchemas[indexPath.item]
   
        if let newCell = collectionView.item(at: indexPath) as? LayoutSchemesCollectionViewItem {
            if !layoutSchemasInteractor.canBeUnselected(schema: item) || !layoutSchemasInteractor.isSelected(schema: item) {
                layoutSchemasInteractor.selectSchema(schema: item)
                newCell.select()
            } else {
                layoutSchemasInteractor.unselectSchema(schema: item)
                newCell.deselect()
            }
        }
    }
    
}
