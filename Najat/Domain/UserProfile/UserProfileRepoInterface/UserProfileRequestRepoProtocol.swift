//
//  UserProfileRequestRepoProtocol.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Foundation

protocol UserProfileRequestRepoProtocol {
    func getProfileData() async -> RequestPublisher<UserDataModel>
    func getFollowings() async -> RequestPublisher<[FollowingStoresModel]>
    func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> RequestPublisher<UserDataModel>
    func logout() async -> RequestPublisher<EmptyData>
    func createStore(body: CreateStoreBody, data: [UploadData]) async -> RequestPublisher<EmptyData>
    func followStore(storeID: Int) async -> RequestPublisher<EmptyData>
    func switchAccount(accountID: Int) async -> RequestPublisher<EmptyData>
    func getDeliveryPrice() async -> RequestPublisher<[String]>
    
    func  updateProfilePhone(phone: String) async -> RequestPublisher<EmptyData>
    func  verifyProfilePhone(phone: String, code: String) async -> RequestPublisher<EmptyData>

}
