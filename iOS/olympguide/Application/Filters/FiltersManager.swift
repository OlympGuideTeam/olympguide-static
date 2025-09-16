//
//  FiltersManager.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

protocol FiltersManagerProtocol {
    func setData<T>(data: [FilterItem], for type: T.Type)
    func getData<T>(for type: T.Type) -> [FilterItem]
}

class FiltersManager : FiltersManagerProtocol {
    static let shared = FiltersManager()
    
    private var filtersDictionary: [ObjectIdentifier: [FilterItem]] = [:]
    
    let degreeFilterItem = FilterItem(
        paramType: .degree,
        title: "Формат обучения",
        initMethod: .models([
            OptionViewModel(id: 1, name: "Бакалавриат"),
            OptionViewModel(id: 2, name: "Специалитет")
        ]),
        isMultipleChoice: true
    )
    
    let regionFilterItem = FilterItem(
        paramType: .region,
        title: "Регион",
        initMethod: .endpoint("/meta/university-regions"),
        isMultipleChoice: true
    )
    
    let sortItem = FilterItem(
        paramType: .sort,
        title: "Сортировать",
        initMethod: .models([
            OptionViewModel(id: 1, name: "По уровню олимпиады"),
            OptionViewModel(id: 2, name: "По профилю олимпиады")
        ]),
        isMultipleChoice: false
    )
    
    let levelFilterItem = FilterItem(
        paramType: .olympiadLevel,
        title: "Уровень",
        initMethod: .models([
            OptionViewModel(id: 1, name: "I уровень"),
            OptionViewModel(id: 2, name: "II уровень"),
            OptionViewModel(id: 3, name: "III уровень")
        ]),
        isMultipleChoice: true
    )
    
    let profileFilterItem = FilterItem(
        paramType: .olympiadProfile,
        title: "Профиль олимпиады",
        initMethod: .endpoint("/meta/olympiad-profiles"),
        isMultipleChoice: true
    )
    
    let benefitFilterItem = FilterItem(
        paramType: .benefit,
        title: "Льгота",
        initMethod: .models([
            OptionViewModel(id: 1, name: "БВИ"),
            OptionViewModel(id: 2, name: "100 баллов")
        ]),
        isMultipleChoice: true
    )
    
    let minDiplomaLevelFilterItem = FilterItem(
        paramType: .minClass,
        title: "Минимальный класс диплома",
        initMethod: .models([
            OptionViewModel(id: 10, name: "10 класс"),
            OptionViewModel(id: 11, name: "11 класс")
        ]),
        isMultipleChoice: true
    )
    
    let diplomaLevelFilterItem = FilterItem(
        paramType: .minDiplomaLevel,
        title: "Степень диплома",
        initMethod: .models([
            OptionViewModel(id: 1, name: "Победитель"),
            OptionViewModel(id: 3, name: "Призёр")
        ]),
        isMultipleChoice: true
    )
    

    private init() {
        let universityFilterItems = [
            degreeFilterItem
        ]
        setData(data: universityFilterItems, for: UniversityViewController.self)
        
        let universitiesFilterItems: [FilterItem] = [
            regionFilterItem
        ]
        
        setData(data: universitiesFilterItems, for: UniversitiesViewController.self)
        
        let programFilterItems = [
            sortItem,
            levelFilterItem,
            profileFilterItem,
            benefitFilterItem,
            minDiplomaLevelFilterItem,
            diplomaLevelFilterItem
        ]
        
        setData(data: programFilterItems, for: ProgramViewController.self)
        
        let olympiadsFilterItems = [
            sortItem,
            levelFilterItem,
            profileFilterItem
        ]
        
        setData(data: olympiadsFilterItems, for: OlympiadsViewController.self)
        
        let olympiadFilterItems = [
            benefitFilterItem,
            minDiplomaLevelFilterItem,
            diplomaLevelFilterItem
        ]
        
        setData(data: olympiadFilterItems, for: OlympiadViewController.self)
        
        let diplomaFilterItems = [
            benefitFilterItem
        ]
        setData(data: diplomaFilterItems, for: DiplomaViewController.self)
        
        let fieldsFilterItems = [
            degreeFilterItem
        ]
        setData(data: fieldsFilterItems, for: FieldsViewController.self)
        
        let fieldFilterItems = [
            degreeFilterItem
        ]
        setData(data: fieldFilterItems, for: FieldViewController.self)
    }
    
    func setData<T>(data: [FilterItem], for type: T.Type) {
        let key = ObjectIdentifier(type)
        filtersDictionary[key] = data
    }

    func getData<T>(for type: T.Type) -> [FilterItem] {
        let key = ObjectIdentifier(type)
        guard let result =  filtersDictionary[key] else {
            fatalError( "No data for \(type)")
        }
        return result
    }
}
