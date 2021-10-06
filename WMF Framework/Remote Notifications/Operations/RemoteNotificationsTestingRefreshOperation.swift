
import Foundation

class RemoteNotificationsTestingRefreshOperation: RemoteNotificationsRefreshOperation {
    
    override func fetchAllNotifications(project: RemoteNotificationsProject, continueId: String?, completion: @escaping (RemoteNotificationsAPIController.NotificationsResult.Query.Notifications?, Error?) -> Void) {
        apiController.getAllNotifications(from: project, continueId: continueId, fromRefresh: true, completion: completion)
    }
    
    override func shouldContinueToPage(moc: NSManagedObjectContext, lastNotification: RemoteNotificationsAPIController.NotificationsResult.Notification) -> Bool {
        
        print("🔴REFRESH OPERATION: \(self.project)")
        
        var shouldContinueToPage = true
        
        moc.performAndWait {
            
            //Is last (i.e. most recent) notification already in the database? If so, don't continue to page.
            let fetchRequest: NSFetchRequest<RemoteNotification> = RemoteNotification.fetchRequest()
            fetchRequest.fetchLimit = 1
            let predicate = NSPredicate(format: "key == %@", lastNotification.key)
            fetchRequest.predicate = predicate
            
            let result = try? moc.fetch(fetchRequest)
            if result?.first != nil {
                shouldContinueToPage = false
            }
            
            let random = Int.random(in: 1...2)
            if random == 2 {
                print("🔴REFRESH OPERATION: \(self.project) end paging")
                shouldContinueToPage = false
            } else {
                print("🔴REFRESH OPERATION: \(self.project) continue paging")
                shouldContinueToPage = true
            }
        }
        
        return shouldContinueToPage
    }
}
