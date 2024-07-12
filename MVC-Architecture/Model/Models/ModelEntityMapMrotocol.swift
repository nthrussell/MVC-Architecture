//
//  ModelEntityMapMrotocol.swift
//  MVC-Architecture
//
//  Created by russel on 12/7/24.
//

import Foundation
import CoreData

protocol ModelEntityMapProtocol {
    associatedtype EntityType: NSManagedObject

    func mapToEntity(_ context: NSManagedObjectContext) -> EntityType
    static func mapFromEntity(_ entity: EntityType) -> Self
}