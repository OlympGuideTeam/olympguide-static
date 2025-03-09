//
//  FilterItem.swift
//  olympguide
//
//  Created by Tom Tim on 09.03.2025.
//

struct FilterItem {
    let paramType: ParamType
    let title: String
    let initMethod: InitMethod
    let isMultipleChoice: Bool
    
    var selectedIndices: Set<Int>
    
    var selectedParams: SingleOrMultipleArray<Param>
    
    init(
        paramType: ParamType,
        title: String,
        initMethod: InitMethod,
        isMultipleChoice: Bool
    ) {
        self.paramType = paramType
        self.title = title
        self.initMethod = initMethod
        self.isMultipleChoice = isMultipleChoice
        self.selectedIndices = []
        
        self.selectedParams = SingleOrMultipleArray<Param>(isMultiple: isMultipleChoice)
    }
}
