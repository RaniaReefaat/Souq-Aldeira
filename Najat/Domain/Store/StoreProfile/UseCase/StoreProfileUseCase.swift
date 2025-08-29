//
//  StoreProfileUseCase.swift
//  Najat
//
//  Created by rania refaat on 03/09/2024.
//

import Foundation

protocol StoreProfileUseCaseProtocol {
    mutating func getProfileData() async -> Result<UserDataModel, MyAppError>
    mutating func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> Result<BaseResponse< UserDataModel>, MyAppError>
    mutating func removeFollowers(id: Int) async -> Result<BaseResponse<EmptyData>, MyAppError>
    mutating func acceptOrder(orderID: Int) async -> Result<BaseResponse<EmptyData>, MyAppError>
    mutating func getOrders(_ page: Int) async -> Result<OrdersModel, MyAppError>
    mutating func getFollowers() async -> Result<[FollowingStoresModel], MyAppError>

}

struct StoreProfileUseCase: StoreProfileUseCaseProtocol {
    var profileRepo: StoreProfileRequestRepoProtocol
    private var bag = AppBag()
    
    init(profileRepo: StoreProfileRequestRepoProtocol = StoreProfileRepoImplementation()) {
        self.profileRepo = profileRepo
    }
    
    mutating func getProfileData() async -> Result<UserDataModel, MyAppError> {
        return await profileRepo
            .getProfileData()
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> Result<BaseResponse< UserDataModel>, MyAppError> {
        
        return await profileRepo
            .updateProfileData(body: body, isSetting: isSetting, data: data)
        .singleOutput(with: &bag)
        .resultWithMessage()
    }
    mutating func removeFollowers(id: Int) async -> Result<BaseResponse<EmptyData>, MyAppError> {
        return await profileRepo
            .removeFollowers(id: id)
        .singleOutput(with: &bag)
        .resultWithMessage()

    }
    
    mutating func acceptOrder(orderID: Int) async -> Result<BaseResponse<EmptyData>, MyAppError> {
        return await profileRepo
            .acceptOrder(id: orderID)
        .singleOutput(with: &bag)
        .resultWithMessage()

    }
    mutating func getOrders(_ page: Int) async -> Result<OrdersModel, MyAppError> {
        return await profileRepo
            .getOrders(page)
        .singleOutput(with: &bag)
        .result()
    }
    mutating func getFollowers() async -> Result<[FollowingStoresModel], MyAppError> {
        return await profileRepo
            .getFollowers()
        .singleOutput(with: &bag)
        .result()
    }

}
