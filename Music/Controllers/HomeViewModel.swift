//
//  HomeViewModel.swift
//  Music
//
//  Created by Christopher Samso on 11/28/22.
//

import UIKit

    class ViewModel {
        private var results: [Release] = []
        
        var coverSize: CGSize = CGSize(width: 100, height: 100)

        var onResultsReceived: (() -> Void)?
        
        var onError: ((String) -> Void)?
        
        // MARK: Actions
        
        func fetchResults(withQuery query: String) {
            API.Client.shared.get(.search(query: query)) { (result: Result<API.Types.Responses.ArtistSearch, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        self.parseResults(success)
                    case .failure(let failure):
                        self.onError?(failure.localizedDescription)
                    }
                }
            }
            print("Search not implemented yet")
        }
        
        func wipeResults() {
            DispatchQueue.main.async {
                self.results = []
                self.onResultsReceived?()
            }
        }
        
        // MARK: Private
        
        private func parseResults(_ results: API.Types.Responses.ArtistSearch) {
            var localResults = [Release]()
            
            for result in results.results {
                let localResult = Release(id: result.trackId, imageUrl: convertCoverUrl(result.artworkUrl100), title: result.trackName, artistId: result.artistId)
                localResults.append(localResult)
            }
            self.results = localResults
            onResultsReceived?()
        }
        
        private func convertCoverUrl(_ fromString: String) -> URL {
            return URL(string: fromString.replacingOccurrences(of: "100x100", with: "\(Int(coverSize.width))x\(Int(coverSize.height))"))!
        }
        
        func handleReleaseSelection(at indexPath: IndexPath) {
            guard indexPath.row >= 0 && indexPath.row < results.count else {
                return
            }
            print("Selection not implemented yet")
        }
        
        // MARK: Data source
        
        func coverURL(for indexPath: IndexPath) -> URL? {
            guard indexPath.row >= 0 && indexPath.row < results.count else {
                return nil
            }
            return results[indexPath.row].imageUrl
        }
        
        func coverTitle(for indexPath: IndexPath) -> String? {
            guard indexPath.row >= 0 && indexPath.row < results.count else {
                return nil
            }
            return results[indexPath.row].title
        }
        
        func numberOfResults() -> Int {
            return results.count
        }
    }

extension ViewModel {
    struct Release {
        var id: Int
        var imageUrl: URL
        var title: String
        var artistId: Int
    }
}
