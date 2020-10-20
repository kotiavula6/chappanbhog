//
//  AsHelper.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 25/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import Foundation
import AuthenticationServices


protocol LoginDelegate: class {
    func authorizationDidCompleteWith(data: [String: Any?])
    func didCompleteWithError(error: Error?)
    
    //Add facebook and other logins
}

@available(iOS 13.0, *)
//User credential states
enum credentialState {
    case authorized
    case revoked
    case notFound
}


@available(iOS 13.0, *)
final class ASHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared: ASHelper = ASHelper()
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    var userCredentialState: credentialState?
    
    //call back delgate to call functions
    var delegate: LoginDelegate?
    
    private override init() {}
    
    //MARK:- Check user state
    func getUserState() -> credentialState {
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier ?? "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // User is authorized and previously signed in
                self.userCredentialState = .authorized
                print("authorized")
                break
            case .revoked:
                // The Apple ID credential is revoked
                self.userCredentialState = .revoked
            case .notFound:
                // The Apple ID credential not found
                self.userCredentialState = .notFound
                break
            default:
                break
            }
        }
        return userCredentialState!
    }
    
    ///Creates and returns the request to authenticate the user
    func getRequest() -> ASAuthorizationRequest {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        return request
    }
    
    ///Creates controller, Passes the request in it
    ///Provide self to the controller and presentation context delegate here
    ///shows the UI of default sign in with apple with performRequests
    func performRequest() {
        let controller = ASAuthorizationController(authorizationRequests: [getRequest()])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    //MARK:-  Controller delegate functions
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("ERROR:- ",error.localizedDescription)
        delegate?.didCompleteWithError(error: error)
    }
    
    ///Calls when user gets the successful authorization
    ///
    ///Saving the user information in keychain
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            print("NAME:- ", appleIDCredential.fullName ?? "N/A")
            print("EMAIL:- ", appleIDCredential.email ?? "N/A")
            
            // Create an account in your system.
            //store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            
//            if let name = appleIDCredential.fullName {
//                //First time user
//                UserDefaults.standard.setValue(appleIDCredential.fullName, forKey: appleIDCredential.user)
//            } else {
//                //Already a user
//                print(UserDefaults.standard.value(forKey: appleIDCredential.user))
//            }
                
            KeychainItem.currentUserEmail = appleIDCredential.email
            
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
             
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
                
                let data = [
                    "name": KeychainItem.currentUserFirstName ?? "N/A", //+ KeychainItem.currentUserLastName ?? "nil",
                    "email": appleIDCredential.email ?? "N/A",
                    "status": appleIDCredential.realUserStatus.rawValue ,
                    "userID": KeychainItem.currentUserIdentifier ?? "N/A",
                    "tokenID": identityTokenData
                ] as [String : Any]
                
                print(data)
                delegate?.authorizationDidCompleteWith(data: data)
            }
      
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print(username, password)
        }
    }
    
    //MARK:- Presentation Context Providing
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate?.window!)!
    }
}


/*
 if KeychainItem.currentUserFirstName != nil {
     KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
     KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
 }
 */

