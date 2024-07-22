//
//  HomeViewControllerTest.swift
//  MVC-Architecture
//
//  Created by russel on 19/7/24.
//

import XCTest
import Combine

@testable import MVC_Architecture

class HomeViewControllerTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    var sut: HomeViewController!
    
    override func setUpWithError() throws {
        sut = HomeViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func test_if_homeView_closure_returns_an_url() {
        var ifCalled = false
        var onTappUrl = ""
        
        func fetchMoreData() {
            ifCalled = true
        }
        
        func navigate(url: String) {
            onTappUrl = url
        }
        
        let homeView = HomeView(fetchMoreData: fetchMoreData, onTap: navigate)
        homeView.fetchMoreData()
        homeView.onTap("https://pokeapi.co/api/v2/pokemon/1/")
        
        XCTAssertTrue(ifCalled)
        XCTAssertEqual(onTappUrl, "https://pokeapi.co/api/v2/pokemon/1/")
    }
    
    func test_whenFetchDataFromHomeApi_and_returnPokemonListModel_successful() throws {
        let json = """
                   { 
                     "count":1302,
                     "next":"https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
                     "previous":null,
                     "results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},{"name":"ivysaur","url":"https://pokeapi.co/api/v2/pokemon/2/"},{"name":"venusaur","url":"https://pokeapi.co/api/v2/pokemon/3/"},{"name":"charmander","url":"https://pokeapi.co/api/v2/pokemon/4/"},{"name":"charmeleon","url":"https://pokeapi.co/api/v2/pokemon/5/"},{"name":"charizard","url":"https://pokeapi.co/api/v2/pokemon/6/"},{"name":"squirtle","url":"https://pokeapi.co/api/v2/pokemon/7/"},{"name":"wartortle","url":"https://pokeapi.co/api/v2/pokemon/8/"},{"name":"blastoise","url":"https://pokeapi.co/api/v2/pokemon/9/"},{"name":"caterpie","url":"https://pokeapi.co/api/v2/pokemon/10/"},{"name":"metapod","url":"https://pokeapi.co/api/v2/pokemon/11/"},{"name":"butterfree","url":"https://pokeapi.co/api/v2/pokemon/12/"},{"name":"weedle","url":"https://pokeapi.co/api/v2/pokemon/13/"},{"name":"kakuna","url":"https://pokeapi.co/api/v2/pokemon/14/"},{"name":"beedrill","url":"https://pokeapi.co/api/v2/pokemon/15/"},{"name":"pidgey","url":"https://pokeapi.co/api/v2/pokemon/16/"},{"name":"pidgeotto","url":"https://pokeapi.co/api/v2/pokemon/17/"},{"name":"pidgeot","url":"https://pokeapi.co/api/v2/pokemon/18/"},{"name":"rattata","url":"https://pokeapi.co/api/v2/pokemon/19/"},{"name":"raticate","url":"https://pokeapi.co/api/v2/pokemon/20/"}]
                   }
        """
        
        let data = try XCTUnwrap(json.data(using: .utf8))
        
        let pokemonDetailModel = try JSONDecoder().decode(PokemonListModel.self, from: data)
        XCTAssertEqual(pokemonDetailModel.results.count, 20)
        
        sut.homeApiService = HomeApiServiceStub(returning: .success(pokemonDetailModel))
        
        let expectation = XCTestExpectation(description: "Data decoded to PokemonListModel")

        sut.homeApiService
            .fetchPokemonList(offset: 0)
            .sink { _ in}
             receiveValue: { listModel in
                 XCTAssertEqual(listModel.results.count, 20)
                 XCTAssertEqual(listModel.results.first?.name, "bulbasaur")
                 XCTAssertEqual(listModel.results.last?.name, "raticate")

                 expectation.fulfill()
            }
             .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenHomeApiService_returnsAnError() {
        let expectedError = URLError(.cannotDecodeContentData)
        sut.homeApiService = HomeApiServiceStub(returning: .failure(expectedError))
        
        let expectation = XCTestExpectation(description: "Decoding error")
        
        sut.homeApiService
            .fetchPokemonList(offset: 20)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                XCTAssertEqual(error as? URLError, expectedError)
                expectation.fulfill()
            } receiveValue: { listModel in
                XCTFail("Expected to fail but succeeded with \(listModel)")
            }
             .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}