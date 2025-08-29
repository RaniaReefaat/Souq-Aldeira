//
//  UserProfileUseCase.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Foundation

protocol UserProfileUseCaseProtocol {
    mutating func getProfileData() async -> Result<UserDataModel, MyAppError>
    mutating func getFollowings() async -> Result<[FollowingStoresModel], MyAppError>
    mutating func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> Result<BaseResponse< UserDataModel>, MyAppError>
    mutating func logout() async -> Result<EmptyData, MyAppError>
    mutating func createStore(body: CreateStoreBody, data: [UploadData]) async -> Result<BaseResponse<EmptyData>, MyAppError>
    mutating func followStore(storeID: Int) async -> Result<EmptyData, MyAppError>
    mutating func switchAccount(accountID: Int) async -> Result<EmptyData, MyAppError>
    mutating func getDeliveryPrice() async -> Result<[String], MyAppError>
    mutating func updateProfilPhone(phone: String) async -> Result<EmptyData, MyAppError>
    mutating func verifyProfilPhone(phone: String, code: String) async -> Result<EmptyData, MyAppError>


}

struct UserProfileUseCase: UserProfileUseCaseProtocol {

    var profileRepo: UserProfileRequestRepoProtocol
    private var bag = AppBag()
    
    init(profileRepo: UserProfileRequestRepoProtocol = UserProfileRepoImplementation()) {
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
    
    mutating func getFollowings() async -> Result<[FollowingStoresModel], MyAppError> {
        return await profileRepo
            .getFollowings()
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
    
    mutating func logout() async -> Result<EmptyData, MyAppError> {
        return await profileRepo
            .logout()
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func createStore(body: CreateStoreBody, data: [UploadData]) async -> Result<BaseResponse<EmptyData>, MyAppError> {
        return await profileRepo
            .createStore(body: body, data: data)
            .singleOutput(with: &bag)
            .resultWithMessage()
    }
    
    mutating func followStore(storeID: Int) async -> Result<EmptyData, MyAppError> {
        return await profileRepo
            .followStore(storeID: storeID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func switchAccount(accountID: Int) async -> Result<EmptyData, MyAppError> {
        return await profileRepo
            .switchAccount(accountID: accountID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func getDeliveryPrice() async -> Result<[String], MyAppError> {
        return await profileRepo
            .getDeliveryPrice()
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func verifyProfilPhone(phone: String, code: String) async -> Result<EmptyData, MyAppError> {
        return await profileRepo
            .verifyProfilePhone(phone: phone, code: code)
            .singleOutput(with: &bag)
            .result()
    }
    
    mutating func updateProfilPhone(phone: String) async -> Result<EmptyData, MyAppError> {
        return await profileRepo
            .updateProfilePhone(phone: phone)
            .singleOutput(with: &bag)
            .result()
    }
}
