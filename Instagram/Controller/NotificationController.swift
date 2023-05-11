//
//  NotificationController.swift
//  Instagram
//
//  Created by Erkan Emir on 29.01.23.
//

import UIKit

class NotificationController: UIViewController {
    
    //MARK:- Properties
    
    var notifications = [Notification]() {
        didSet {
            table.reloadData()
        }
    }
    
    private lazy var refresher: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(swipeUp), for: .valueChanged)
        
        return r
    }()
    
    private lazy var table: UITableView = {
        let t = UITableView()
        t.register(NotificationCell.self,
                   forCellReuseIdentifier: "\(NotificationCell.self)")
        t.rowHeight  = 80
        t.delegate   = self
        t.dataSource = self
        t.separatorStyle = .none
        t.refreshControl = refresher
        return t
    }()
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchNotifications()
    }
    
    //MARK:- Actions
    
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
//            print(notifications)
            self.checkIfUserIsFollowed()
            self.table.reloadData()
        }
    }
    
    func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow  else { return }
            
            UserService.checIfUserIsFollowed(uid: notification.uid) { isFollowed in
                
                guard let index = self.notifications.firstIndex(where: { $0.documentID  == notification.documentID }) else { return }
                
                self.notifications[index].userIsFollowed = isFollowed
            }
        }
    }
    
    //MARK:- Actions
    
    @objc private func swipeUp() {
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    private func configureUI() {
        navigationItem.title = "Notifications"
        view.backgroundColor = .white
        
        view.addSubview(table)
        table.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,
                          bottom: view.bottomAnchor,right: view.rightAnchor,
                          paddingTop: 0,paddingLeft: 0,
                          paddingBottom: 0,paddingRight: 0)
    }
}

//MARK:- UITableViewDelegate

extension NotificationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt called...")
    }
}

//MARK:- UITableViewDataSource

extension NotificationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(NotificationCell.self)") as! NotificationCell
        cell.viewModel = NotificationCellViewModel(items: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension NotificationController: NotificationCellDelegate {
    
    func cell(_ cell: NotificationCell, wantsToShowProfile uid: String) {
        showLoader(true)
        UserService.fetchSelectedUser(userUid: uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            
            self.navigationController?.show(controller, sender: nil)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.items.userIsFollowed.toggle()
            self.fetchNotifications()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnFollow uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.items.userIsFollowed.toggle()
            self.fetchNotifications()
            print("unfollow tapped")
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToShowPost postID: String) {
        showLoader(true)
        PostService.fetchSelectedPost(postID: postID) { post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            
            self.navigationController?.show(controller, sender: nil)
        }
    }
}
