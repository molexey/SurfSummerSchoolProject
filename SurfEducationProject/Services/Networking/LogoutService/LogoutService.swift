//
//  LogoutService.swift
//  SurfEducationProject
//
//  Created by molexey on 19.08.2022.
//

import Foundation

struct LogoutService {
    
    let dataTask = BaseNetworkTask<LogoutRequestModel, LogoutResponseModel?>(
    inNeedInjectToken: true,
    method: .post,
    path: "auth/logout"
    )
    
    let storage = FavoriteStorage.shared
    
    func performLogoutRequestAndRemoveAllData(
        _ onResponseWasReceived: @escaping (_ result: Result<LogoutResponseModel?, Error>) -> Void 
    ) {
        dataTask.performRequest(input: LogoutRequestModel()) { result in
            if case let .success(responseModel) = result {
                do {
                    try dataTask.tokenStorage.removeTokenFromContainer()
                    storage.removeDataFile()
                } catch {
                   // TODO: - Handle error if token not was received from server
                }
            }

            onResponseWasReceived(result)
        }
    }
}
