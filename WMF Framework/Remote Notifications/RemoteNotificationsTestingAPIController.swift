
import Foundation

class RemoteNotificationsTestingAPIController: RemoteNotificationsAPIController {
    override func getAllNotifications(from project: RemoteNotificationsProject, continueId: String?, completion: @escaping (RemoteNotificationsAPIController.NotificationsResult.Query.Notifications?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            //simulate time it takes to return from network
            sleep(UInt32(Int.random(in: 0...2)))
            let randomTotal = Int.random(in: 0...50)
            print("🔵API CONTROLLER: \(project) - random total: \(randomTotal)")
            let continueID = Int.random(in: 1...10) == 1 ? nil : "asdf"
            if continueID == "asdf" {
                print("🔵API CONTROLLER: \(project) - continue paging")
            } else {
                print("🔵API CONTROLLER: \(project) - end paging")
            }
            
            let notifications = RemoteNotificationsAPIController.NotificationsResult.Query.Notifications(list: self.randomlyGenerateNotifications(totalCount: randomTotal, project: project), continueId: continueID)
            completion(notifications, nil)
        }
    }
    
    private func randomlyGenerateNotifications(totalCount: Int, project: RemoteNotificationsProject) -> [RemoteNotificationsAPIController.NotificationsResult.Notification] {
        var result: [RemoteNotificationsAPIController.NotificationsResult.Notification] = []
        var loopNumber = 0
        while loopNumber < totalCount {
            let randomNotification = RemoteNotificationsAPIController.NotificationsResult.Notification.random(project: project)
            result.append(randomNotification)
            loopNumber = loopNumber + 1
        }
        
        return result
    }
}

fileprivate extension RemoteNotificationsAPIController.NotificationsResult.Notification {
    static func random(project: RemoteNotificationsProject) -> RemoteNotificationsAPIController.NotificationsResult.Notification {
        return RemoteNotificationsAPIController.NotificationsResult.Notification(testing: true, project: project)
    }
    
    init(testing: Bool, project: RemoteNotificationsProject) {
        
        
        let randomCategoryAndTypeIDs: [(String, String)] = [
            ("edit-user-talk", "edit-user-talk"),
            ("mention", "mention"),
            ("mention", "mention-summary"),
            ("mention-success", "mention-success"),
            ("mention-failure", "mention-failure"),
            ("mention-failure", "mention-failure-too-many"),
            ("reverted", "reverted"),
            ("user-rights", "user-rights"),
            ("page-review", "pagetriage-mark-as-reviewed"),
            ("article-linked", "page-linked"),
            ("wikibase-action", "page-connection"),
            ("emailuser", "emailuser"),
            ("edit-thank", "edit-thank"),
            ("cx", "cx-first-translation"),
            ("cx", "cx-tenth-translation"),
            ("thank-you-edit", "thank-you-edit"),
            ("system-noemail", "welcome"),
            ("login-fail", "login-fail-new"),
            ("login-fail", "login-fail-known"),
            ("login-success", "login-success"),
            ("system", "anything1"),
            ("system-noemail", "anything2"),
            ("system-emailonly", "anything3"),
            ("anything4", "anything5")
        ]
        
        let section = ["message", "alert"]
        
        self.wiki = project.notificationsApiWikiIdentifier
        let identifier = UUID().uuidString
        self.id = identifier
        self.section = section.randomElement()!
        
        let randomCategoryAndType = randomCategoryAndTypeIDs.randomElement()!
        self.category = randomCategoryAndType.0
        self.type = randomCategoryAndType.1
        
        let timestamp = Timestamp(testing: true)
        self.timestamp = timestamp
        self.title = Title(testing: true, randomCategoryAndType: randomCategoryAndType)
        self.agent = Agent(testing: true, randomCategoryAndType: randomCategoryAndType, project: project)
        
        let isRead = Bool.random()
        self.readString = isRead ? "isRead" : nil
       
        self.message = Message(testing: true, identifier: identifier)
    }
}

fileprivate extension RemoteNotificationsAPIController.NotificationsResult.Notification.Timestamp {
    init(testing: Bool) {
        let today = Date()
        let day = TimeInterval(60 * 60 * 24)
        let year = day * 365
        let twentyYearsAgo = Date(timeIntervalSinceNow: year * 20)
        let randomTimeInterval = TimeInterval.random(in: today.timeIntervalSinceNow...twentyYearsAgo.timeIntervalSinceNow)
        let randomDate = Date(timeIntervalSinceNow: -randomTimeInterval)
        let dateString8601 = DateFormatter.wmf_iso8601().string(from: randomDate)
        let unixTimeInterval = randomDate.timeIntervalSince1970
        self.utciso8601 = dateString8601
        self.utcunix = String(unixTimeInterval)
    }
}

fileprivate extension RemoteNotificationsAPIController.NotificationsResult.Notification.Title {
    init(testing: Bool, randomCategoryAndType: (String, String)) {
        
        switch randomCategoryAndType {
        case ("edit-user-talk", "edit-user-talk"):
            self.full = "User talk:Tsevener"
            self.namespace = "User_talk"
            self.namespaceKey = 3
            self.text = "Tsevener"
            return
        default:
            let random = Int.random(in: 1...2)
            switch random {
            case 1:
                self.full = "Cat"
                self.namespace = ""
                self.namespaceKey = 0
                self.text = "Cat"
            default:
                self.full = "Talk: Dog"
                self.namespace = "Talk"
                self.namespaceKey = 1
                self.text = "Dog"
            }
        }
    }
}

fileprivate extension RemoteNotificationsAPIController.NotificationsResult.Notification.Agent {
    init(testing: Bool, randomCategoryAndType: (String, String), project: RemoteNotificationsProject) {
        
        switch project {
        case .commons:
            switch randomCategoryAndType {
            case (("edit-user-talk", "edit-user-talk")):
                self.id = String(302461)
                self.name = "Wikimedia Commons Welcome"
                return
            default:
                break
            }
        default:
            break
        }
        
        let random = Int.random(in: 1...2)
        if random == 1 {
            self.id = String(0)
            self.name = "47.184.10.84"
            return
        }
        
        self.id = String(42540)
        self.name = "TSevener (WMF)"
    }
}

fileprivate extension RemoteNotificationsAPIController.NotificationsResult.Notification.Message {
    init(testing: Bool, identifier: String) {
        self.header = "Test header text for identifier: \(identifier)"
        self.body = "Test body text for identifier: \(identifier)"
        let primaryLink = RemoteNotificationLink(type: nil, url: URL(string:"https://en.wikipedia.org/wiki/Cat")!, label: "Label for primary link")
        self.links = RemoteNotificationLinks(primary: primaryLink, secondary: nil)
    }
}
