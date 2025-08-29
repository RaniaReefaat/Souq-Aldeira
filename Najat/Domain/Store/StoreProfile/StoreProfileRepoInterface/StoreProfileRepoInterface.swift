//
//  StoreProfileRepoInterface.swift
//  Najat
//
//  Created by rania refaat on 03/09/2024.
//

import Foundation

protocol StoreProfileRequestRepoProtocol {
    func getProfileData() async -> RequestPublisher<UserDataModel>
   
    func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> RequestPublisher<UserDataModel>
    func removeFollowers(id: Int) async -> RequestPublisher<EmptyData>
   
    func acceptOrder(id: Int) async -> RequestPublisher<EmptyData>
    func getOrders(_ page: Int) async -> RequestPublisher<OrdersModel>

    func getFollowers()async -> RequestPublisher<[FollowingStoresModel]>
}
