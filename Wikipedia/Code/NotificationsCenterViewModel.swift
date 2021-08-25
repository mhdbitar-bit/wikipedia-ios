import Foundation

@objc
final class NotificationsCenterViewModel: NSObject {

	// MARK: - Properties

	let remoteNotificationsController: RemoteNotificationsController
	let fetchedResultsController: NSFetchedResultsController<RemoteNotification>?

	// MARK: - Lifecycle

	@objc
	init(remoteNotificationsController: RemoteNotificationsController) {
		self.remoteNotificationsController = remoteNotificationsController
		self.fetchedResultsController = remoteNotificationsController.fetchedResultsController()
	}

	// MARK: - Public

	func notificationCellViewModel(indexPath: IndexPath) -> NotificationsCenterCellViewModel? {
		if let remoteNotification = fetchedResultsController?.object(at: indexPath) {
			return NotificationsCenterCellViewModel(remoteNotification: remoteNotification)
		}

		return nil
	}

}

final class NotificationsCenterCellViewModel {

	enum TempRemoteNotificationCategory {
		case thanks
		case other
	}

	let remoteNotification: RemoteNotification

	init(remoteNotification: RemoteNotification) {
		self.remoteNotification = remoteNotification
	}

	var message: String {
		return remoteNotification.messageHeader ?? "–"
	}

	var date: Date {
		return remoteNotification.date ?? Date()
	}

	var type: TempRemoteNotificationCategory {
		if (remoteNotification.categoryString ?? "").contains("thank") {
			return .thanks
		}
		return .other

		// should return remoteNotification.category
	}

}
