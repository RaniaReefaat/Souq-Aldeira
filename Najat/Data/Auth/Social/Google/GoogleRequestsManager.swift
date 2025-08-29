//
//  GoogleRequestsManager.swift
//  Innova
//
//  Created by Ahmed Taha on 04/01/2024.
//

import FirebaseCore
//import FirebaseAuth
//import GoogleSignIn

final class GoogleRequestsManager {
    
    func loginWithGoogleAccount(vc: UIViewController, completion: @escaping (Result<SocialUserData, MyAppError>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return completion(.failure(MyAppError.localValidation(.init(type: .defaultError, error: "something_went_wrong_validation".localized))))
        }
        
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
//            guard error == nil, let user = result?.user else {
//                return completion(.failure(NajatError.localValidation(.init(type: .defaultError, error: "something_went_wrong_validation".localized))))
//            }
//            let loginBody = SocialUserData(
//                providerName: "google",
//                providerId: user.accessToken.tokenString,
//                fullName: user.profile?.name,
//                email: user.profile?.email
//            )
//            completion(.success(loginBody))
//        }
    }
}
