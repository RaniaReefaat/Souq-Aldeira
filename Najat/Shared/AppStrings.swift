//
//  AppStrings.swift
//  Najat
//
//  Created by rania refaat on 12/06/2024.
//

import Foundation

enum AppStrings {
    
    // new app
    case Likes
    case productDetails
    case cart
    case addItem
    case editItem
    case addresses
    case addAddress
    case orders
    case orderDetails
    case show
    case allCategories
    case FollowedStores
    case unfollow
    case productNumber
    case like
    case question
    case privacy
    case terms
    case contactUS
    case settings
    case address
    case myOrders
    case notesMessage
    case createStore
    case english
    case Arabic
    case notifications
    case feedback
    case AddToFavorites
    case removeFromFavorites
    
    case Alert
    case no
    case yes
    case deleteAccount
    case updateProfile
    case updateProfilePhone

    case remove
    case Followers
case Followed
    case categories

    var message: String {
        var message = ""
        switch self {
        case .privacy:
            message = "Privacy Policy" // "Privacy Policy" = "سياسة الخصوصية";
        case .terms:
            message = "Terms and Conditions" // "Terms and Conditions" = "الشروط والأحكام";
        case .notifications:
            message = "Notifications" // "Notifications" = "الإشعارات";
        case .orderDetails:
            message = "Order details" // "Order details" = "تفاصيل الطلب";
        case .question:
            message = "Common questions" // "common questions" = "الاسئلة الشائعة";
        case .contactUS:
            message = "Contact us" // "Contact us" = "اتصل بنا";
        case .settings:
            message = "Settings" // "Settings" = "الإعدادات";
        case .Likes:
            message = "Likes" // "Likes" = "الاعجابات";
        case .productDetails:
            message = "Product Details" // "Product Details" = "تفاصيل المنتج";
        case .cart:
            message = "Cart" // "Cart" = "السلة";
        case .addresses:
            message = "Addresses" // "Addresses" = "العناوين";
        case .addAddress:
            message = "Add a new address" // "Add a new address" = "إضافة عنوان جديد";
        case .orders:
            message = "Orders" // "Orders" = "الطلبات":
        case .show:
            message = "Show" // "Show" = "عرض";
        case .allCategories:
            message = "All Categories" // "All Categories" = "كل الأقسام";
        case .FollowedStores:
            message = "Followed Stores" // "Followed Stores" = "المتاجر المتابعة";
        case .unfollow:
            message = "unfollow" // "unfollow" = "إلغاء المتابعة";
        case .productNumber:
            message = "Number of products: " // "Number of products: " = "عدد المنتجات :";
        case .address:
            message = "Addresses" // "addresses" = "العناوين";
        case .myOrders:
            message = "My orders" // "My orders" = "طلباتي";
        case .notesMessage:
            message = "Message" // "Message" = "الرسالة";
        case .createStore:
            message = "Create a store" // "Create a store" = "إنشاء متجر";
        case .english:
            message = "English" // "English" = "اللغة الانجليزية";
        case .Arabic:
            message = "Arabic" // "Arabic" = "اللغة العربية";
        case .feedback:
            message = "Write your feedback here" // "Write your feedback here" = "اكتب تعليقك هنا";
        case .AddToFavorites:
            message = "Add to favorites" // "Add to favorites" = "إضافة الي المفضلة";
        case .removeFromFavorites:
            message = "Remove from favorites" // "remove from favorites" = "حذف من المفضله";
        case .Alert:
            message = "Alert" // "Alert" = "تنبيه";
        case .deleteAccount:
            message = "are you sure you want delete account?"  // "are you sure you want delete account?" = "هل أنت متأكد أنك تريد حذف الحساب؟";
        case .no:
            message  = "No" // "No" = "لا";
        case .yes:
            message  = "Yes" // "Yes" = "نعم";
        case .updateProfile:
            message = "Update Profile" // "Update Profile" = "تعديل الملف الشخصي";
        case .remove:
            message = "Remove" // "Remove" = "إزالة";

        case .addItem:
            message = "Add product" // "Add Product" = "إضافة المنتج";
        case .editItem:
            message = "Edit product" // "Edit Product" = "تعديل المنتج";
        case .Followers:
            message = "Followers" // "Followers" = "المتابعين";
        case .Followed:
            message = "Followed" // "Followed" = "المتابعة";

        case .like:
            message = "Like"
        case .categories:
            message = "Categories"
        case .updateProfilePhone:
            message = "Change phone number"
        }
        return message.localize
    }
}
