//
//  FavoriteMovieService.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import SwiftData
import Foundation
import OSLog

class FavoriteMovieService: FavoriteMovieServiceProtocol {
    
    private static let logger = Logger(
        subsystem: "luanaduarte.MovieSearch",
        category: "FavoriteMovieService"
    )
    
    private let modelContainer: ModelContainer?
    
    init(modelContainer: ModelContainer?) {
        self.modelContainer = modelContainer
    }
    
    func saveFavoriteMovie(_ movie: MovieObject, completion: @escaping (Bool) -> Void) {
        guard let modelContainer else {
            completion(false)
            Self.logger.error("ModelContainer está nulo")
            return
        }
        
        DispatchQueue.main.async {
            modelContainer.mainContext.insert(movie)
            
            do {
                try modelContainer.mainContext.save()
                completion(true)
                Self.logger.info("Filme salvo com sucesso: \(movie.originalTitle ?? "Título desconhecido", privacy: .private)")
            } catch {
                completion(false)
                Self.logger.error("Erro ao salvar o filme: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteFavoriteMovie(_ movie: MovieObject, completion: @escaping (Bool) -> Void) {
        guard let modelContainer else {
            completion(false)
            Self.logger.error("ModelContainer está nulo")
            return
        }
        
        let id = movie.id
        
        let predicate = #Predicate<MovieObject> { mv in
            mv.id == id
        }
        
        DispatchQueue.main.async {
            do {
                try modelContainer.mainContext.delete(model: MovieObject.self, where: predicate)
                completion(true)
                Self.logger.info("Filme deletado com sucesso: \(movie.originalTitle ?? "Título desconhecido", privacy: .private)")
            } catch {
                completion(false)
                Self.logger.error("Erro ao deletar o filme: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void) {
        guard let modelContainer else {
            completion(false)
            Self.logger.error("ModelContainer está nulo")
            return
        }
        
        let predicate = #Predicate<MovieObject> { movie in
            movie.id == id
        }
        
        var descriptor = FetchDescriptor<MovieObject>(predicate: predicate)
        
        descriptor.fetchLimit = 1
        
        DispatchQueue.main.async {
            do {
                let results = try modelContainer.mainContext.fetch(descriptor)
                let movieIsFavorite: Bool = !results.isEmpty
                completion(movieIsFavorite)
            } catch {
                Self.logger.error("Erro ao buscar filme por ID: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([MovieObject]?) -> Void) {
        guard let modelContainer else {
            completion(nil)
            Self.logger.error("ModelContainer está nulo")
            return
        }
        
        DispatchQueue.main.async {
            let descriptor = FetchDescriptor<MovieObject>(sortBy: [SortDescriptor(\.originalTitle)])
            completion(try? modelContainer.mainContext.fetch(descriptor))
        }
    }
}
