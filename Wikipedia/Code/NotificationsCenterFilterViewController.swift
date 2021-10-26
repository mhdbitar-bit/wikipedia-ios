import Foundation
import UIKit

protocol NotificationsCenterFilterViewControllerDelegate: AnyObject {
    func tappedToggleFilterButton()
}

class NotificationsCenterFilterViewController: UIViewController {
    lazy var toggleEditMilestoneFilterButton: UIButton = {
        let action = UIAction { action in
            //do stuff
        }
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(tappedToggleFilterButton), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Toggle thank-you-edit filter type", for: .normal)
        return button
    }()

    weak var delegate: NotificationsCenterFilterViewControllerDelegate?

    @objc func tappedToggleFilterButton() {
        delegate?.tappedToggleFilterButton()
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addCenteredSubview(toggleEditMilestoneFilterButton)
    }
}
