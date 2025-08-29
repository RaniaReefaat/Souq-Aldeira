//
//  TabBarViewController.swift
//  App
//
//  Created by Ahmed Taha on 19/11/2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setTabBarDesign()
    }
    
    private func setupTabBar() {
        
        let homeVC = AppNavigationController(rootViewController: HomeViewController())
        homeVC.delegate = self
        homeVC.withTabBarItem(image: .home1.original , selectedImage: .home2.original)
        
        let favoriteVC = AppNavigationController(rootViewController: FavoriteFoldersListViewController())
        favoriteVC.delegate = self
        favoriteVC.withTabBarItem(image: .love1.original, selectedImage: .love2.original)
        
        let addVC = AppNavigationController(rootViewController: AddItemViewController())
        addVC.delegate = self
        addVC.withTabBarItem(image: .tabAdd.original, selectedImage: .tabAdd.original)
        
        let cartVC = AppNavigationController(rootViewController: CartListViewController())
        cartVC.delegate = self
        cartVC.withTabBarItem(image: .cart1.original , selectedImage: .cart2.original)
        
        let userProfileVC = AppNavigationController(rootViewController: UserMainProfileViewController())
        userProfileVC.delegate = self

        let storeProfileVC = AppNavigationController(rootViewController: StoreMainProfileViewController())
        storeProfileVC.delegate = self

        let imageUrlString = UserDefaults.userData?.image ?? ""
        var originalImage = UIImage(named: "NRedLogo")!

        if let url = URL(string: imageUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                loadImage(from: url) { [weak self] image in
                    DispatchQueue.main.async {
                        guard let image = image else{return}
//                        originalImage = image
                        self?.updateTabBarImage(with: image.circularImage())
                    }
                }
        }else{
            let desiredSize = CGSize(width: 30, height: 30)  // Adjust the size as needed
            
            // Resize the image
            let resizedImage = originalImage.resized(to: desiredSize)
            storeProfileVC.withTabBarItem(image: resizedImage , selectedImage: resizedImage)
            userProfileVC.withTabBarItem(image: resizedImage , selectedImage: resizedImage)


        }
        
        // Desired size for the tab bar icon
        
        // Create a tab bar item with the resized image
        
        let userType = UserDefaults.userData?.role ?? .user
        if userType == .store {
            viewControllers = [ homeVC, favoriteVC , addVC , cartVC , storeProfileVC]

        }else{
            viewControllers = [ homeVC, favoriteVC , cartVC , userProfileVC]
        }
    }
    private func updateTabBarImage(with image: UIImage?) {
        // Assuming you want to set the image for the first tab bar item
        if let items = self.tabBar.items, let image = image {
            guard   let firstItem = items.last else{return}
            let desiredSize = CGSize(width: 30, height: 30)  // Adjust the size as needed
            
            // Resize the image
            let resizedImage = image.resized(to: desiredSize)

            firstItem.image = resizedImage.withRenderingMode(.alwaysOriginal)
        }
    }
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            }.resume()
        }
    private func setTabBarDesign(){
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
    }
}
extension TabBarViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let tabBarViews = [HomeViewController.self, CartListViewController.self, CategoryViewController.self, SubCategoryViewController.self, ProductsViewController.self, ProductDetailsViewController.self, UserMainProfileViewController.self, StoreMainProfileViewController.self,AddItemViewController.self, FavoriteFoldersListViewController.self]
        tabBar.isHidden = !tabBarViews.contains(where: {viewController.isKind(of: $0)})
    }
}
private extension UIViewController {
    func withTabBarItem(image: UIImage?, name: String? = nil, selectedImage: UIImage? = nil) -> UIViewController {
        tabBarItem = UITabBarItem(title: name, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        title = nil
        
        return self
    }
}
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        // Create a new context with the desired size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // Draw the original image into the context, resizing it to fit
        self.draw(in: CGRect(origin: .zero, size: size))
        // Get the resized image from the context
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        // Clean up the context
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
extension UIImage {
    func circularImage() -> UIImage? {
        let size = min(self.size.width, self.size.height)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        // Create a circular path
        let path = UIBezierPath(ovalIn: rect)
        context?.addPath(path.cgPath)
        context?.clip()

        // Draw the image
        self.draw(in: rect)
        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return circularImage
    }
}
