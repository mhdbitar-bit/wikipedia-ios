import Foundation

class RemoteNotificationsMarkAllAsSeenOperation: RemoteNotificationsOperation {
    
    override func execute() {
        
        let backgroundContext = modelController.newBackgroundContext()
        
        self.modelController.markAllAsSeen(moc: backgroundContext, project: project) { [weak self] in 
            guard let self = self else {
                return
            }
            
            // TODO: maybe here is the place to filter the wiki???
            
            self.apiController.markAllAsSeen(project: self.project) { [weak self] error in
                guard let self = self else {
                    return
                }
                if let error = error {
                    self.finish(with: error)
                    return
                }
                self.finish()
            }
        }
    }
}
