//
//  ProfileController.swift
//  Instagram
//
//  Created by Erkan Emir on 29.01.23.
//

import UIKit

class ProfileController: UIViewController {
    
    var user: User
    
    private var posts = [Post]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.delegate = self
        c.dataSource = self
        
        c.register(ProfileCell.self , forCellWithReuseIdentifier: "\(ProfileCell.self)")
        
        c.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(ProfileHeader.self)")
        
        return c
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkUserIsFollowed()
        fetchUserStatistic()
        fetchOwnerPost()
        
        PostService.fetchOnlyFollowingPosts { post in
            print(post)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOwnerPost()
     
        
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
    
    //MARK:- API
    
    func checkUserIsFollowed() {
        UserService.checIfUserIsFollowed(uid: user.uid) { isFollowing in
            self.user.isFollowing = isFollowing
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStatistic() {
        UserService.fetchUserStatistic(uid: user.uid) { userStatistic in
            self.user.userStatistic = userStatistic
            self.collectionView.reloadData()
        }
    }
    
    func fetchOwnerPost() {
        PostService.fetchOwnerUserPosts(userUid: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    //MARK:- Helper
            
    func configureUI() {
        navigationItem.title = user.username
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
}

//MARK:- UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        
        controller.post = posts[indexPath.row]
        
        navigationController?.show(controller, sender: nil)
    }
}

//MARK:- UICollectionViewDataSource

extension ProfileController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ProfileCell.self)", for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(item: posts[indexPath.row])
        return cell
    }
    
    // header onsuz'da 1 dene olur deye onun number of items fason bir methodu yoxdur.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ProfileHeader.self)", for: indexPath) as! ProfileHeader
        header.delegate = self
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
}

//MARK:- UICollectionViewDelegateFlowLayout

extension ProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 232)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 2
        return CGSize(width: width, height: width)
    }
}

//MARK:- ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    
    func didAction(user: User) {
        
        guard let tabBar = tabBarController as? TabBarController else { return }
        guard let currentUser = tabBar.user else { return }
        
        if user.isCurrentUser == true {
            print("IsCurrentUser okay")
        } else if user.isFollowing == true {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowing = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowing = true
                self.collectionView.reloadData()
                                
                NotificationService.uploadNotification(notificationOwnerUid: user.uid, fromUser: currentUser, notificationtype: .follow)

            }
        }
    }
}

