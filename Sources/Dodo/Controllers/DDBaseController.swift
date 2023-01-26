//
//  DDBaseController.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit

final class DDBaseController: UIViewController {
    private let hostingController = LSPresentableHostingController(rootView: Container())
    
    override func _canShowWhileLocked() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
        hostingController.view.backgroundColor = nil
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstrains()
    }
    
    func setupConstrains() {
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}
