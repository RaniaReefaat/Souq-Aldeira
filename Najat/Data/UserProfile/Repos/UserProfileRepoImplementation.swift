//
//  UserProfileRepoImplementation.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Foundation
import Combine

struct UserProfileRepoImplementation: UserProfileRequestRepoProtocol {
    
    let network = UserProfileDataSource()

    func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> RequestPublisher<UserDataModel> {
       
        if isSetting {
            var parameter: [String: Any] = ["receive_notifications": body.receive_notifications ?? 0]
            let userType = UserDefaults.userData?.role ?? .user
            if userType == .user {
                return network.updateProfileApi.makeRequest(with: parameter)
            }else{
                return network.updateStoreProfileApi.makeRequest(with: parameter)

            }
        }else{
            var params = [String: Any]()
            if body.lang != nil {
                params["lang"] = body.lang!
            }
            if body.phone != nil {
                params["phone"] = body.phone!
            }
            if body.whatsapp != nil {
                params["whatsapp"] = body.whatsapp!
            }
            if body.email != nil {
                params["email"] = body.email!
            }
            if body.delivery_fee != nil {
                params["delivery_fee"] = body.delivery_fee!
            }
            if body.bio != nil {
                params["bio"] = body.bio!
            }
            if body.name != nil {
                params["name"] = body.name!
            }
            if data.isEmpty {
                return network.updateProfileApi.makeRequest(with: params)
            }else{
                return network.updateProfileApi.makeRequest(with: params, uploadData: data)
            }
        }
    }
    
    func logout() async -> RequestPublisher<EmptyData> {
        return network.logoutApi.makeRequest()
    }
    
    func createStore(body: CreateStoreBody, data: [UploadData]) async -> RequestPublisher<EmptyData> {
        return network
            .createStoreApi
            .makeRequest(with: body, uploadData: data)
    }
    
    func followStore(storeID: Int) async -> RequestPublisher<EmptyData> {
        return network.followStoreApi.makeRequest(with: ["store_id": storeID])

    }
    
    func getProfileData() async -> RequestPublisher<UserDataModel> {
        return network.getProfileApi.makeRequest()

    }
    func getFollowings() async -> RequestPublisher<[FollowingStoresModel]> {
        return network.getFollowingApi.makeRequest()
    }
    func switchAccount(accountID: Int) async -> RequestPublisher<EmptyData> {
        return network.switchAccount.makeRequest(with: ["account_id": accountID])
    }
    func getDeliveryPrice() async -> RequestPublisher<[String]> {
        return network.getDeliveryPrice.makeRequest()

    }
    func updateProfilePhone(phone: String) async -> RequestPublisher<EmptyData> {
        return network.updateProfilePhoneApi.makeRequest(with: ["phone": phone])

    }
    func verifyProfilePhone(phone: String, code: String) async -> RequestPublisher<EmptyData> {
        return network.verifyProfilePhoneApi.makeRequest(with: ["phone": phone, "code": code])

    }
}
