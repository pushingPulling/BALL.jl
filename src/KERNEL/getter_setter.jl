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
    getPrevious(comp::AbstractComposite)
"""
getPrevious(comp::AbstractComposite) = comp.previous_


"""
    getNext(comp::AbstractComposite)
"""
getNext(comp::AbstractComposite) = comp.next_


"""
    getFirstChild(comp::AbstractComposite)
"""
getFirstChild(comp::AbstractComposite) = comp.first_child_


"""
    getLastChild(comp::AbstractComposite)
"""
getLastChild(comp::AbstractComposite) = comp.last_child_





"""
    getTypeName(comp::AbstractComposite)
"""
getTypeName(comp::AbstractComposite) = comp.type_name_


"""
    getElement(comp::AbstractComposite)
"""
getElement(comp::AbstractComposite) = comp.element_


"""
    getRadius(comp::AbstractComposite)
"""
getRadius(comp::AbstractComposite) = comp.radius_


"""
    getType(comp::AbstractComposite)
"""
getType(comp::AbstractComposite) = comp.type_


"""
    getNumberOfBonds(comp::AbstractComposite)
"""
getNumberOfBonds(comp::AbstractComposite) = comp.number_of_bonds_


"""
    getFormalCharge(comp::AbstractComposite)
"""
getFormalCharge(comp::AbstractComposite) = comp.formal_charge_


"""
    getPosition(comp::AbstractComposite)
"""
getPosition(comp::AbstractComposite) = comp.position_


"""
    getPosition(comp_vec::Vector{T} where T<:AbstractAtom)
"""
getPosition(comp_vec::Vector{T} where T<:AbstractAtom) = [comp.position_ for comp in comp_vec]


"""
    getCharge(comp::AbstractComposite)
"""
getCharge(comp::AbstractComposite) = comp.charge_


"""
    getVelocity(comp::AbstractComposite)
"""
getVelocity(comp::AbstractComposite) = comp.velocity_


"""
    getForce(comp::AbstractComposite)
"""
getForce(comp::AbstractComposite) = comp.force_


"""
    getOccupancy(comp::AbstractComposite)
"""
getOccupancy(comp::AbstractComposite) = comp.occupancy_


"""
    getSerial(comp::AbstractComposite)
"""
getSerial(comp::AbstractComposite) = comp.serial_


"""
    getTempFactor(comp::AbstractComposite)
"""
getTempFactor(comp::AbstractComposite) = comp.temp_factor_





"""
    getBonds(comp::AbstractComposite)
"""
getBonds(comp::AbstractComposite) = comp.bonds_

"""
    getSource(comp::AbstractComposite)
"""
getSource(bond::Bond) = bond.source_


"""
    getTarget(comp::AbstractComposite)
"""
getTarget(bond::Bond) = bond.target_


"""
    getNumberOfChildren(comp::AbstractComposite)
"""
getNumberOfChildren(comp::AbstractComposite) = comp.number_of_children_


"""
    getContainsSelection(comp::AbstractComposite)
"""
getContainsSelection(comp::AbstractComposite) = comp.contains_selection_


"""
    getNumberOfSelectedChildren(comp::AbstractComposite)
"""
getNumberOfSelectedChildren(comp::AbstractComposite) = comp.number_of_selected_children_


"""
    getNumberOfChildrenContainingSelection(comp::AbstractComposite)
"""
getNumberOfChildrenContainingSelection(comp::AbstractComposite) = comp.number_of_children_containing_selection_


"""
    getSelectionStamp(comp::AbstractComposite)
"""
getSelectionStamp(comp::AbstractComposite) = comp.selection_stamp_


"""
    getModificationStamp(comp::AbstractComposite)
"""
getModificationStamp(comp::AbstractComposite) = comp.modification_stamp_


"""
    getTrait(comp::AbstractComposite)
"""
getTrait(comp::AbstractComposite) = comp.trait_


"""
    getInsertionCode(comp::AbstractComposite)
"""
getInsertionCode(comp::AbstractComposite) = comp.insertion_code_


"""
    getIsDisordered(comp::AbstractComposite)
"""
getIsDisordered(comp::AbstractComposite) = comp.is_disordered_


"""
    getResNumber(comp::AbstractComposite)
"""
getResNumber(comp::AbstractComposite) = comp.res_number_




"""
    getId(comp::AbstractComposite)
"""
getId(comp::AbstractComposite) = comp.id_





"""
    setParent(comp::AbstractComposite, value::Union{Nothing,AbstractComposite})
"""
setParent(comp::AbstractComposite, value::Union{Nothing,AbstractComposite}) = begin comp.parent_ = value end


"""
    setPrevious(comp::AbstractComposite, value::Union{Nothing,AbstractComposite})
"""
setPrevious(comp::AbstractComposite, value::Union{Nothing,AbstractComposite}) = begin comp.previous_ = value end


"""
    setNext(comp::AbstractComposite, value::Union{Nothing,AbstractComposite})
"""
setNext(comp::AbstractComposite, value::Union{Nothing,AbstractComposite}) = begin comp.next_ = value end


"""
    setFirstChild(comp::AbstractComposite, value::Union{AbstractComposite, Nothing})
"""
setFirstChild(comp::AbstractComposite, value::Union{AbstractComposite, Nothing}) = begin comp.first_child_ = value end


"""
    setLastChild(comp::AbstractComposite, value::Union{AbstractComposite, Nothing})
"""
setLastChild(comp::AbstractComposite, value::Union{AbstractComposite, Nothing}) = begin comp.last_child_ = value end


"""
    setName(comp::AbstractComposite, value::Union{String,Nothing})
"""
setName(comp::AbstractComposite, value::Union{String,Nothing}) = begin comp.name_ = value end


"""
    setTypeName(comp::AbstractComposite, value::Union{String,Nothing})
"""
setTypeName(comp::AbstractComposite, value::Union{String,Nothing}) = begin comp.type_name_ = value end


"""
    setElement(comp::AbstractComposite, value::Union{Element,Nothing})
"""
setElement(comp::AbstractComposite, value::Union{Element,Nothing}) = begin comp.element_ = value end


"""
    setRadius(comp::AbstractComposite, value::Union{Float64,Nothing})
"""
setRadius(comp::AbstractComposite, value::Union{Float64,Nothing}) = begin comp.radius_ = value end


"""
    setType(comp::AbstractComposite, value::Union{UInt8,Nothing})
"""
setType(comp::AbstractComposite, value::Union{UInt8,Nothing}) = begin comp.type_ = value end


"""
    setNumberOfBonds(comp::AbstractComposite, value::Union{UInt8,Nothing})
"""
setNumberOfBonds(comp::AbstractComposite, value::Union{UInt8,Nothing}) = begin comp.number_of_bonds_ = value end


"""
    setFormalCharge(comp::AbstractComposite, value::Union{Int64,Nothing})
"""
setFormalCharge(comp::AbstractComposite, value::Union{Int64,Nothing}) = begin comp.formal_charge_ = value end


"""
    setPosition(comp::AbstractComposite, value::Union{SVector{3,Float64},Nothing})
"""
setPosition(comp::AbstractComposite, value::Union{SVector{3,Float64},Nothing}) = begin comp.position_ = value end


"""
    setCharge(comp::AbstractComposite, value::Union{Float64,Nothing})
"""
setCharge(comp::AbstractComposite, value::Union{Float64,Nothing}) = begin comp.charge_ = value end


"""
    setVelocity(comp::AbstractComposite, value::Union{SVector{3,Float64},Nothing})
"""
setVelocity(comp::AbstractComposite, value::Union{SVector{3,Float64},Nothing}) = begin comp.velocity_ = value end


"""
    setForce(comp::AbstractComposite, value::Union{SVector{3,Float64},Nothing})
"""
setForce(comp::AbstractComposite, value::Union{SVector{3,Float64},Nothing}) = begin comp.force_ = value end


"""
    setOccupancy(comp::AbstractComposite, value::Union{Float64, Nothing})
"""
setOccupancy(comp::AbstractComposite, value::Union{Float64, Nothing}) = begin comp.occupancy_ = value end


"""
    setSerial(comp::AbstractComposite, value::Union{Int64,Nothing})
"""
setSerial(comp::AbstractComposite, value::Union{Int64,Nothing}) = begin comp.serial_ = value end


"""
    setTempFactor(comp::AbstractComposite, value::Union{Float64,Nothing})
"""
setTempFactor(comp::AbstractComposite, value::Union{Float64,Nothing}) = begin comp.temp_factor_ = value end





"""
    setBonds(comp::AbstractComposite, value::Dict{Atom, Bond})
"""
setBonds(comp::AbstractComposite, value::Dict{Atom, Bond}) = begin comp.bonds_ = value end


"""
    setProperties(comp::AbstractComposite, value::Vector{Tuple{String,UInt8}})
"""
setProperties(comp::AbstractComposite, value::Vector{Tuple{String,UInt8}}) = begin comp.properties_ = value end


"""
    setNumberOfChildren(comp::AbstractComposite, value::Union{Int64,Nothing})
"""
setNumberOfChildren(comp::AbstractComposite, value::Union{Int64,Nothing}) = begin comp.number_of_children_ = value end


"""
    setContainsSelection(comp::AbstractComposite, value::Union{Bool,Nothing})
"""
setContainsSelection(comp::AbstractComposite, value::Union{Bool,Nothing}) = begin comp.contains_selection_ = value end


"""
    setNumberOfSelectedChildren(comp::AbstractComposite, value::Union{Int64,Nothing})
"""
setNumberOfSelectedChildren(comp::AbstractComposite, value::Union{Int64,Nothing}) = begin comp.number_of_selected_children_ = value end


"""
    setNumberOfChildrenContainingSelection(comp::AbstractComposite, value::Union{Int64,Nothing})
"""
setNumberOfChildrenContainingSelection(comp::AbstractComposite, value::Union{Int64,Nothing}) = begin comp.number_of_children_containing_selection_ = value end


"""
    setSelectionStamp(comp::AbstractComposite, value::Union{TimeStamp,Nothing})
"""
setSelectionStamp(comp::AbstractComposite, value::Union{TimeStamp,Nothing}) = begin comp.selection_stamp_ = value end


"""
    setModificationStamp(comp::AbstractComposite, value::Union{TimeStamp,Nothing})
"""
setModificationStamp(comp::AbstractComposite, value::Union{TimeStamp,Nothing}) = begin comp.modification_stamp_ = value end


"""
    setTrait(comp::AbstractComposite, value::Union{AbstractComposite, Nothing})
"""
setTrait(comp::AbstractComposite, value::Union{AbstractComposite, Nothing}) = begin comp.trait_ = value end


"""
    setInsertionCode(comp::AbstractComposite, value::Union{Char,Nothing})
"""
setInsertionCode(comp::AbstractComposite, value::Union{Char,Nothing}) = begin comp.insertion_code_ = value end


"""
    setIsDisordered(comp::AbstractComposite, value::Union{Bool,Nothing})
"""
setIsDisordered(comp::AbstractComposite, value::Union{Bool,Nothing}) = begin comp.is_disordered_ = value end


"""
    setResNumber(comp::AbstractComposite, value::Union{Int64,Nothing})
"""
setResNumber(comp::AbstractComposite, value::Union{Int64,Nothing}) = begin comp.res_number_ = value end


"""
    setIsHetero(comp::AbstractComposite, value::Union{Bool,Nothing})
"""
setIsHetero(comp::AbstractComposite, value::Union{Bool,Nothing}) = begin comp.is_hetero_ = value end





"""
    setId(comp::AbstractComposite, value::Union{Char, Nothing})
"""
setId(comp::AbstractComposite, value::Union{Char, Nothing}) = begin comp.id_ = value end



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
    getPosition(df::DataFrame)
"""
getPosition(df::SubDataFrame) = df.position_



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


