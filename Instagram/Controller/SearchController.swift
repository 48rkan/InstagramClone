//
//  SearchController.swift
//  Instagram
//
//  Created by Erkan Emir on 29.01.23.
//

import UIKit

class SearchController : UIViewController {
    
    var users = [User]()
    
    var filteredUsers = [User]()
    
    var tableView =  UITableView()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 0,paddingLeft: 0,paddingBottom: 0,paddingRight: 0)
        tableView.register(SearchCell.self, forCellReuseIdentifier: "\(SearchCell.self)")
        tableView.rowHeight = 56
        
        fetchAllUsers()
        configureSearchController()
        configureCustomizeNavigationController()
    }
    
    func fetchAllUsers() {
        UserService.fetchAllUsers { users in
            self.users = users
            print(users)
            self.tableView.reloadData()
        }
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        // obscuresBackgroundDuringPresentation - search Controller presentation vaxti arxa fonu gizletsinmi
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = false
        
        searchController.searchResultsUpdater = self
    }
    
    func configureCustomizeNavigationController() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}

extension SearchController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchCell.self)", for: indexPath) as! SearchCell
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = SearchViewModel(users: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("DEBUG: \(users[indexPath.row].username)")
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.show(controller, sender: nil)
    }
}

//MARK:- UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter { user in
            user.username.contains(searchText) || user.fullname.lowercased().contains(searchText)
        }
//        print(filteredUsers)
        tableView.reloadData()
    }
}

