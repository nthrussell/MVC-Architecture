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
    var sut: DefaultDetailStorageService!
    
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
    
    func test_SaveData() {
        sut.saveData(data: firstData)
        sut.saveData(data: secondData)

        let value: [PokemonDetail] = storageProvider.getAllData()
        XCTAssertEqual(value.count, 2)
    }
    
    func test_DeleteData() {
        sut.saveData(data: firstData)
        sut.saveData(data: secondData)
        sut.saveData(data: thirdData)
        
        let firstValue = storageProvider.getAllData()
        XCTAssertEqual(firstValue.count, 3)
        
        sut.deleteData(data: secondData)
        let secondValue = storageProvider.getAllData()
        XCTAssertEqual(secondValue.count, 2)
    }
    
    func test_CheckIfFavourite() {
        sut.saveData(data: secondData)
        
        let value = storageProvider.getAllData()
        XCTAssertEqual(value.first?.name, "ivysaur")
    }
    
    func test_SaveOrDelete() {
        sut.saveData(data: firstData)
        sut.saveData(data: secondData)
        
        sut.checkIfFavourite(data: thirdData) ? sut.deleteData(data: thirdData) : sut.saveData(data: thirdData)
        XCTAssertEqual(sut.checkIfFavourite(data: thirdData), true)
    }
}
