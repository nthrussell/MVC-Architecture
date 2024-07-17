//
//  DefaultDetailStorageServiceTEst.swift
//  MVC-Architecture
//
//  Created by russel on 16/7/24.
//

import XCTest
import CoreData

@testable import MVC_Architecture

class DetailStorageServiceTest: XCTestCase {
    var storageProvider: InMemoryStorageProvider!
    var sut: DetailStorageService!
    
    var firstData: PokemonDetailModel!
    var secondData: PokemonDetailModel!
    var thirdData: PokemonDetailModel!
    
    override func setUpWithError() throws {
        super.setUp()
        storageProvider = InMemoryStorageProvider()
        sut = DefaultDetailStorageService(storageProvider: storageProvider)
        firstData = PokemonDetailModel(
            height: 6,
            name: "bulbasaur",
            sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/1/"),
            weight: 8)
        
        secondData = PokemonDetailModel(
            height: 4,
            name: "ivysaur",
            sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/2/"),
            weight: 5)
        
        thirdData = PokemonDetailModel(
            height: 4,
            name: "venusaur",
            sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/3/"),
            weight: 5)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        firstData = nil
        secondData = nil
        thirdData = nil
        super .tearDown()
    }
    
    func test_SaveTwoDataOnDB_ShouldReturnTwoData() {
        saveData(data: firstData)
        saveData(data: secondData)

        let value: [PokemonDetail] = storageProvider.getAllData()
        XCTAssertEqual(value.count, 2)
    }
    
    func test_SaveThreeDataOnDB_DeleteOneFromDB_ShouldReturnTwoData() {
        saveData(data: firstData)
        saveData(data: secondData)
        saveData(data: thirdData)
        
        let firstValue = storageProvider.getAllData()
        XCTAssertEqual(firstValue.count, 3)
        
        deleteData(data: secondData)
        let secondValue = storageProvider.getAllData()
        XCTAssertEqual(secondValue.count, 2)
    }
    
    func test_SaveOneDataOnDB_CheckIfThatNameExists() {
        saveData(data: secondData)
        
        let value = storageProvider.getAllData()
        XCTAssertEqual(value.first?.name, "ivysaur")
    }
    
    func test_SaveOrDelete() {
        saveData(data: firstData)
        saveData(data: secondData)
        
        //Check if data is not there then save
        sut.checkIfFavourite(data: thirdData) ? deleteData(data: thirdData) : saveData(data: thirdData)
        XCTAssertTrue(sut.checkIfFavourite(data: thirdData))
        
        let firstValue = storageProvider.getAllData()
        XCTAssertEqual(firstValue.count, 3)
        
        //Check if data is there then delete
        sut.checkIfFavourite(data: firstData) ? deleteData(data: firstData) : saveData(data: firstData)
        XCTAssertFalse(sut.checkIfFavourite(data: firstData))
        
        let secondValue = storageProvider.getAllData()
        XCTAssertEqual(secondValue.count, 2)
    }
    
    private func saveData(data: PokemonDetailModel) {
        _ = data.mapToEntity(storageProvider.persistentContainer.viewContext)
        storageProvider.saveContext()
    }
    
    private func deleteData(data: PokemonDetailModel) {
        storageProvider.delete(name: data.name)
    }
}
