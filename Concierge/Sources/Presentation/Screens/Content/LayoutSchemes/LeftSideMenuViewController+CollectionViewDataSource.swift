import Foundation

extension ContentViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutSchemes.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("LayoutSchemesCollectionViewItem"), for: indexPath) as? LayoutSchemesCollectionViewItem else {
            fatalError("Cannot load")
        }
        
        let layoutScheme = layoutSchemes[indexPath.item]
        
        item.load(scheme: layoutScheme)
        
        if layoutScheme.type == activeScheme.type {
            lastKnownIndexPath = indexPath
            item.select()
        }

        return item
    }
    
    
}
