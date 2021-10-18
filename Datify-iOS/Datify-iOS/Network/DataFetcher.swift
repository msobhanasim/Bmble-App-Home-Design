//
//  DataFetcher.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import Foundation

class DataFetcher {
    //MARK: Variables
    
    //MARK: User List API Request
    static func invokeUserListAPIReuest(with handler: @escaping (_ categories: [User]?, _ error: Error?) -> Void) {
        
        let userData : [User] = [
            User(userId: 1, userFirstName: "Alex", userLastName: "Jason", profileImage: #imageLiteral(resourceName: "andrew")),
            User(userId: 3, userFirstName: "Juni", userLastName: "Marcus", profileImage: #imageLiteral(resourceName: "rachel")),
            User(userId: 4, userFirstName: "Koti", userLastName: "Ella", profileImage: #imageLiteral(resourceName: "girl")),
            User(userId: 2, userFirstName: "Jason", userLastName: "Sathom", profileImage: #imageLiteral(resourceName: "joshua")),
            User(userId: 5, userFirstName: "Sofi", userLastName: "Jugan", profileImage: #imageLiteral(resourceName: "bailey")),
            User(userId: 6, userFirstName: "Sofia", userLastName: "Ada", profileImage: #imageLiteral(resourceName: "daiane"))
        ]
        
        handler(userData, nil)
    }
    
}
