//
//  TabBarController.swift
//  Instagram
//  Created by Erkan Emir on 29.01.23.

import UIKit
import Firebase
import YPImagePicker

class TabBarController: UITabBarController {
    
    var user: User? {
        didSet {
            configureViewControllers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewControllers()
        fetchUser()
    }
    
    func configureUI() {
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            }
        }
    }
    
    func fetchUser () {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func configureViewControllers() {
        tabBar.backgroundColor = .white

        self.delegate = self

        guard let user = user else { return }
                
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(viewController: FeedController(collectionViewLayout: layout), selectedImage: UIImage(named: "home_selected")!, unselectedImage: UIImage(named: "home_unselected")!)
        
        let search = templateNavigationController(viewController: SearchController(), selectedImage: UIImage(named: "search_selected")!, unselectedImage: UIImage(named: "search_unselected")!)
        
        let image = templateNavigationController(viewController: ImageSelectorController(), selectedImage: UIImage(named: "plus_unselected")!, unselectedImage: UIImage(named: "plus_unselected")!)
        
        let notification = templateNavigationController(viewController: NotificationController(), selectedImage: UIImage(named: "grid")!, unselectedImage: UIImage(named: "grid")!)

        let profile = templateNavigationController(viewController: ProfileController(user: user), selectedImage: UIImage(named: "profile_selected")!, unselectedImage: UIImage(named: "profile_unselected")!)

        viewControllers = [feed, search, image, notification , profile]
    }
    
    func templateNavigationController(viewController:UIViewController,selectedImage: UIImage ,unselectedImage: UIImage) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.image = unselectedImage
        
        return nav
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        guard let nav1 = viewControllers?[1] as? UINavigationController else { return true }
//        
//        guard let search = nav1.viewControllers.first as? SearchController else { return true }
//        search.title = "TIKLAMA GERCEKLESDI"

        
        let controllerIndex = viewControllers?.firstIndex(of: viewController)
//        print("\(String(describing: controllerIndex))")
        
        if controllerIndex == 2 {
            // Burda konfiqurasiya veririk,pickerimiz ucun.Hansi formada acilsin,nece olsun kimi
            var config =  YPImagePickerConfiguration()
            config.library.mediaType = .photo
            // shouldSaveNewPicturesToAlbum - sekilleri qaleraya kayd elesin ya yox demekdir,paylasdiginiz.
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            // maxNumberOfItems - nece dene sekil sece bilerler onu bildirir
            config.library.maxNumberOfItems = 1
            
            // ImagePicker - goruntuleri toplayan demekdir.
            let picker = YPImagePicker(configuration: config)
            present(picker, animated: true)
            
            didFinishPickingMedia(picker: picker)
        }
        return true
    }
}

extension TabBarController {
    func didFinishPickingMedia(picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            self.dismiss(animated: false) {
                // secdiyimiz tek sekile bele catiriq
                guard let image = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.selectImage = image
                controller.delegate = self
                
                controller.currentUser = self.user
    
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: false)
            }
        }
    }
}

//MARK:- UploadPostControllerDelegate

extension TabBarController: UploadPostControllerDelegate {
    
    func makeShare(controller: UIViewController) {
        controller.dismiss(animated: true)
        selectedIndex = 0
    }
    
    func refreshFeedController() {
        
        guard let nav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = nav.viewControllers.first as? FeedController else { return }
    
        feed.fetchPosts()
    }
}

//MARK:- LoginControllerDelegate

extension TabBarController: LoginControllerDelegate {
    func authenticationDidComplete() {
        fetchUser()
        dismiss(animated: true)
    }
}
