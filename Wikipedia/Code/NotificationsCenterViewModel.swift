import Foundation

@objc
final class NotificationsCenterViewModel: NSObject {

	// MARK: - Properties

	let remoteNotificationsController: RemoteNotificationsController

	// MARK: - Lifecycle

	@objc
	init(remoteNotificationsController: RemoteNotificationsController) {
		self.remoteNotificationsController = remoteNotificationsController
	}

	// MARK: - Public

	// Data transformations

	var fetchedResultsController: NSFetchedResultsController<RemoteNotification>? {
		return remoteNotificationsController.fetchedResultsController()
	}

}

final class NotificationsCenterCellViewModel {

	let remoteNotification: RemoteNotification

	init(remoteNotification: RemoteNotification) {
		self.remoteNotification = remoteNotification
	}

	var message: String {
		return remoteNotification.messageBody ?? ""
	}

	var time: Date {
		return remoteNotification.date ?? Date()
	}

	var type: RemoteNotificationCategory {
		return remoteNotification.category
	}

}
