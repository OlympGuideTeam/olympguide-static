//
//  FavoriteProgramsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit
import Combine

final class FavoriteProgramsViewController: UIViewController {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    var interactor: (FavoriteProgramsBusinessLogic & FavoriteProgramsDataStore)?
    var router: FavoriteProgramsRoutingLogic?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var programs: [ProgramsByUniversityViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        
        interactor?.loadPrograms(with: .init())
    }
    
    private func configureUI() {
        configureNavigationBar()
        configureRefreshControl()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        let backItem = UIBarButtonItem(title: "Избранные", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        navigationItem.title = "Избранные программы"
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
        
        tableView.register(
            UIUniversityHeader.self,
            forHeaderFooterViewReuseIdentifier: UIUniversityHeader.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
    }
    
    func getEmptyLabel() -> UILabel? {
        guard programs.isEmpty else { return nil }
        
        let emptyLabel = UILabel(frame: self.tableView.bounds)
        emptyLabel.text = "Избранных программ пока нет"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .black
        emptyLabel.font = FontManager.shared.font(for: .emptyTableLabel)
        self.tableView.backgroundView = emptyLabel
        
        return emptyLabel
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.interactor?.loadPrograms(with: FavoritePrograms.Load.Request())
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteProgramsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return programs.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        programs[section].isExpanded ? programs[section].programs.count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier
        ) as? ProgramTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: programs[indexPath.section].programs[indexPath.row])
        
        cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
            if !isFavorite {
                self?.favoritesManager.removeProgramFromFavorites(programID: sender.tag)
            }
        }
        
        cell.hideSeparator(indexPath.row == programs[indexPath.section].programs.count - 1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteProgramsViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToProgram(indexPath: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: UIUniversityHeader.identifier
        ) as? UIUniversityHeader
        else { return nil }
        
        header.configure(
            with: programs[section].university,
            isExpanded: programs[section].isExpanded
        )
        header.toggleSection = { [weak self] section in
            guard let self = self else { return }
            var currentOffset = tableView.contentOffset
            let headerRectBefore = tableView.rectForHeader(inSection: section)
            
            programs[section].isExpanded.toggle()
            
            UIView.performWithoutAnimation {
                tableView.reloadSections(IndexSet(integer: section), with: .none)
                tableView.layoutIfNeeded()
            }
            let headerRectAfter = tableView.rectForHeader(inSection: section)
            
            let deltaY = headerRectAfter.origin.y - headerRectBefore.origin.y
            currentOffset.y += deltaY
            tableView.setContentOffset(currentOffset, animated: false)
        }
        return header
    }
}

// MARK: - FavoriteProgramsDisplayLogic
extension FavoriteProgramsViewController : FavoriteProgramsDisplayLogic {
    func displayLoadProgramsResult(with viewModel: FavoritePrograms.Load.ViewModel) {
        
        programs = viewModel.programs
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.backgroundView = getEmptyLabel()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Combine
extension FavoriteProgramsViewController {
    func setupBindings() {
        favoritesManager.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let univer, let program):
                    self.interactor?.likeProgram(univer, program)
                case .removed(let programID):
                    if let index = self.findIndexPath(programID: programID) {
                        tableView.beginUpdates()
                        self.programs[index.section].programs.remove(at: index.row)
                        self.interactor?.dislikeProgram(at: index)
                        self.tableView.deleteRows(at: [index], with: .automatic)
                        if self.programs[index.section].programs.isEmpty {
                            self.programs.remove(at: index.section)
                            
                            self.tableView.deleteSections(IndexSet(integer: index.section), with: .automatic)
                        }
                        tableView.endUpdates()
                        self.tableView.backgroundView = self.getEmptyLabel()
                        if index.row != 0 && index.row == self.programs[index.section].programs.count {
                            let indexPath = IndexPath(row: index.row - 1, section: index.section)
                            if let cell = tableView.cellForRow(at: indexPath) as? ProgramTableViewCell {
                                cell.hideSeparator(true)
                            }
                        }
                    }
                case .error(let programID):
                    interactor?.handleBatchError(programID: programID)
                case .access(let programID, let isFavorite):
                    interactor?.handleBatchSuccess(programID: programID, isFavorite: isFavorite)
                }
            }.store(in: &cancellables)
    }
    
    func isFavorite(programID: Int, serverValue: Bool) -> Bool {
        favoritesManager.isProgramFavorited(
            programID: programID,
            serverValue: serverValue
        )
    }
    
    private func findIndexPath(programID: Int) -> IndexPath? {
        for (section, program) in programs.enumerated() {
            if let index = program.programs.firstIndex(where: {
                $0.programID == programID
            }) {
                return IndexPath(row: index, section: section)
            }
        }
        return nil
    }
}

