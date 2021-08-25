import UIKit

final class NotificationsCenterView: SetupView {

	// MARK: - Properties

	lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: tableStyleLayout())
		collectionView.register(NoticeCollectionViewCell.self, forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier)
		collectionView.alwaysBounceVertical = true
		collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

	// MARK: - Setup

	override func setup() {
		backgroundColor = .white
		addSubview(collectionView)

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
		])
	}

	func configure(viewModel: NotificationsCenterViewModel) {

	}

	private func tableStyleLayout() -> UICollectionViewLayout {
		if #available(iOS 13.0, *) {
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(70))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
			let section = NSCollectionLayoutSection(group: group)
			let layout = UICollectionViewCompositionalLayout(section: section)
			return layout
		} else {
			fatalError()
		}
	}

}

extension NotificationsCenterView: Themeable {

	func apply(theme: Theme) {
		backgroundColor = theme.colors.paperBackground
		collectionView.backgroundColor = theme.colors.paperBackground
	}

}

final class NoticeCollectionViewCell: UICollectionViewCell, Themeable {

	lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = ""
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		label.numberOfLines = 0
		return label
	}()

	lazy var imageView: UIImageView = {
		let userSmile = UIImage(named: "user-talk")?.withRenderingMode(.alwaysTemplate)
		let imageView = UIImageView(image: userSmile)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	lazy var projectLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "EN"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
		label.layer.cornerRadius = 5
		label.layer.borderWidth = 1
		label.layer.borderColor = UIColor.black.cgColor
		return label
	}()

	lazy var imageContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.masksToBounds = true
		return view
	}()

	static let reuseIdentifier = String(describing: NoticeCollectionViewCell.self)

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		imageContainer.layer.cornerRadius = imageContainer.bounds.width / 2
	}

	func setup() {
		imageContainer.addSubview(imageView)

		contentView.addSubview(imageContainer)
		contentView.addSubview(messageLabel)
		contentView.addSubview(projectLabel)

		NSLayoutConstraint.activate([
			imageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			imageContainer.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			imageContainer.heightAnchor.constraint(equalToConstant: 40),
			imageContainer.widthAnchor.constraint(equalToConstant: 40),

			imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 1),
			imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, constant: -20),
			imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, constant: -20),

			messageLabel.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 20),
			messageLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
			messageLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
			messageLabel.trailingAnchor.constraint(equalTo: projectLabel.leadingAnchor),

			projectLabel.widthAnchor.constraint(equalToConstant: 22),
			projectLabel.heightAnchor.constraint(equalToConstant: 22),
			projectLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			projectLabel.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
			projectLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20)
		])

		imageContainer.setNeedsLayout()
		layoutIfNeeded()
	}

	// MARK: - Configure

	func configure(viewModel: NotificationsCenterCellViewModel) {
		let dateString = (viewModel.date as NSDate).wmf_localizedRelativeDateFromMidnightUTCDate()
		messageLabel.text = viewModel.message.removingHTML + " " + dateString
	}

	// MARK: - Themeable

	func apply(theme: Theme) {
		imageContainer.backgroundColor = theme.colors.link
		imageView.tintColor = theme.colors.paperBackground
		projectLabel.textColor = theme.colors.secondaryText
		projectLabel.layer.borderColor = theme.colors.secondaryText.cgColor
		messageLabel.textColor = theme.colors.primaryText
	}

}
