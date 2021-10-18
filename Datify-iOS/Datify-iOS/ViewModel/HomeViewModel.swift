//
//  HomeViewModel.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import Foundation


final class HomeViewModel: NSObject{
    
    var users: [User]
    
    func getNumberOfUsers() -> Int {
        return users.count
    }
    
//    func getCurrentUser() -> User? {
//        return users.first
//    }
    
    override init() {
        self.users = []
    }
    
    init(user: [User]) {
        self.users = user
    }
    
    func getUsersList(with handler: @escaping (_ users: [User], _ error: Error?) -> Void){
        DataFetcher.invokeUserListAPIReuest { users, error in
            if let error = error {
                handler([], error)
            } else if let users = users {
                handler(users, nil)
            }
        }
    }
    
    func getUserItemAtIndexPath(indexPath: IndexPath) -> User {
        return self.users[indexPath.row]
    }
    
}
