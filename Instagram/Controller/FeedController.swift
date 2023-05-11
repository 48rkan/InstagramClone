//
//  File.swift
//  Instagram
//  Created by Erkan Emir on 29.01.23.

import UIKit
import Firebase

class FeedController : UICollectionViewController {
    
    private var posts = [Post]() { didSet { collectionView.reloadData() }}
    
    // bir post ucun call etdikde controlleri
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    @objc func logOutTapped() {
        do {
            let controller = LoginController()
            controller.delegate = tabBarController as? TabBarController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav , animated: true)
            
            try Auth.auth().signOut()
            
        } catch { print("DEBUG: Error") }
    }
    
    //MARK:- API
    
    func fetchPosts() {
//        PostService.fetchPosts { post in
//            self.posts = post
//
////            self.checkPostIfLiked()
//            self.collectionView.reloadData()
//            self.collectionView.refreshControl?.endRefreshing()
//        }
        
        PostService.fetchOnlyFollowingPosts { posts in
            self.posts = posts

            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
//    func checkPostIfLiked() {
//        self.posts.forEach { post in
//
//            PostService.checkPostIfLiked(post: post) { isLiked in
//
//                guard let index = self.posts.firstIndex(where: { $0.postId == post.postId }) else { return }
//
//                self.posts[index].liked = isLiked
//                self.collectionView.reloadData()
//            }
//        }
//    }
    
    func configureUI() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(swipeRefresher), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "\(FeedCell.self)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutTapped))
        
        if post != nil { navigationItem.rightBarButtonItem?.isHidden = true }
    }
    
    @objc func swipeRefresher() { fetchPosts() }

}

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FeedCell.self)", for: indexPath) as! FeedCell
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(item: post)
            return cell
        } else {
            cell.viewModel = PostViewModel(item: posts[indexPath.row])
            return cell
        }
    }
}

extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.width + 40 + 8 + 8 + 50 + 60   )
    }
}

//MARK:- FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileWith uid: String) {
        
        UserService.fetchSelectedUser(userUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.show(controller, sender: nil)
        }
    }
    
    func wantsToLikePost(cell: FeedCell, post: inout Post) {
        post.liked.toggle()
        
        guard let tabBar = tabBarController as? TabBarController else { return }
        guard let user = tabBar.user else { return }
        
        if post.liked {
            PostService.likePost(post: post) { _ in self.fetchPosts() }
            
            NotificationService.uploadNotification(notificationOwnerUid:  post.ownerUid ,fromUser: user, notificationtype: .like,post: post)
        }
        else {
            PostService.unLikePost(post: post, completion: { _ in self.fetchPosts() })
        }
    }

    func wantsToShowComment(cell: FeedCell, post: Post) {
        let controller = CommentsController(post: post)
        navigationController?.show(controller, sender: nil)
    }
    
    func clickedLikesLabel(cell: FeedCell, post: Post) {
        let controller = UserListController(post: post)
        navigationController?.show(controller, sender: nil)
    }
}

