//
//  File.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Combine
import Foundation

final class SearchInteractor<Strategy: SearchStrategy>: SearchBusinessLogic, SearchDataStore {
    
    var presenter: SearchPresentationLogic?
    private let worker: GenericSearchWorker<Strategy>
    
    private var textSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var currentItems: [Strategy.ModelType] = []
    
    init(worker: GenericSearchWorker<Strategy>) {
        self.worker = worker
        setupBindings()
    }
    
    private func setupBindings() {
        textSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                self.worker.search(query: query)
                    .sink { [weak self] items in
                        guard let self = self else { return }
                        self.currentItems = items
                        
                        let response = Search.TextDidChange.Response(items: items)
                        self.presenter?.presentTextDidChange(response: response)
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Business Logic
    func textDidChange(request: Search.TextDidChange.Request) {
        textSubject.send(request.query)
    }
}
