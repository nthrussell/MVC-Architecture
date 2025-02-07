//
//  HomeViewTest.swift
//  MVC-Architecture
//
//  Created by russel on 19/7/24.
//

import XCTest
@testable import MVC_Architecture

class HomeViewTest: XCTestCase {
    
    var sut: HomeView!
    var pokemonList: [PokemonList]!
    
    override func setUpWithError() throws {
        func fetchMoreData() { }
        func onTap(url: String) { }
        
        sut = HomeView()

        pokemonList = [
            PokemonList(name: "first", url: "first url"),
            PokemonList(name: "second", url: "second url"),
            PokemonList(name: "third", url: "third url"),
            PokemonList(name: "fourth", url: "fourth url"),
            PokemonList(name: "fifth", url: "fifth url")
        ]
        
        sut.pokemonList = pokemonList
    }
    
    override func tearDownWithError() throws {
        sut = nil
        pokemonList = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.activityindicatorView)
    }
    
    func test_tableView_whenModelHasFiveElement_shouldHaveFiveRow() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 5)
    }
    
    func test_tableView_whenModelHasData_shoulHaveACell() { 
        let indexPath = IndexPath(row: 4, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
}
