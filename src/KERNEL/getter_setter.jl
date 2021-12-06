export getParent, getPrevious, getNext, getFirstChild, getLastChild, getName, getTypeName,
    getElement, getRadius, getType, getNumberOfBonds, getFormalCharge, getPosition, getCharge,
    getVelocity, getForce, getOccupancy, getSerial, getTempFactor, getSelected, getBonds,
    getProperties, getNumberOfChildren, getContainsSelection, getNumberOfSelectedChildren,
    getNumberOfChildrenContainingSelection, getSelectionStamp, getModificationStamp, getTrait,
    getInsertionCode, getIsDisordered, getResNumber, getIsHetero, getSelected, getId,
    setParent, setPrevious, setNext, setFirstChild, setLastChild, setName, setTypeName,
    setElement, setRadius, setType, setNumberOfBonds, setFormalCharge, setPosition, setCharge,
    setVelocity, setForce, setOccupancy, setSerial, setTempFactor, setSelected, setBonds,
    setProperties, setNumberOfChildren, setContainsSelection, setNumberOfSelectedChildren,
    setNumberOfChildrenContainingSelection, setSelectionStamp, setModificationStamp, setTrait,
    setInsertionCode, setIsDisordered, setResNumber, setIsHetero, setSelected, setId

import .CONCEPT.getParent


#=
include("../COMMON/common.jl")
names = ["parent_", "previous_", "next_","first_child_",
                                        "last_child_",
                                        "name_",
                                        "type_name_",
                                        "element_",
                                        "radius_",
                                        "type_",
                                        "number_of_bonds_",
                                        "formal_charge_",
                                        "position_",
                                        "charge_",
                                        "velocity_",
                                        "force_",
                                        "occupancy_",
                                        "serial_",
                                        "temp_factor_",
                                        "selected_",
                                        "bonds_",
                                        "properties_",
"number_of_children_",
"contains_selection_",
"number_of_selected_children_",
"number_of_children_containing_selection_",
"selection_stamp_",
"modification_stamp_",
"trait_",
"insertion_code_",
"is_disordered_",
"res_number_",
"is_hetero_",
"selected_",
"id_"]


types = [
    "Union{Nothing,DataFrameRow}",
    "Union{Nothing,DataFrameRow}",
    "Union{Nothing,DataFrameRow}",
    "Union{DataFrameRow, Nothing}",
    "Union{DataFrameRow, Nothing}",
    "Union{String,Nothing}",
    "Union{String,Nothing}",
    "Union{Element,Nothing}",
    "Union{Float64,Nothing}",
    "Union{UInt8,Nothing}",
    "Union{UInt8,Nothing}",
    "Union{Int64,Nothing}",
    "Union{SVector{3,Float64},Nothing}",
    "Union{Float64,Nothing}",
    "Union{SVector{3,Float64},Nothing}",
    "Union{SVector{3,Float64},Nothing}",
    "Union{Float64, Nothing}",
    "Union{Int64,Nothing}",
    "Union{Float64,Nothing}",
    "Bool",
    "Dict{Atom, Bond}",
    "Vector{Tuple{String,UInt8}}",
    "Union{Int64,Nothing}",
    "Union{Bool,Nothing}",
    "Union{Int64,Nothing}",
    "Union{Int64,Nothing}",
    "Union{TimeStamp,Nothing}",
    "Union{TimeStamp,Nothing}",
    "Union{DataFrameRow, Nothing}",
    "Union{Char,Nothing}",
    "Union{Bool,Nothing}",
    "Union{Int64,Nothing}",
    "Union{Bool,Nothing}",
    "Bool",
    "Union{Char, Nothing}"
]

for (name, type) in zip(names,types)
    split_names = [split(string(name),"_")[1:end-1] ]
    fname = [*(capitalize.(x)...) for x in split_names][1]

    print("set$(fname), ")
    #println("\"\"\" ")
    #println("    set$(fname)(df_row::DataFrameRow, value::$(type)")
    #println("\"\"\" ")
    #println("set$(fname)(df_row::DataFrameRow, value::$(type) = begin df_row.$(name) = value end")
    #println()
    #println()
end
=#


"""
    getPrevious(comp::CompositeInterface)
"""
getPrevious(comp::CompositeInterface) = comp.previous_


"""
    getNext(comp::CompositeInterface)
"""
getNext(comp::CompositeInterface) = comp.next_


"""
    getFirstChild(comp::CompositeInterface)
"""
getFirstChild(comp::CompositeInterface) = comp.first_child_


"""
    getLastChild(comp::CompositeInterface)
"""
getLastChild(comp::CompositeInterface) = comp.last_child_





"""
    getTypeName(comp::CompositeInterface)
"""
getTypeName(comp::CompositeInterface) = comp.type_name_


"""
    getElement(comp::CompositeInterface)
"""
getElement(comp::CompositeInterface) = comp.element_


"""
    getRadius(comp::CompositeInterface)
"""
getRadius(comp::CompositeInterface) = comp.radius_


"""
    getType(comp::CompositeInterface)
"""
getType(comp::CompositeInterface) = comp.type_


"""
    getNumberOfBonds(comp::CompositeInterface)
"""
getNumberOfBonds(comp::CompositeInterface) = comp.number_of_bonds_


"""
    getFormalCharge(comp::CompositeInterface)
"""
getFormalCharge(comp::CompositeInterface) = comp.formal_charge_


"""
    getPosition(comp::CompositeInterface)
"""
getPosition(comp::CompositeInterface) = comp.position_


"""
    getPosition(comp_vec::Vector{T} where T<:AtomInterface)
"""
getPosition(comp_vec::Vector{T} where T<:AtomInterface) = [comp.position_ for comp in comp_vec]


"""
    getCharge(comp::CompositeInterface)
"""
getCharge(comp::CompositeInterface) = comp.charge_


"""
    getVelocity(comp::CompositeInterface)
"""
getVelocity(comp::CompositeInterface) = comp.velocity_


"""
    getForce(comp::CompositeInterface)
"""
getForce(comp::CompositeInterface) = comp.force_


"""
    getOccupancy(comp::CompositeInterface)
"""
getOccupancy(comp::CompositeInterface) = comp.occupancy_


"""
    getSerial(comp::CompositeInterface)
"""
getSerial(comp::CompositeInterface) = comp.serial_


"""
    getTempFactor(comp::CompositeInterface)
"""
getTempFactor(comp::CompositeInterface) = comp.temp_factor_





"""
    getBonds(comp::CompositeInterface)
"""
getBonds(comp::CompositeInterface) = comp.bonds_





"""
    getNumberOfChildren(comp::CompositeInterface)
"""
getNumberOfChildren(comp::CompositeInterface) = comp.number_of_children_


"""
    getContainsSelection(comp::CompositeInterface)
"""
getContainsSelection(comp::CompositeInterface) = comp.contains_selection_


"""
    getNumberOfSelectedChildren(comp::CompositeInterface)
"""
getNumberOfSelectedChildren(comp::CompositeInterface) = comp.number_of_selected_children_


"""
    getNumberOfChildrenContainingSelection(comp::CompositeInterface)
"""
getNumberOfChildrenContainingSelection(comp::CompositeInterface) = comp.number_of_children_containing_selection_


"""
    getSelectionStamp(comp::CompositeInterface)
"""
getSelectionStamp(comp::CompositeInterface) = comp.selection_stamp_


"""
    getModificationStamp(comp::CompositeInterface)
"""
getModificationStamp(comp::CompositeInterface) = comp.modification_stamp_


"""
    getTrait(comp::CompositeInterface)
"""
getTrait(comp::CompositeInterface) = comp.trait_


"""
    getInsertionCode(comp::CompositeInterface)
"""
getInsertionCode(comp::CompositeInterface) = comp.insertion_code_


"""
    getIsDisordered(comp::CompositeInterface)
"""
getIsDisordered(comp::CompositeInterface) = comp.is_disordered_


"""
    getResNumber(comp::CompositeInterface)
"""
getResNumber(comp::CompositeInterface) = comp.res_number_




"""
    getId(comp::CompositeInterface)
"""
getId(comp::CompositeInterface) = comp.id_





"""
    setParent(comp::CompositeInterface, value::Union{Nothing,CompositeInterface})
"""
setParent(comp::CompositeInterface, value::Union{Nothing,CompositeInterface}) = begin comp.parent_ = value end


"""
    setPrevious(comp::CompositeInterface, value::Union{Nothing,CompositeInterface})
"""
setPrevious(comp::CompositeInterface, value::Union{Nothing,CompositeInterface}) = begin comp.previous_ = value end


"""
    setNext(comp::CompositeInterface, value::Union{Nothing,CompositeInterface})
"""
setNext(comp::CompositeInterface, value::Union{Nothing,CompositeInterface}) = begin comp.next_ = value end


"""
    setFirstChild(comp::CompositeInterface, value::Union{CompositeInterface, Nothing})
"""
setFirstChild(comp::CompositeInterface, value::Union{CompositeInterface, Nothing}) = begin comp.first_child_ = value end


"""
    setLastChild(comp::CompositeInterface, value::Union{CompositeInterface, Nothing})
"""
setLastChild(comp::CompositeInterface, value::Union{CompositeInterface, Nothing}) = begin comp.last_child_ = value end


"""
    setName(comp::CompositeInterface, value::Union{String,Nothing})
"""
setName(comp::CompositeInterface, value::Union{String,Nothing}) = begin comp.name_ = value end


"""
    setTypeName(comp::CompositeInterface, value::Union{String,Nothing})
"""
setTypeName(comp::CompositeInterface, value::Union{String,Nothing}) = begin comp.type_name_ = value end


"""
    setElement(comp::CompositeInterface, value::Union{Element,Nothing})
"""
setElement(comp::CompositeInterface, value::Union{Element,Nothing}) = begin comp.element_ = value end


"""
    setRadius(comp::CompositeInterface, value::Union{Float64,Nothing})
"""
setRadius(comp::CompositeInterface, value::Union{Float64,Nothing}) = begin comp.radius_ = value end


"""
    setType(comp::CompositeInterface, value::Union{UInt8,Nothing})
"""
setType(comp::CompositeInterface, value::Union{UInt8,Nothing}) = begin comp.type_ = value end


"""
    setNumberOfBonds(comp::CompositeInterface, value::Union{UInt8,Nothing})
"""
setNumberOfBonds(comp::CompositeInterface, value::Union{UInt8,Nothing}) = begin comp.number_of_bonds_ = value end


"""
    setFormalCharge(comp::CompositeInterface, value::Union{Int64,Nothing})
"""
setFormalCharge(comp::CompositeInterface, value::Union{Int64,Nothing}) = begin comp.formal_charge_ = value end


"""
    setPosition(comp::CompositeInterface, value::Union{SVector{3,Float64},Nothing})
"""
setPosition(comp::CompositeInterface, value::Union{SVector{3,Float64},Nothing}) = begin comp.position_ = value end


"""
    setCharge(comp::CompositeInterface, value::Union{Float64,Nothing})
"""
setCharge(comp::CompositeInterface, value::Union{Float64,Nothing}) = begin comp.charge_ = value end


"""
    setVelocity(comp::CompositeInterface, value::Union{SVector{3,Float64},Nothing})
"""
setVelocity(comp::CompositeInterface, value::Union{SVector{3,Float64},Nothing}) = begin comp.velocity_ = value end


"""
    setForce(comp::CompositeInterface, value::Union{SVector{3,Float64},Nothing})
"""
setForce(comp::CompositeInterface, value::Union{SVector{3,Float64},Nothing}) = begin comp.force_ = value end


"""
    setOccupancy(comp::CompositeInterface, value::Union{Float64, Nothing})
"""
setOccupancy(comp::CompositeInterface, value::Union{Float64, Nothing}) = begin comp.occupancy_ = value end


"""
    setSerial(comp::CompositeInterface, value::Union{Int64,Nothing})
"""
setSerial(comp::CompositeInterface, value::Union{Int64,Nothing}) = begin comp.serial_ = value end


"""
    setTempFactor(comp::CompositeInterface, value::Union{Float64,Nothing})
"""
setTempFactor(comp::CompositeInterface, value::Union{Float64,Nothing}) = begin comp.temp_factor_ = value end





"""
    setBonds(comp::CompositeInterface, value::Dict{Atom, Bond})
"""
setBonds(comp::CompositeInterface, value::Dict{Atom, Bond}) = begin comp.bonds_ = value end


"""
    setProperties(comp::CompositeInterface, value::Vector{Tuple{String,UInt8}})
"""
setProperties(comp::CompositeInterface, value::Vector{Tuple{String,UInt8}}) = begin comp.properties_ = value end


"""
    setNumberOfChildren(comp::CompositeInterface, value::Union{Int64,Nothing})
"""
setNumberOfChildren(comp::CompositeInterface, value::Union{Int64,Nothing}) = begin comp.number_of_children_ = value end


"""
    setContainsSelection(comp::CompositeInterface, value::Union{Bool,Nothing})
"""
setContainsSelection(comp::CompositeInterface, value::Union{Bool,Nothing}) = begin comp.contains_selection_ = value end


"""
    setNumberOfSelectedChildren(comp::CompositeInterface, value::Union{Int64,Nothing})
"""
setNumberOfSelectedChildren(comp::CompositeInterface, value::Union{Int64,Nothing}) = begin comp.number_of_selected_children_ = value end


"""
    setNumberOfChildrenContainingSelection(comp::CompositeInterface, value::Union{Int64,Nothing})
"""
setNumberOfChildrenContainingSelection(comp::CompositeInterface, value::Union{Int64,Nothing}) = begin comp.number_of_children_containing_selection_ = value end


"""
    setSelectionStamp(comp::CompositeInterface, value::Union{TimeStamp,Nothing})
"""
setSelectionStamp(comp::CompositeInterface, value::Union{TimeStamp,Nothing}) = begin comp.selection_stamp_ = value end


"""
    setModificationStamp(comp::CompositeInterface, value::Union{TimeStamp,Nothing})
"""
setModificationStamp(comp::CompositeInterface, value::Union{TimeStamp,Nothing}) = begin comp.modification_stamp_ = value end


"""
    setTrait(comp::CompositeInterface, value::Union{CompositeInterface, Nothing})
"""
setTrait(comp::CompositeInterface, value::Union{CompositeInterface, Nothing}) = begin comp.trait_ = value end


"""
    setInsertionCode(comp::CompositeInterface, value::Union{Char,Nothing})
"""
setInsertionCode(comp::CompositeInterface, value::Union{Char,Nothing}) = begin comp.insertion_code_ = value end


"""
    setIsDisordered(comp::CompositeInterface, value::Union{Bool,Nothing})
"""
setIsDisordered(comp::CompositeInterface, value::Union{Bool,Nothing}) = begin comp.is_disordered_ = value end


"""
    setResNumber(comp::CompositeInterface, value::Union{Int64,Nothing})
"""
setResNumber(comp::CompositeInterface, value::Union{Int64,Nothing}) = begin comp.res_number_ = value end


"""
    setIsHetero(comp::CompositeInterface, value::Union{Bool,Nothing})
"""
setIsHetero(comp::CompositeInterface, value::Union{Bool,Nothing}) = begin comp.is_hetero_ = value end





"""
    setId(comp::CompositeInterface, value::Union{Char, Nothing})
"""
setId(comp::CompositeInterface, value::Union{Char, Nothing}) = begin comp.id_ = value end



#----------------DATAFRAMEROW getter setter-----------------------


"""
    getPrevious(df_row::DataFrameRow)
"""
getPrevious(df_row::DataFrameRow) = df_row.previous_




"""
    getName(df_row::DataFrameRow)
"""
getName(df_row::DataFrameRow) = df_row[1]


"""
    getTypeName(df_row::DataFrameRow)
"""
getTypeName(df_row::DataFrameRow) = df_row.type_name_


"""
    getElement(df_row::DataFrameRow)
"""
getElement(df_row::DataFrameRow) = df_row.element_


"""
    getRadius(df_row::DataFrameRow)
"""
getRadius(df_row::DataFrameRow) = df_row.radius_


"""
    getType(df_row::DataFrameRow)
"""
getType(df_row::DataFrameRow) = df_row.type_


"""
    getNumberOfBonds(df_row::DataFrameRow)
"""
getNumberOfBonds(df_row::DataFrameRow) = df_row.number_of_bonds_


"""
    getFormalCharge(df_row::DataFrameRow)
"""
getFormalCharge(df_row::DataFrameRow) = df_row.formal_charge_


"""
    getPosition(df_row::DataFrameRow)
"""
getPosition(df_row::DataFrameRow) = df_row.position_

"""
    getPosition(df::DataFrame)
"""
getPosition(df::DataFrame) = df.position_



"""
    getCharge(df_row::DataFrameRow)
"""
getCharge(df_row::DataFrameRow) = df_row.charge_


"""
    getVelocity(df_row::DataFrameRow)
"""
getVelocity(df_row::DataFrameRow) = df_row.velocity_


"""
    getForce(df_row::DataFrameRow)
"""
getForce(df_row::DataFrameRow) = df_row.force_


"""
    getOccupancy(df_row::DataFrameRow)
"""
getOccupancy(df_row::DataFrameRow) = df_row.occupancy_


"""
    getSerial(df_row::DataFrameRow)
"""
getSerial(df_row::DataFrameRow) = df_row.serial_


"""
    getTempFactor(df_row::DataFrameRow)
"""
getTempFactor(df_row::DataFrameRow) = df_row.temp_factor_




"""
    getProperties(df_row::DataFrameRow)
"""
getProperties(df_row::DataFrameRow) = df_row.properties_


"""
    getNumberOfChildren(df_row::DataFrameRow)
"""
getNumberOfChildren(df_row::DataFrameRow) = df_row.number_of_children_


"""
    getContainsSelection(df_row::DataFrameRow)
"""
getContainsSelection(df_row::DataFrameRow) = df_row.contains_selection_


"""
    getNumberOfSelectedChildren(df_row::DataFrameRow)
"""
getNumberOfSelectedChildren(df_row::DataFrameRow) = df_row.number_of_selected_children_


"""
    getNumberOfChildrenContainingSelection(df_row::DataFrameRow)
"""
getNumberOfChildrenContainingSelection(df_row::DataFrameRow) = df_row.number_of_children_containing_selection_


"""
    getSelectionStamp(df_row::DataFrameRow)
"""
getSelectionStamp(df_row::DataFrameRow) = df_row.selection_stamp_


"""
    getModificationStamp(df_row::DataFrameRow)
"""
getModificationStamp(df_row::DataFrameRow) = df_row.modification_stamp_




"""
    getInsertionCode(df_row::DataFrameRow)
"""
getInsertionCode(df_row::DataFrameRow) = df_row.insertion_code_


"""
    getIsDisordered(df_row::DataFrameRow)
"""
getIsDisordered(df_row::DataFrameRow) = df_row.is_disordered_


"""
    getResNumber(df_row::DataFrameRow)
"""
getResNumber(df_row::DataFrameRow) = df_row.res_number_


"""
    getIsHetero(df_row::DataFrameRow)
"""
getIsHetero(df_row::DataFrameRow) = df_row.is_hetero_


"""
    getSelected(df_row::DataFrameRow)
"""
getSelected(df_row::DataFrameRow) = df_row.selected_


"""
    getId(df_row::DataFrameRow)
"""
getId(df_row::DataFrameRow) = df_row.id_


"""
    setParent(df_row::DataFrameRow, value::Union{Nothing,DataFrameRow}
"""
setParent(df_row::DataFrameRow, value::Union{Nothing,DataFrameRow}) = begin df_row.parent_ = value end


"""
    setPrevious(df_row::DataFrameRow, value::Union{Nothing,DataFrameRow}
"""
setPrevious(df_row::DataFrameRow, value::Union{Nothing,DataFrameRow}) = begin df_row.previous_ = value end


"""
    setNext(df_row::DataFrameRow, value::Union{Nothing,DataFrameRow}
"""
setNext(df_row::DataFrameRow, value::Union{Nothing,DataFrameRow}) = begin df_row.next_ = value end


"""
    setFirstChild(df_row::DataFrameRow, value::Union{DataFrameRow, Nothing}
"""
setFirstChild(df_row::DataFrameRow, value::Union{DataFrameRow, Nothing}) = begin df_row.first_child_ = value end


"""
    setLastChild(df_row::DataFrameRow, value::Union{DataFrameRow, Nothing}
"""
setLastChild(df_row::DataFrameRow, value::Union{DataFrameRow, Nothing}) = begin df_row.last_child_ = value end


"""
    setName(df_row::DataFrameRow, value::Union{String,Nothing}
"""
setName(df_row::DataFrameRow, value::Union{String,Nothing}) = begin df_row.name_ = value end


"""
    setTypeName(df_row::DataFrameRow, value::Union{String,Nothing}
"""
setTypeName(df_row::DataFrameRow, value::Union{String,Nothing}) = begin df_row.type_name_ = value end


"""
    setElement(df_row::DataFrameRow, value::Union{Element,Nothing}
"""
setElement(df_row::DataFrameRow, value::Union{Element,Nothing}) = begin df_row.element_ = value end


"""
    setRadius(df_row::DataFrameRow, value::Union{Float64,Nothing}
"""
setRadius(df_row::DataFrameRow, value::Union{Float64,Nothing}) = begin df_row.radius_ = value end


"""
    setType(df_row::DataFrameRow, value::Union{UInt8,Nothing}
"""
setType(df_row::DataFrameRow, value::Union{UInt8,Nothing}) = begin df_row.type_ = value end


"""
    setNumberOfBonds(df_row::DataFrameRow, value::Union{UInt8,Nothing}
"""
setNumberOfBonds(df_row::DataFrameRow, value::Union{UInt8,Nothing}) = begin df_row.number_of_bonds_ = value end


"""
    setFormalCharge(df_row::DataFrameRow, value::Union{Int64,Nothing}
"""
setFormalCharge(df_row::DataFrameRow, value::Union{Int64,Nothing}) = begin df_row.formal_charge_ = value end


"""
    setPosition(df_row::DataFrameRow, value::Union{SVector{3,Float64},Nothing}
"""
setPosition(df_row::DataFrameRow, value::Union{SVector{3,Float64},Nothing}) = begin df_row.position_ = value end


"""
    setCharge(df_row::DataFrameRow, value::Union{Float64,Nothing}
"""
setCharge(df_row::DataFrameRow, value::Union{Float64,Nothing}) = begin df_row.charge_ = value end


"""
    setVelocity(df_row::DataFrameRow, value::Union{SVector{3,Float64},Nothing}
"""
setVelocity(df_row::DataFrameRow, value::Union{SVector{3,Float64},Nothing}) = begin df_row.velocity_ = value end


"""
    setForce(df_row::DataFrameRow, value::Union{SVector{3,Float64},Nothing}
"""
setForce(df_row::DataFrameRow, value::Union{SVector{3,Float64},Nothing}) = begin df_row.force_ = value end


"""
    setOccupancy(df_row::DataFrameRow, value::Union{Float64, Nothing}
"""
setOccupancy(df_row::DataFrameRow, value::Union{Float64, Nothing}) = begin df_row.occupancy_ = value end


"""
    setSerial(df_row::DataFrameRow, value::Union{Int64,Nothing}
"""
setSerial(df_row::DataFrameRow, value::Union{Int64,Nothing}) = begin df_row.serial_ = value end


"""
    setTempFactor(df_row::DataFrameRow, value::Union{Float64,Nothing}
"""
setTempFactor(df_row::DataFrameRow, value::Union{Float64,Nothing}) = begin df_row.temp_factor_ = value end



"""
    setBonds(df_row::DataFrameRow, value::Dict{Atom, Bond}
"""
setBonds(df_row::DataFrameRow, value::Dict{Atom, Bond}) = begin df_row.bonds_ = value end


"""
    setProperties(df_row::DataFrameRow, value::Vector{Tuple{String,UInt8}}
"""
setProperties(df_row::DataFrameRow, value::Vector{Tuple{String,UInt8}}) = begin df_row.properties_ = value end


"""
    setNumberOfChildren(df_row::DataFrameRow, value::Union{Int64,Nothing}
"""
setNumberOfChildren(df_row::DataFrameRow, value::Union{Int64,Nothing}) = begin df_row.number_of_children_ = value end


"""
    setContainsSelection(df_row::DataFrameRow, value::Union{Bool,Nothing}
"""
setContainsSelection(df_row::DataFrameRow, value::Union{Bool,Nothing}) = begin df_row.contains_selection_ = value end


"""
    setNumberOfSelectedChildren(df_row::DataFrameRow, value::Union{Int64,Nothing}
"""
setNumberOfSelectedChildren(df_row::DataFrameRow, value::Union{Int64,Nothing}) = begin df_row.number_of_selected_children_ = value end


"""
    setNumberOfChildrenContainingSelection(df_row::DataFrameRow, value::Union{Int64,Nothing}
"""
setNumberOfChildrenContainingSelection(df_row::DataFrameRow, value::Union{Int64,Nothing}) = begin df_row.number_of_children_containing_selection_ = value end


"""
    setSelectionStamp(df_row::DataFrameRow, value::Union{TimeStamp,Nothing}
"""
setSelectionStamp(df_row::DataFrameRow, value::Union{TimeStamp,Nothing}) = begin df_row.selection_stamp_ = value end


"""
    setModificationStamp(df_row::DataFrameRow, value::Union{TimeStamp,Nothing}
"""
setModificationStamp(df_row::DataFrameRow, value::Union{TimeStamp,Nothing}) = begin df_row.modification_stamp_ = value end


"""
    setTrait(df_row::DataFrameRow, value::Union{DataFrameRow, Nothing}
"""
setTrait(df_row::DataFrameRow, value::Union{DataFrameRow, Nothing}) = begin df_row.trait_ = value end


"""
    setInsertionCode(df_row::DataFrameRow, value::Union{Char,Nothing}
"""
setInsertionCode(df_row::DataFrameRow, value::Union{Char,Nothing}) = begin df_row.insertion_code_ = value end


"""
    setIsDisordered(df_row::DataFrameRow, value::Union{Bool,Nothing}
"""
setIsDisordered(df_row::DataFrameRow, value::Union{Bool,Nothing}) = begin df_row.is_disordered_ = value end


"""
    setResNumber(df_row::DataFrameRow, value::Union{Int64,Nothing}
"""
setResNumber(df_row::DataFrameRow, value::Union{Int64,Nothing}) = begin df_row.res_number_ = value end


"""
    setIsHetero(df_row::DataFrameRow, value::Union{Bool,Nothing}
"""
setIsHetero(df_row::DataFrameRow, value::Union{Bool,Nothing}) = begin df_row.is_hetero_ = value end


"""
    setSelected(df_row::DataFrameRow, value::Bool
"""
setSelected(df_row::DataFrameRow, value::Bool) = begin df_row.selected_ = value end


"""
    setId(df_row::DataFrameRow, value::Union{Char, Nothing}
"""
setId(df_row::DataFrameRow, value::Union{Char, Nothing}) = begin df_row.id_ = value end


