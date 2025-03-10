//
//  SortOptionsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

enum InitMethod {
    case endpoint(String)
    case models([OptionViewModel])
}

// MARK: - Constants
fileprivate enum Constants {
    // MARK: - Colors
    enum Colors {
        static let dimmingViewColor = UIColor.black
        static let peakColor = UIColor(hex: "#D9D9D9")
        static let cancelButtonBackgroundColor = UIColor(hex: "#E7E7E7")
        static let saveButtonBackgroundColor = UIColor(hex: "#E0E8FE")
        static let titleLabelTextColor = UIColor.black
        static let cancelButtonTextColor = UIColor.black
        static let saveButtonTextColor = UIColor.black
        static let containerBackgroundColor = UIColor.white
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let titleLabelFont = FontManager.shared.font(for: .optionsVCTitle)
        static let buttonFont = FontManager.shared.font(for: .bigButton)
    }
    
    // MARK: - Dimensions
    enum Dimensions {
        static let peakCornerRadius: CGFloat = 1.0
        static let containerCornerRadius: CGFloat = 25.0
        static let peakWidth: CGFloat = 45.0
        static let peakHeight: CGFloat = 3.0
        static let peakTopMargin: CGFloat = 6.0
        static let titleLabelTopMargin: CGFloat = 21.0
        static let titleLabelLeftMargin: CGFloat = 20.0
        static let buttonHeight: CGFloat = 48.0
        static let buttonBottomMargin: CGFloat = 37.0
        static let buttonLeftRightMargin: CGFloat = 20.0
        static let buttonSpacing: CGFloat = 2.5
        static let tableViewTopMargin: CGFloat = 5.0
        static let animateDuration: TimeInterval = 0.3
        static let containerX: CGFloat = 0.0
        static let containerCornerRadiusValue: CGFloat = 25.0
        static let sheetHeightOffset: CGFloat = 100.0
        static let sheetHeightSmall: CGFloat = 157.0
        static let rowHeight: CGFloat = 46.0
        static let buttonCornerRadius: CGFloat = 14.0
    }
    
    // MARK: - Alphas
    enum Alphas {
        static let dimmingViewInitialAlpha: CGFloat = 0.0
        static let dimmingViewFinalAlpha: CGFloat = 0.5
    }
    
    // MARK: - Numbers
    enum Numbers {
        static let rowsLimit: Int = 6
    }
    
    // MARK: - Velocities
    enum Velocities {
        static let maxPanVelocity: CGFloat = 600.0
    }
    
    // MARK: - Fractions
    enum Fractions {
        static let dismissThreshold: CGFloat = 0.5
    }
    
    // MARK: - Images
    enum Images {
        static let filledSquare = "inset.filled.square"
        static let square = "square"
        static let filledCircle = "inset.filled.circle"
        static let circle = "circle"
    }
    
    // MARK: - Strings
    enum Strings {
        static let cancel = "Отменить"
        static let apply = "Применить"
    }
}


protocol OptionsViewControllerDelegate: AnyObject {
    func didSelectOption(_ indices: Set<Int>, _ options: [OptionViewModel], paramType: ParamType?)
    func didCancle()
}

extension OptionsViewControllerDelegate {
    func didCancle() {}
}

protocol OptionsViewControllerButtonDelegate {
    func setButtonView(_: [OptionViewModel])
}

// MARK: - OptionsViewController
final class OptionsViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OptionsViewControllerDelegate?
    var buttonDelegate: OptionsViewControllerButtonDelegate?
    
    var interactor: (OptionsDataStore & OptionsBusinessLogic)?
    
    private var options: [OptionViewModel] = []
    
    private let dimmingView = UIView()
    private let containerView = UIView()
    private var finalY: CGFloat = 0
    private var endPoint: String?
    
    private var initialSelectedIndices: Set<Int> = []
    var selectedIndices: Set<Int> = []
    private var currentSelectedIndices: Set<Int> = []
    
    private var currentToAll: [Int: Int] = [:]
    private var allToCurrent: [Int: Int] = [:]
    
    private let titleLabel: UILabel = UILabel()
    private let cancelButton: UIButton = UIButton()
    private let saveButton: UIButton = UIButton()
    
    private var paramType: ParamType?
    
    private var isMultipleChoice: Bool
    lazy var searchBar: CustomTextField = CustomTextField(with: "Поиск")
    private let tableView: UITableView = UITableView()
    
    private var count: Int = 0
    private var currentCount = 10
    
    private let selectedScrollContainer: UIView = {
        $0.clipsToBounds = true
        return $0
    }(UIView())
    private var containerHeightConstraint: NSLayoutConstraint?
    
    private let selectedScrollView: SelectedScrollView = SelectedScrollView(selectedOptions: [])
    
    // MARK: - Initializers
    init(items: [String], title: String, isMultipleChoice: Bool) {
        self.titleLabel.text = title
        self.isMultipleChoice = isMultipleChoice
        super.init(nibName: nil, bundle: nil)
        self.currentSelectedIndices = self.selectedIndices
    }
    
    init(
        title: String,
        isMultipleChoice: Bool,
        selectedIndices: Set<Int>,
        options: [OptionViewModel],
        paramType: ParamType? = nil
    ) {
        self.count = options.count
        self.titleLabel.text = title
        self.isMultipleChoice = isMultipleChoice
        self.options = options
        self.paramType = paramType
        super.init(nibName: nil, bundle: nil)
        
        self.selectedIndices = selectedIndices
        self.currentSelectedIndices = self.selectedIndices
        for index in selectedIndices {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            selectedScrollView.addButtonToStackView(with: options[index].name, tag: index)
        }
        
        for i in 0..<self.options.count {
            allToCurrent[i] = i
            currentToAll[i] = i
        }
        currentCount = self.options.count
        
        setup()
        
        animateShowSafely()
    }
    
    init(
        title: String,
        isMultipleChoice: Bool,
        selectedIndices: Set<Int>,
//        count: Int,
        endPoint: String,
        paramType: ParamType? = nil
    ) {
//        self.count = count
        self.paramType = paramType
        self.endPoint = endPoint
        self.titleLabel.text = title
        self.isMultipleChoice = isMultipleChoice
        super.init(nibName: nil, bundle: nil)
        
        self.selectedIndices = selectedIndices
        self.currentSelectedIndices = self.selectedIndices
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen
        configureGesture()
//        configureUI()
        
        guard let endPoint else { return }
        
        let request = Options.FetchOptions.Request(endPoint: endPoint)
        interactor?.loadOptions(request: request)
    }
    
    // MARK: - Setup
    
    func setup() {
        let viewController = self
        let interactor = OptionsViewInteractor()
        let presenter = OptionViewPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: - Gesture Configuration
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        containerView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureDimmingView()
        configureContainerView()
        configurePeak()
        configureTitleLabel()
        configureCancelButton()
        configureSaveButton()
        if count >= Constants.Numbers.rowsLimit {
            configureSearchBar()
            configureSelectedScrollContainer()
        }
        configureTableView()
    }
    
    private func configureDimmingView() {
        dimmingView.frame = view.bounds
        dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewInitialAlpha)
        view.addSubview(dimmingView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    private func configureContainerView() {
        let sheetHeight: CGFloat = count > Constants.Numbers.rowsLimit
        ? view.bounds.height - Constants.Dimensions.sheetHeightOffset
        : Constants.Dimensions.sheetHeightSmall + Constants.Dimensions.rowHeight * CGFloat(count)
        
        containerView.frame = CGRect(
            x: Constants.Dimensions.containerX,
            y: view.bounds.height,
            width: view.bounds.width,
            height: sheetHeight
        )
        containerView.backgroundColor = Constants.Colors.containerBackgroundColor
        containerView.layer.cornerRadius = Constants.Dimensions.containerCornerRadius
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        finalY = view.bounds.height - sheetHeight
    }
    
    private func configurePeak() {
        let peak: UIView = UIView()
        peak.backgroundColor = Constants.Colors.peakColor
        peak.layer.cornerRadius = Constants.Dimensions.peakCornerRadius
        
        containerView.addSubview(peak)
        peak.frame = CGRect(
            x: (view.frame.width - Constants.Dimensions.peakWidth) / 2,
            y: Constants.Dimensions.peakTopMargin,
            width: Constants.Dimensions.peakWidth,
            height: Constants.Dimensions.peakHeight
        )
    }
    
    private func configureTitleLabel() {
        titleLabel.font = Constants.Fonts.titleLabelFont
        titleLabel.textColor = Constants.Colors.titleLabelTextColor
        
        containerView.addSubview(titleLabel)
        titleLabel.pinTop(to: containerView.topAnchor, Constants.Dimensions.titleLabelTopMargin)
        titleLabel.pinLeft(to: containerView.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle(Constants.Strings.cancel, for: .normal)
        cancelButton.setTitleColor(Constants.Colors.cancelButtonTextColor, for: .normal)
        cancelButton.backgroundColor = Constants.Colors.cancelButtonBackgroundColor
        cancelButton.titleLabel?.font = Constants.Fonts.buttonFont
        cancelButton.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        
        cancelButton.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        cancelButton.addTarget(nil, action: #selector(cancelButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        containerView.addSubview(cancelButton)
        cancelButton.pinBottom(to: containerView.bottomAnchor, Constants.Dimensions.buttonBottomMargin)
        cancelButton.setHeight(Constants.Dimensions.buttonHeight)
        cancelButton.pinLeft(to: containerView.leadingAnchor, Constants.Dimensions.buttonLeftRightMargin)
        cancelButton.pinRight(to: containerView.centerXAnchor, Constants.Dimensions.buttonSpacing)
    }
    
    private func configureSaveButton() {
        saveButton.setTitle(Constants.Strings.apply, for: .normal)
        saveButton.setTitleColor(Constants.Colors.saveButtonTextColor, for: .normal)
        saveButton.backgroundColor = Constants.Colors.saveButtonBackgroundColor
        saveButton.titleLabel?.font = Constants.Fonts.buttonFont
        saveButton.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        
        saveButton.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        saveButton.addTarget(nil, action: #selector(saveButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        containerView.addSubview(saveButton)
        saveButton.pinBottom(to: containerView.bottomAnchor, Constants.Dimensions.buttonBottomMargin)
        saveButton.setHeight(Constants.Dimensions.buttonHeight)
        saveButton.pinRight(to: containerView.trailingAnchor, Constants.Dimensions.buttonLeftRightMargin)
        saveButton.pinLeft(to: containerView.centerXAnchor, Constants.Dimensions.buttonSpacing)
    }
    
    private func configureSelectedScrollContainer() {
        containerView.addSubview(selectedScrollContainer)
        containerHeightConstraint = selectedScrollContainer.heightAnchor.constraint(equalToConstant: 0)
        containerHeightConstraint?.isActive = true
        
        selectedScrollContainer.pinTop(to: searchBar.bottomAnchor)
        selectedScrollContainer.pinLeft(to: containerView.leadingAnchor)
        selectedScrollContainer.pinRight(to: containerView.trailingAnchor)
        
        selectedScrollContainer.addSubview(selectedScrollView)
        selectedScrollView.pinLeft(to: containerView.leadingAnchor)
        selectedScrollView.pinRight(to: containerView.trailingAnchor)
        selectedScrollView.pinTop(to: selectedScrollContainer, 9)
        
        selectedScrollView.alpha = 0
        selectedScrollView.delegate = self
    }
    
    private func configureTableView() {
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        containerView.addSubview(tableView)
        if count >= Constants.Numbers.rowsLimit {
            tableView.pinTop(to: selectedScrollContainer.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        } else {
            tableView.pinTop(to: titleLabel.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        }
        tableView.pinLeft(to: containerView.leadingAnchor)
        tableView.pinRight(to: containerView.trailingAnchor)
        tableView.pinBottom(to: saveButton.topAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = count >= Constants.Numbers.rowsLimit
        
        containerView.backgroundColor = Constants.Colors.containerBackgroundColor
    }
    
    private func configureSearchBar() {
        containerView.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.pinTop(to: titleLabel.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        searchBar.pinLeft(to: view.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    // MARK: - Animation
    func animateShow() {
        configureUI()
        UIView.animate(withDuration: Constants.Dimensions.animateDuration) {
            self.containerView.frame.origin.y = self.finalY
            self.dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewFinalAlpha)
        }
    }
    
    func animateShowSafely() {
        if view.window != nil {
            animateShow()
        } else {
            DispatchQueue.main.async {
                self.animateShowSafely()
            }
        }
    }
    
    func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: Constants.Dimensions.animateDuration, animations: {
            self.containerView.frame.origin.y = self.view.bounds.height
            self.dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewInitialAlpha)
        }, completion: { _ in
            completion?()
        })
    }
    
    private func closeSheet() {
        animateDismiss {
            self.dismiss(animated: false)
        }
        delegate?.didCancle()
    }
    
    // MARK: - Actions
    @objc
    private func didTapDimmingView() {
        closeSheet()
    }
    
    // MARK: - Pan Gesture Handling
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            let newY = containerView.frame.origin.y + translation.y
            if newY >= finalY {
                containerView.frame.origin.y = newY
                gesture.setTranslation(.zero, in: view)
                
                let totalDistance = view.bounds.height - finalY
                let currentDistance = containerView.frame.origin.y - finalY
                let progress = currentDistance / totalDistance
                let newAlpha = Constants.Alphas.dimmingViewFinalAlpha * (1 - progress)
                dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(newAlpha)
            }
            
        case .ended, .cancelled:
            if velocity.y > Constants.Velocities.maxPanVelocity {
                closeSheet()
            } else {
                let distanceMoved = containerView.frame.origin.y - finalY
                let totalDistance = view.bounds.height - finalY
                
                if distanceMoved > totalDistance * Constants.Fractions.dismissThreshold {
                    closeSheet()
                } else {
                    UIView.animate(withDuration: Constants.Dimensions.animateDuration) {
                        self.containerView.frame.origin.y = self.finalY
                        self.dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewFinalAlpha)
                    }
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    private func calculateTableHeight() -> CGFloat {
        return CGFloat(min(currentSelectedIndices.count, Constants.Numbers.rowsLimit)) * Constants.Dimensions.rowHeight
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: indexPath) as? OptionsTableViewCell else {
            return UITableViewCell()
        }
        
        guard let index = currentToAll[indexPath.row] else { return UITableViewCell()}
        let item = options[index]
        cell.titleLabel.text = item.name
        
        if isMultipleChoice {
            let imageName = currentSelectedIndices.contains(indexPath.row) ? Constants.Images.filledSquare : Constants.Images.square
            cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        } else {
            let imageName = currentSelectedIndices.contains(indexPath.row) ? Constants.Images.filledCircle : Constants.Images.circle
            cell.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
        
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(at: indexPath)
        }
        
        let isLastCell = indexPath.row == currentCount - 1
        cell.hideSeparator(isLastCell)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleButtonTap(at: indexPath)
    }
    
    // MARK: - Selection Handling
    private func handleButtonTap(at indexPath: IndexPath) {
        if currentSelectedIndices.contains(indexPath.row) {
            currentSelectedIndices.remove(indexPath.row)
            tableView.reloadData()
            if let originIndex = currentToAll[indexPath.row] {
                selectedIndices.remove(originIndex)
                selectedScrollView.removeButtons(with: originIndex)
            }
            return
        }
        
        currentSelectedIndices.insert(indexPath.row)
        if let originIndex = currentToAll[indexPath.row] {
            selectedIndices.insert(originIndex)
            selectedScrollView.addButtonToStackView(with: options[originIndex].name, tag: originIndex)
        }
        tableView.reloadData()
        
        if !isMultipleChoice {
            for number in selectedIndices {
                if allToCurrent[number] != indexPath.row {
                    if let currentIndex = allToCurrent[number] {
                        currentSelectedIndices.remove(currentIndex)
                    }
                    selectedScrollView.removeButtons(with: number)
                    selectedIndices.remove(number)
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            sender.transform = .identity
        }
    }
    
    @objc
    func cancelButtonTouchUp(_ sender: UIButton) {
        buttonTouchUp(sender)
        closeSheet()
    }
    
    @objc
    func saveButtonTouchUp(_ sender: UIButton) {
        buttonTouchUp(sender)
        initialSelectedIndices = selectedIndices
        var names: [OptionViewModel] = []
        for index in selectedIndices {
            names.append(options[index])
        }
        delegate?.didSelectOption(selectedIndices, names, paramType: self.paramType)
        buttonDelegate?.setButtonView(names)
        animateDismiss {
            self.dismiss(animated: false)
        }
    }
}

// MARK: - CustomTextFieldDelegate
extension OptionsViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        let request = Options.TextDidChange.Request(query: text)
        interactor?.textDidChange(request: request)
    }
}

// MARK: - OptionsDisplayLogic
extension OptionsViewController: OptionsDisplayLogic {
    func displayTextDidChange(viewModel: Options.TextDidChange.ViewModel) {
        currentToAll.removeAll()
        allToCurrent.removeAll()
        currentSelectedIndices.removeAll()
        
        for item in viewModel.dependencies {
            currentToAll[item.currentIndex] = item.realIndex
            allToCurrent[item.realIndex] = item.currentIndex
        }
        
        for index in selectedIndices {
            if let currentIndex = allToCurrent[index] {
                currentSelectedIndices.insert(currentIndex)
            }
        }
        currentCount = currentToAll.count
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displayFetchOptions(viewModel: Options.FetchOptions.ViewModel) {
        if let error = viewModel.error {
            let presentingVC = presentingViewController
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.dismiss(animated: true) {
                    presentingVC?.showAlert(
                        with: error.localizedDescription,
                        cancelTitle: "Ок"
                    )
                }
            }
        }
        
        guard let options = viewModel.options else { return }
        
        self.options = options
        for i in 0..<self.options.count {
            allToCurrent[i] = i
            currentToAll[i] = i
        }
        currentCount = self.options.count
        count = self.options.count
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            for index in currentSelectedIndices {
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                selectedScrollView.addButtonToStackView(with: options[index].name, tag: index)
            }
        }
        animateShowSafely()
    }
    
}

// MARK: - SelectedBarDelegate
extension OptionsViewController : SelectedBarDelegate {
    func toggleCustomTextField() {
        guard let containerHeightConstraint = self.containerHeightConstraint else { return }
        if containerHeightConstraint.constant == 0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self,
                      let containerHeightConstraint = self.containerHeightConstraint
                else { return }
                containerHeightConstraint.constant = self.selectedScrollView.bounds.height + 12
                //                self.containerHeightConstraint.constant = self.selectedScrollView.bounds.height + 12
                self.selectedScrollView.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self,
                      let containerHeightConstraint = self.containerHeightConstraint
                else { return }
                containerHeightConstraint.constant = 0
                self.selectedScrollView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func unselectOption(at index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
            if let currentIndex = allToCurrent[index] {
                currentSelectedIndices.remove(currentIndex)
                tableView.reloadRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
            }
            return
        }
    }
}
