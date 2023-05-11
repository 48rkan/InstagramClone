//
//  UserListController.swift
//  Instagram
//
//  Created by Erkan Emir on 24.04.23.
//

import UIKit

class UserListController: UIViewController {
    
    //MARK:- Properties
    
    private lazy var table: UITableView = {
    
        let table = UITableView()
        table.delegate   = self
        table.dataSource = self
        table.register(SearchCell.self, forCellReuseIdentifier: "\(SearchCell.self)")
        table.rowHeight = 56
        return table
    }()
    
    var post: Post
    
    var users = [User]()

    init(post: Post) {
        self.post = post
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkWhoIsLiked()
    }
    
    //MARK:- API
    
    func checkWhoIsLiked() {
        PostService.checkWhoIsLiked(post: post) { users in
            print(users)
            self.users = users
            self.table.reloadData()
        }
    }
    
    
    //MARK:- Action
    
    func configureUI() {
        view.addSubview(table)
        table.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 0,paddingLeft: 0,paddingBottom: 0,paddingRight: 0)
    }
}

extension UserListController: UITableViewDelegate { }

extension UserListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "\(SearchCell.self)") as! SearchCell
        cell.viewModel = SearchViewModel(users: users[indexPath.row])
        return cell
    }
    
    
}
