import Testing
import Foundation
@testable import PokemonSearch

struct PokemonListViewModelTests {

  @MainActor @Test func testInitialState() {
        let mockService = MockPokemonService()
        let viewModel = PokemonListViewModel(service: mockService)
        
        #expect(viewModel.pokemonList.isEmpty)
        #expect(viewModel.nextPageURL == "https://pokeapi.co/api/v2/pokemon")
        #expect(!viewModel.isLoading)
    }
    
  @MainActor @Test func testFetchPokemonSuccess() async throws {
        // Given
        let mockService = MockPokemonService()
        let viewModel = PokemonListViewModel(service: mockService)

        let expectedPokemon = Pokemon(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25")
        mockService.mockResponse = PokemonListResponse(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon/?limit=20&offset=20",
            previous: nil,
            results: [expectedPokemon]
        )
        
        // When
        await viewModel.fetchPokemon()
        
        // Then
        #expect(viewModel.pokemonList.count == 1)
        #expect(viewModel.pokemonList.first?.name == "pikachu")
        #expect(viewModel.nextPageURL == "https://pokeapi.co/api/v2/pokemon/?limit=20&offset=20")
        #expect(!viewModel.isLoading)
    }
    
  @MainActor @Test func testFetchPokemonFailure() async throws {
        // Given
        let mockService = MockPokemonService()
        let viewModel = PokemonListViewModel(service: mockService)
        mockService.shouldThrowError = true
        
        // When
        await viewModel.fetchPokemon()
        
        // Then
        #expect(viewModel.pokemonList.isEmpty)
        #expect(viewModel.nextPageURL == "https://pokeapi.co/api/v2/pokemon")
        #expect(!viewModel.isLoading)
    }
    
  @MainActor @Test func testFetchPokemonWhileLoading() async throws {
        // Given
        let mockService = MockPokemonService()
        let viewModel = PokemonListViewModel(service: mockService)
        viewModel.isLoading = true
        
        // When
        await viewModel.fetchPokemon()
        
        // Then
        #expect(viewModel.pokemonList.isEmpty)
    }
}

// MARK: - Mock Service
private class MockPokemonService: PokemonServiceProtocol {
    var mockResponse: PokemonListResponse?
    var shouldThrowError = false
    
    func fetchPokemonList(from url: String?) async throws -> PokemonListResponse {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1)
        }
        
        guard let response = mockResponse else {
            throw NSError(domain: "TestError", code: 2)
        }
        
        return response
    }
} 
