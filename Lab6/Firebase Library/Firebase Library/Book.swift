//
//  Book.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Book: Codable, Identifiable {
    @DocumentID var id: String?
    var bookTitle: String
    var starRating: Int
    var bookReview: String
}
