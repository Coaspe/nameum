//
//  NameumBundle.swift
//  Runner
//
//  Created by 이우람 on 2023/01/29.
//

import Foundation

extension Bundle {
    var GMSApiKey: String {
        guard let file = self.path(forResource: "nameum", ofType: "plist") else {return ""}
        
        guard let resource = NSDictionary(contentsOfFile: file) else {return ""}
        guard let key = resource["GMS_API_KEY"] as? String else {fatalError("nameum.plist에 GMS_API_KEY를 입력해주세요.")}
        return key
    }
}
