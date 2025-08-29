//
//  StoreProfileRepoImplementation.swift
//  Najat
//
//  Created by rania refaat on 03/09/2024.
//

import Foundation
import Combine

struct StoreProfileRepoImplementation: StoreProfileRequestRepoProtocol {
    
    let network = StoreProfileDataSource()

    func updateProfileData(body: UpdateUserProfileBody, isSetting: Bool, data: [UploadData]) async -> RequestPublisher<UserDataModel> {
       
        if isSetting {
            let parameter: [String: Any] = ["receive_notifications": body.receive_notifications ?? 0]
            return network.updateProfileApi.makeRequest(with: parameter)
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
            if data.count == 0 {
                return network.updateProfileApi.makeRequest(with: params)
            }else{
                return network.updateProfileApi.makeRequest(with: params, uploadData: data)
            }
        }
    }
    
    func getProfileData() async -> RequestPublisher<UserDataModel> {
        return network.getProfileApi.makeRequest()

    }
    func removeFollowers(id: Int) async -> RequestPublisher<EmptyData> {
        return network.removeFollowerApi.addPathVariables(path: "/\(id)").makeRequest()

    }
    
    func acceptOrder(id: Int) async -> RequestPublisher<EmptyData> {
        return network.acceptOrderApi.addPathVariables(path: "/\(id)/accept").makeRequest()

    }
    func getOrders(_ page: Int) async -> RequestPublisher<OrdersModel> {
        return network.getOrderApi.addPathVariables(path: "?page=/\(page)").makeRequest()

    }
    func getFollowers() async -> RequestPublisher<[FollowingStoresModel]> {
        return network.getFollowers.makeRequest()
    }
    
    
}
