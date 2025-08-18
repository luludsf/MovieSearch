//
//  UIStrings.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import Foundation

enum UIStrings {
    
    enum Search {
        static let placeholder = "Digite o nome do filme que está buscando..."
        static let button = "Buscar"
        static let title = "Busca"
    }
    
    enum Navigation {
        static let search = "Busca"
        static let favorites = "Favoritos"
        static let details = "Detalhes"
    }
    
    enum Movie {
        static let original = "Original: %@"
        static let rating = "★ %.1f"
        static let release = "Lançamento: %@"
        static let budget = "Custo: %@"
        static let revenue = "Arrecadação: %@"
        static let overview = "Sinopse"
    }
    
    enum States {
        static let loading = "Carregando..."
        static let emptyFavorites = "Não há filmes favoritos salvos"
        static let noSearchResults = "Nenhum filme foi encontrado pela sua pesquisa"
        static let errorLoadingFavorites = "Erro ao trazer favoritos"
    }
    
    enum Common {
        static let na = "N/A"
        static let usd = "USD"
        static let dollarSymbol = "$"
    }
    
    enum Icons {
        static let heart = "heart"
        static let heartFilled = "suit.heart.fill"
        static let movieClapper = "movieclapper"
        static let magnifyingGlass = "magnifyingglass.circle"
        static let star = "star.circle"
    }
    
    enum Identifiers {
        static let movieCell = "MovieCell"
    }
}
