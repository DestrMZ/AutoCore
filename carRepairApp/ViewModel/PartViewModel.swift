//
//  PartViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 30.10.2024.
//

import Foundation


class PartViewModel: ObservableObject {
    
    var db = CoreDataManaged.shared
    
    @Published var partName: String = ""
    @Published var article: String = ""
    @Published var forRepair: Repair? = nil
    @Published var allParts: [Part] = []
    
    func createNewPart(for repair: Repair?) {
        guard let repair = repair else { return }
        
        db.creatingPart(
            nameDetail: self.partName,
            article: self.article,
            for: repair
        )
        
        db.saveContent()
        getAllPart(for: repair)
    }
    
    func getAllPart(for repair: Repair) {
        let requstAllPart = db.fetchAllPart(for: repair)
        self.allParts = requstAllPart
        print("INFO: Все запчасти для ремонта -> \(String(describing: repair.partReplaced))")
    }
    
    func deletePart(part: Part) {
        db.deletePart(part: part)
        
        if let index = allParts.firstIndex(where: { $0.id == part.id }) { allParts.remove(at: index)
        } else {
            print("WARNING: Ошибка удаления запчасти!")
        }
    }
}
