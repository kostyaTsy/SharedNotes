//
//  FireStoreService.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreService<T: Codable & Identifiable> {
    private let collectionPath: String
    private let db = Firestore.firestore()
    
    init(collectionPath: String) {
        self.collectionPath = collectionPath
    }
    
    func addData(data: T) {
        do {
            _ = try db.collection(collectionPath).document(data.id as! String).setData(from: data)
        } catch {
            print(error)
        }
    }
    
    func delete(data: T) {
        db.collection(collectionPath).document(data.id as! String).delete()
    }
    
    func isDocumentExist(documentId: String) async -> Bool {
        let document = try? await db.collection(collectionPath).document(documentId).getDocument()
        
        return document == nil
    }
    
    func readData(documentId: String) async -> T? {
        let document = try? await db.collection(collectionPath).document(documentId).getDocument()
        return try? document?.data(as: T.self)
    }
    
    func readFilteredData(value: String, filteredField: String) async -> [T] {
        var dataArray = [T]()
        
        let query = db.collection(collectionPath).whereField(filteredField, isEqualTo: value)
        let snapshot = try? await query.getDocuments()
        let documents = snapshot?.documents
        
        dataArray = documents?.compactMap{ documentSnapshot in
            return try? documentSnapshot.data(as: T.self)
        } ?? []
        
        return dataArray
    }
    
    func updateData(value: Any, field: String) {
    }
    
    func fetchFilteredLiveData(field: String, id: String, listener: @escaping (QuerySnapshot?, Error?) -> Void) {
        db.collection(collectionPath).whereField(field, isEqualTo: id).addSnapshotListener(listener)
    }
}
