//
//  FavoriteMovieService.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import SwiftData
import Foundation

class FavoriteMovieService: FavoriteMovieServiceProtocol {
    
    private let modelContainer: ModelContainer?
    
    init(modelContainer: ModelContainer?) {
        self.modelContainer = modelContainer
    }
    
    func saveFavoriteMovie(_ movie: MovieObject) {
        DispatchQueue.main.async {
            self.modelContainer?.mainContext.insert(movie)
            
            do {
                try self.modelContainer?.mainContext.save()
                print("Filme salvo com sucesso: \(movie.originalTitle ?? "")")
            } catch {
                print("Erro ao salvar o filme: \(error)")
            }
        }
    }
    
    func deleteFavoriteMovie(_ movie: MovieObject) {
        let id = movie.id
        
        let predicate = #Predicate<MovieObject> { mv in
            mv.id == id
        }
            
        DispatchQueue.main.async {
            do {
                try self.modelContainer?.mainContext.delete(model: MovieObject.self, where: predicate)
                print("Filme deletado com sucesso: \(movie.originalTitle ?? "")")
            } catch {
                print("Erro ao deletar o filme: \(error)")
            }
        }
    }
    
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void) {
        let predicate = #Predicate<MovieObject> { movie in
            movie.id == id
        }
        
        var descriptor = FetchDescriptor<MovieObject>(predicate: predicate)
        
        descriptor.fetchLimit = 1
        
        DispatchQueue.main.async {
            do {
                let results = try self.modelContainer?.mainContext.fetch(descriptor)
                let movieIsFavorite: Bool = !(results?.isEmpty ?? false)
                completion(movieIsFavorite)
                
            } catch {
                print("Erro ao buscar filme por ID: \(error)")
                completion(false)
            }
        }
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([MovieObject]?) -> Void) {
        DispatchQueue.main.async {
            let descriptor = FetchDescriptor<MovieObject>(sortBy: [SortDescriptor(\.originalTitle)])
            // TODO: VERIFICAR
            completion(try? self.modelContainer?.mainContext.fetch(descriptor))
        }
    }
}
