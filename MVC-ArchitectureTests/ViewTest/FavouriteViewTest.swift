//
//  FavouriteViewTEst.swift
//  MVC-Architecture
//
//  Created by russel on 27/7/24.
//

import XCTest

@testable import MVC_Architecture

class FavouriteViewTest: XCTestCase {
    var sut: FavouriteView!
    var detailData: [PokemonDetailModel]!
    
    override func setUpWithError() throws {
        sut = FavouriteView()
        
        detailData = [
            PokemonDetailModel(
                height: 5,
                name: "test1",
                sprites: SpritesModel(frontDefault: "testSprite1"),
                weight: 3),
            PokemonDetailModel(
                height: 4,
                name: "test2",
                sprites: SpritesModel(frontDefault: "testSprite2"),
                weight: 6),
            PokemonDetailModel(
                height: 7,
                name: "test3",
                sprites: SpritesModel(frontDefault: "testSprite7"),
                weight: 3)
        ]
        
        sut.detailData = detailData
    }
    
    override func tearDownWithError() throws {
        sut = nil
        detailData = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_tableView_whenDetailDataHasThreeElement_shouldHaveThreeRow() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)
    }
    
    func test_tableView_whenDetailDataHaveAnElement_shoulHaveACell() {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
}
