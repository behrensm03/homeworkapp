//
//  AddGroupViewController.swift
//  hackchallenge
//
//  Created by Michael Behrens on 5/4/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {
    
    var classForView: Class!
    var saveButton: UIBarButtonItem!
    var groupNameTextField: UITextField!
    var feedbackTextLabel: UILabel!
    
    let grayColor: UIColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
    let mainColor: UIColor = UIColor(red: 193/255, green: 94/255, blue: 178/255, alpha: 1.0)
    
    init(relatedClass: Class) {
        classForView = relatedClass
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Group - \(classForView.getTitle())"
        view.backgroundColor = .white
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.setRightBarButton(saveButton, animated: true)
        
        groupNameTextField = UITextField()
        groupNameTextField.translatesAutoresizingMaskIntoConstraints = false
        groupNameTextField.placeholder = "Enter Group Name"
        groupNameTextField.backgroundColor = grayColor
        groupNameTextField.layer.borderColor = UIColor.black.cgColor
        groupNameTextField.textColor = mainColor
        groupNameTextField.layer.cornerRadius = 3
        groupNameTextField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(groupNameTextField)
        
        feedbackTextLabel = UILabel()
        feedbackTextLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextLabel.textColor = .red
        feedbackTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        feedbackTextLabel.text = "Group name cannot be empty."
        feedbackTextLabel.isHidden = true
        view.addSubview(feedbackTextLabel)
        
        setupConstraints()

        // Do any additional setup after loading the view.
    }
    
    @objc func saveButtonTapped() {
        if let text = groupNameTextField.text {
            if (text.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                // create
                feedbackTextLabel.isHidden = true
                NetworkManager.createAssignment(classId: classForView.id, name: text, completion: { assignment in // Do anything with the assignment here
                })
                navigationController?.popViewController(animated: true)
            }
            else {
                // dont create
                feedbackTextLabel.isHidden = false
            }
        }
        else {
            // dont create
            feedbackTextLabel.isHidden = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            groupNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            groupNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            groupNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            groupNameTextField.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        NSLayoutConstraint.activate([
            feedbackTextLabel.topAnchor.constraint(equalTo: groupNameTextField.bottomAnchor, constant: 25),
            feedbackTextLabel.leadingAnchor.constraint(equalTo: groupNameTextField.leadingAnchor),
            feedbackTextLabel.trailingAnchor.constraint(equalTo: groupNameTextField.trailingAnchor),
            feedbackTextLabel.heightAnchor.constraint(equalToConstant: 35)
            ])
    }

}
