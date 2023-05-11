//
//  CommentsController.swift
//  Instagram
//
//  Created by Erkan Emir on 11.04.23.
//

import UIKit

class CommentsController: UIViewController {
    
    //MARK:- Properties
        
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
 
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "\(CommentCell.self)")
        
        //surusdurerek ekranda keyboardi baglamaq ucun
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
                
        return collectionView
        
    }()
    
    private lazy var commentAccesoryView: CommentsAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        let commentView = CommentsAccesoryView(frame: frame)
        commentView.delegate = self
//        commentView.autoresizingMask = .flexibleHeight
        return commentView
    }()
    
    override var inputAccessoryView: UIView? { get { commentAccesoryView }}
    // klaviaturani ise salir
    override var canBecomeFirstResponder: Bool { true }
    
    private var post: Post
    private var comments =  [Comment]()
    
    //MARK:- Lifecycle
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been ") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchComments()
//        guard let tabBar = tabBarController as? TabBarController else  { return }
//        guard let user = tabBar.user else { return }
//        print(user.fullname)
//
//        guard let nav = tabBar.viewControllers?[4] as? UINavigationController else { return }
//        guard let profile = nav.viewControllers.first as? ProfileController else { return }
//
//        print(profile.user)
        
    }
    
    //MARK:- Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath(item: comments.count - 1 , section: 0), at: .top, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- API
    
    func fetchComments() {
        CommentService.fetchComments(postID: post.postId) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }
    

    
    func configureUI() {

        navigationItem.title = "Comments"
        navigationController?.navigationBar.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 0,paddingLeft: 0,
                              paddingBottom: 80,paddingRight: 0)
    }
}

//MARK:- UICollectionViewDataSource

extension CommentsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CommentCell.self)", for: indexPath) as! CommentCell
        cell.viewModel = CommentCellViewModel(items: comments[indexPath.row])
        cell.delegate = self
        
      
        return cell
    }
}

//MARK:- UICollectionViewDelegate

extension CommentsController: UICollectionViewDelegate { }

//MARK:- UICollectionViewDelegateFlowLayout

extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.dynamicHeightCalculator(text: comments[indexPath.row].comment, width: view.frame.width) + 32
        
        return CGSize(width: view.frame.width , height: height)
    }
}

//MARK:- CommentsAccesoryViewDelegate

extension CommentsController: CommentsAccesoryViewDelegate {
    func afterTappedPostButton(accesoryView: CommentsAccesoryView, commentText: String) {
        guard let tabBar = tabBarController as? TabBarController else  { return }
        guard let user = tabBar.user else { return }
        
        showLoader(true)
        
        CommentService.uploadComment(comments: commentText, postID: post.postId, user: user) { _ in
            accesoryView.clearComments()
            self.fetchComments()
            self.showLoader(false)
            
            NotificationService.uploadNotification(notificationOwnerUid: self.post.ownerUid, fromUser: user, notificationtype: .comment,post: self.post)
        }
    }
}

extension CommentsController: CommentCellDelegate {
    func wantsToShowProfile(cell: CommentCell) {

        guard let uid = cell.viewModel?.items.userUid else { return }
        
        showLoader(true)
        
        UserService.fetchSelectedUser(userUid: uid) { user in
            let controller = ProfileController(user: user )
            
            self.navigationController?.show(controller, sender: nil)
            
            self.showLoader(false)
        }
        
//        let controller = ProfileController(user: )
        
//        navigationController?.show(controller, sender: nil)
    }
    
    
}
