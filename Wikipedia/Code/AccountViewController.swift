
import UIKit

@objc(WMFAccountViewControllerDelegate)
protocol AccountViewControllerDelegate: class {
    func accountViewControllerDidTapLogout(_ accountViewController: AccountViewController)
}

private enum ItemType {
    case logout
    case talkPage
    case talkPageSignature
    case talkPageAutoSignDiscussions
}

private struct Section {
    let items: [Item]
    let headerTitle: String?
    let footerTitle: String?
}

private struct Item {
    let title: String
    let subtitle: String?
    let iconName: String?
    let iconColor: UIColor?
    let iconBackgroundColor: UIColor?
    let type: ItemType
}

@objc(WMFAccountViewController)
class AccountViewController: SubSettingsViewController {
    
    @objc var dataStore: MWKDataStore!
    @objc weak var delegate: AccountViewControllerDelegate?
    
    private lazy var sections: [Section] = {
        
        guard let username = WMFAuthenticationManager.sharedInstance.loggedInUsername else {
            assertionFailure("Should not reach this screen if user isn't logged in.")
            return []
        }
        
        let logout = Item(title: username, subtitle: CommonStrings.logoutTitle, iconName: "settings-user", iconColor: .white, iconBackgroundColor: UIColor.wmf_colorWithHex(0xFF8E2B), type: .logout)
        let talkPage = Item(title: WMFLocalizedString("account-talk-page-title", value: "Your talk page", comment: "Title for button and page letting user view their account page."), subtitle: nil, iconName: "settings-talk-page", iconColor: .white, iconBackgroundColor: UIColor(red: 51/255, green: 102/255, blue: 204/255, alpha: 1) , type: .talkPage)
        let accountSection = Section(items: [logout, talkPage], headerTitle: WMFLocalizedString("account-group-title", value: "Your Account", comment: "Title for account group on account settings screen."), footerTitle: nil)

        let signature = Item(title: "Signature", subtitle: nil, iconName: nil, iconColor: nil, iconBackgroundColor: nil, type: .talkPageSignature)
        let autoSignDiscussions = Item(title: "Auto-sign discussions", subtitle: nil, iconName: nil, iconColor: nil, iconBackgroundColor: nil, type: .talkPageAutoSignDiscussions)
        let talkPagePreferencesSection = Section(items: [signature, autoSignDiscussions], headerTitle: "Talk page preferences", footerTitle: "Auto-signing of discussions will use the signature defined in Signature settings")

        return [accountSection, talkPagePreferencesSection]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = CommonStrings.account
        tableView.register(WMFSettingsTableViewCell.wmf_classNib(), forCellReuseIdentifier: WMFSettingsTableViewCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safeIndex: section]?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WMFSettingsTableViewCell.identifier, for: indexPath) as? WMFSettingsTableViewCell,
            let item = sections[safeIndex: indexPath.section]?.items[safeIndex: indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.iconName = item.iconName
        cell.iconColor = item.iconColor
        cell.iconBackgroundColor = item.iconBackgroundColor
        cell.title = item.title
        
        switch item.type {
        case .logout:
            cell.disclosureType = .viewControllerWithDisclosureText
            cell.disclosureText = item.type == .logout ? CommonStrings.logoutTitle : nil
        case .talkPage:
            cell.disclosureType = .viewController
            cell.disclosureText = nil
        case .talkPageSignature:
            cell.disclosureType = .viewController
        case .talkPageAutoSignDiscussions:
            cell.disclosureType = .switch
            cell.disclosureSwitch.isOn = UserDefaults.wmf.autSignTalkPageDiscussions
            cell.disclosureSwitch.addTarget(self, action: #selector(autoSignTalkPageDiscussions(_:)), for: .valueChanged)
        }
        
        cell.apply(theme)
        
        return cell
    }

    @objc private func autoSignTalkPageDiscussions(_ sender: UISwitch) {
        UserDefaults.wmf.autSignTalkPageDiscussions = sender.isOn
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = sections[safeIndex: indexPath.section]?.items[safeIndex: indexPath.row] else {
            return
        }
        
        switch item.type {
        case .logout:
            showLogoutAlert()
        case .talkPage:
            
            if let username = WMFAuthenticationManager.sharedInstance.loggedInUsername,
                let language = MWKLanguageLinkController.sharedInstance().appLanguage {
                let siteURL = language.siteURL()
                let title = TalkPageType.user.titleWithCanonicalNamespacePrefix(title: username, siteURL: siteURL)
                let talkPageContainerVC = TalkPageContainerViewController(title: title, siteURL: siteURL, type: .user, dataStore: dataStore)
                talkPageContainerVC.apply(theme: theme)
                self.navigationController?.pushViewController(talkPageContainerVC, animated: true)
            }
        case .talkPageSignature:
            fallthrough
        case .talkPageAutoSignDiscussions:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = sections[safeIndex: section] else {
            return nil
        }
        
        return section.headerTitle
    }
    
    @objc func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = sections[safeIndex: section] else {
            return nil
        }
        
        return section.footerTitle
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(title: WMFLocalizedString("main-menu-account-logout-are-you-sure", value: "Are you sure you want to log out?", comment: "Header asking if user is sure they wish to log out."), message: nil, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: CommonStrings.logoutTitle, style: .destructive) { [weak self] (action) in
            guard let self = self else {
                return
            }
            self.delegate?.accountViewControllerDidTapLogout(self)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: WMFLocalizedString("main-menu-account-logout-cancel", value: "Cancel", comment: "Button text for hiding the log out menu.\n{{Identical|Cancel}}"), style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func apply(theme: Theme) {
        super.apply(theme: theme)
        view.backgroundColor = theme.colors.paperBackground
        tableView.backgroundColor = theme.colors.baseBackground
    }
}
