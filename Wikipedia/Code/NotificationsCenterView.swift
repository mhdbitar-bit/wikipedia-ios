import UIKit

final class NotificationsCenterView: SetupView {

    // MARK: - Properties

	lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: tableStyleLayout)
		collectionView.register(NotificationsCenterCell.self, forCellWithReuseIdentifier: NotificationsCenterCell.reuseIdentifier)
		collectionView.alwaysBounceVertical = true
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		// collectionView.allowsMultipleSelection = true
		return collectionView
	}()

	private lazy var tableStyleLayout: UICollectionViewLayout = {
        return tableStyleLayout(determinedHeight: nil)
	}()
    
    private var hasDeterminedCellHeight: Bool = false

    // MARK: - Setup

    override func setup() {
        backgroundColor = .white
        wmf_addSubviewWithConstraintsToEdges(collectionView)
        
    }
    
    private func tableStyleLayout(determinedHeight: CGFloat?) -> UICollectionViewLayout {
        let heightDimension: NSCollectionLayoutDimension
        if let height = determinedHeight {
            heightDimension = NSCollectionLayoutDimension.absolute(height)
        } else {
            heightDimension = NSCollectionLayoutDimension.estimated(130)
        }
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func updateCellHeightIfNeeded(viewModel: NotificationsCenterCellViewModel) {
        
        guard !hasDeterminedCellHeight else {
            return
        }
        
        let sizingCell = NotificationsCenterCell(frame: .zero)
        sizingCell.configure(viewModel: viewModel, theme: .light, indexPath: nil)
        let layoutAttributes = UICollectionViewLayoutAttributes()
        let size = sizingCell.preferredLayoutAttributesFitting(layoutAttributes).size
        
        let newLayout = tableStyleLayout(determinedHeight: size.height)
        collectionView.setCollectionViewLayout(newLayout, animated: false)
        hasDeterminedCellHeight = true
    }

}

extension NotificationsCenterView: Themeable {

    func apply(theme: Theme) {
        backgroundColor = theme.colors.paperBackground
        collectionView.backgroundColor = theme.colors.paperBackground
    }

}
