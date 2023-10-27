//
//  AuthenticationManager.swift
//  EditText
//
//.
//

import Foundation
import LocalAuthentication

/// A manager responsible for handling biometric authentication.
class AuthenicationManager:ObservableObject{
    private(set) var context = LAContext()
    @Published private(set) var biometryType:LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    @Published private(set) var isAuthenticated=false
    @Published private(set) var errorDescription:String?
    @Published var showAlert=false
    
    /// Initializes the manager and determines the type of biometry available.
    init(){
        getBiometryType()
    }

    /// Retrieves the type of biometry available on the device and updates `canEvaluatePolicy` and `biometryType`.
    func getBiometryType(){
        canEvaluatePolicy=context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        biometryType=context.biometryType
    }
    
    /// Authenticates the user using available biometrics.
    /// If successful, sets `isAuthenticated` to true.
    /// In case of failure, updates `errorDescription`, shows an alert, and resets `biometryType` to `.none`.
    func authenticateWithBiometrics() async{
        context=LAContext()
        
        if canEvaluatePolicy{

            let reason="Log into your account"
            
            do{
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                
                if success{
                    DispatchQueue.main.async {
                        self.isAuthenticated=true
                        print("isAuthenticated",self.isAuthenticated)
                    }
                }
            }catch{
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorDescription=error.localizedDescription
                    self.showAlert=true
                    self.biometryType = .none
                }
            }
       }
    }
    
    /// Logs out the user by setting `isAuthenticated` to false.
    func authenticateOut(){
        self.isAuthenticated=false
    }
    
}
