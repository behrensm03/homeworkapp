//
//  MessagesViewController.swift
//  hackchallenge
//
//  Created by Eli Zhang on 5/1/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

protocol AssignmentInfo {
    func addAssignmentInfo(assignment: Assignment)
}

class MessagesViewController: UIViewController, AssignmentInfo {

    var messagesCollectionView: UICollectionView!
    let padding: CGFloat = 8
    let headerHeight: CGFloat = 30
    let reuseIdentifier = "reuse"
    
    var messages: [Message]!
    var assignmentInfo: Assignment!
    var timer: Timer!
    weak var delegate: ClassViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages - \(assignmentInfo.name)"
        
        let mainColor: UIColor = UIColor(red: 193/255, green: 94/255, blue: 178/255, alpha: 1.0)
        view.backgroundColor = .white
        self.navigationController!.navigationBar.barTintColor = mainColor
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        messagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        messagesCollectionView.backgroundColor = .white
        messagesCollectionView.dataSource = self
        messagesCollectionView.delegate = self
        messagesCollectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(messagesCollectionView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            messagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messagesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateMessages), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @objc func updateMessages() {
        NetworkManager.getMessagesFromAssignment(classId: assignmentInfo.class_id, assignmentId: assignmentInfo.id, completion: { messages in
            self.messages = messages})
        DispatchQueue.main.async {
            print(self.messages)
            // Reload table data
            self.messagesCollectionView.reloadData()
            // Scroll to bottom???
        }
    }
    
    func addAssignmentInfo(assignment: Assignment) {
        self.assignmentInfo = assignment
    }
}

extension MessagesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.configure(for: messages[indexPath.item])
        
        if let messageText = messages?[indexPath.item].message {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame =  NSString(string: messageText).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
            cell.messageTextView.frame = CGRect(x: 8+20, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.messageBubbleView.frame = CGRect(x: 0+20 , y: 0, width: estimatedFrame.width  + 16 + 8, height: estimatedFrame.height + 20)
        }
        
        return cell
    }
}

extension MessagesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = messages?[indexPath.item].message {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame =  NSString(string: messageText).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}
