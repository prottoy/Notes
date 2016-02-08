//
//  Notes.swift
//  Notes
//
//  Created by Mahbub Morshed on 1/7/16.
//  Copyright © 2016 Mahbub Morshed. All rights reserved.
//

import Foundation

class Note {
    let id: String
    let title: String
    let description: String
    
    
    init(id:String, title:String, description:String){
        self.id = id
        self.title = title
        self.description = description
    }
}