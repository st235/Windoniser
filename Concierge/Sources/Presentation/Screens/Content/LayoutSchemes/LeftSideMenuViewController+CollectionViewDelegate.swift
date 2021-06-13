import Foundation

extension ContentViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            fatalError()
        }
        
        if let oldPath = lastKnownIndexPath, let oldCell = collectionView.item(at: oldPath) as? LayoutSchemesCollectionViewItem {
            oldCell.deselect()
        }
        
        if let newCell = collectionView.item(at: indexPath) as? LayoutSchemesCollectionViewItem {
            newCell.select()
        }
        
        lastKnownIndexPath = indexPath
        let scheme = layoutSchemes[indexPath.item]
        
        activeScheme = scheme
    }
    
}
