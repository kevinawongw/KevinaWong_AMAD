//
//  BookDataHandler.swift
//  Firebase Library
//
//  Created by Kevina Wong on 3/14/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class BookDataHandler{
    let db = Firestore.firestore()
    var bookData = [Book]()
    
    func getFirebaseData() async {
        do {
            let snapshot = try await db.collection("books").getDocuments()
            self.bookData = snapshot.documents.compactMap {document->Book? in
                return try? document.data(as: Book.self)
            }
            print(self.bookData)
        }
        catch{
            print("Error fetching document: \(error.localizedDescription)")
        }
    }
                                
    func getBooks()->[Book]{
        return bookData
    }
    
    func addBookReview(bookTitle: String, starReview: Int, bookReview: String){
        let bookCollection = db.collection("books")

        //create Dictionary

        let newBookDictionary = ["bookTitle": bookTitle, "starRating": starReview, "bookReview": bookReview ] as [String : Any]

        // Add a new document with a generated id
        var ref: DocumentReference? = nil
        ref = bookCollection.addDocument(data: newBookDictionary)
        {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    func deleteRecipe(bookID: String){
        // Delete the object from Firestore
        db.collection("books").document(bookID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}
