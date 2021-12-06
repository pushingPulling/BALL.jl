export DataFrameSystem, getSource, getTarget, getFirstChild, getLastChild, getTrait
import .CONCEPT: getChildren, getParent
import .KERNEL: coords, isHetero, collectAtoms
import Base: length, getindex, ==, show



"""
    DataFrameSystem
`DataFrameSystem` is a collection of `DataFrame`s to store `KERNEL` types in.
"""
mutable struct DataFrameSystem <: KernelInterface
    systems ::DataFrame
    chains  ::DataFrame
    residues::DataFrame
    atoms   ::DataFrame
    bonds   ::DataFrame
    DataFrameSystem(
        systems::DataFrame,
        chains::DataFrame,
        residues::DataFrame,
        atoms::DataFrame,
        bonds::DataFrame
    ) = new(systems, chains, residues, atoms, bonds)
end

const bond_names = [    #6
   :name_,
   :source_,
   :target_,
   :bond_order_,
   :bond_type_,
   :properties_
]

const bond_types = Type[
    String,
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},
    Order,
    BondType,
    Vector{Tuple{String,UInt8}}
]


const atom_names = [ #18
    :name_,
    :parent_,
    :type_name_,
    :element_,
    :radius_,
    :type_,
    :number_of_bonds_,
    :formal_charge_,
    :position_,
    :charge_,
    :velocity_,
    :force_,
    :occupancy_,
    :serial_,
    :temp_factor_,
    :selected_,
    :bonds_,
    :properties_
]

const atom_types = [
    Union{String,Nothing},                  #name_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #parent_
    Union{String,Nothing},                  #type_name_
    Union{Element,Nothing},                 #element_
    Union{Float64,Nothing},                 #radius_
    Union{UInt8,Nothing},                   #type_
    Union{UInt8,Nothing},                   #number_of_bonds_
    Union{Int64,Nothing},                   #formal_charge_
    Union{SVector{3,Float64},Nothing},      #position_
    Union{Float64,Nothing},                 #charge_
    Union{SVector{3,Float64},Nothing},      #velocity_
    Union{SVector{3,Float64},Nothing},      #force_
    Union{Float64, Nothing},                #occupancy_
    Union{Int64,Nothing},                   #serial_
    Union{Float64,Nothing},                 #temp_factor_
    Bool,                                   #selected_
    Union{Base.RefValue{Vector{DataFrameRow}}, Nothing},    #bonds_
    Vector{Tuple{String,UInt8}}             #properties_
]

#----------
const residue_names = [#17
    :name_,
    :number_of_children_,
    :parent_,
    :first_child_,
    :last_child_,
    :properties_,
    :contains_selection_,
    :number_of_selected_children_,
    :number_of_children_containing_selection_,
    :selection_stamp_,
    :modification_stamp_,
    :trait_,
    :insertion_code_,
    :is_disordered_,
    :res_number_,
    :is_hetero_,
    :selected_
]


const residue_types = [
    Union{String,Nothing},                  #name_
    Union{Int64,Nothing},                   #number_of_children_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #parent_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #first_child_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #last_child_
    Vector{Tuple{String,UInt8}},            #properties_
    Union{Bool,Nothing},            #contains_selection_
    Union{Int64,Nothing},           #number_of_selected_children_
    Union{Int64,Nothing},           #number_of_children_containing_selection_
    Union{TimeStamp,Nothing},               #selection_stamp_
    Union{TimeStamp,Nothing},               #modification_stamp_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #trait_
    Union{Char,Nothing},                    #insertion_code_
    Union{Bool,Nothing},                    #is_disordered_
    Union{Int64,Nothing},                   #res_number_
    Union{Bool,Nothing},                    #is_hetero_
    Bool                                    #selected_
]

#-------------------------

const chain_names = [#13
    :id_,
    :number_of_children_,
    :parent_,
    :first_child_,
    :last_child_,
    :properties_,
    :contains_selection_,
    :number_of_selected_children_,
    :number_of_children_containing_selection_,
    :selection_stamp_,
    :modification_stamp_,
    :trait_,
    :selected_

]


const chain_types = [
    Union{Char, Nothing}                                                    ,    #id_
    Union{Int64,Nothing}                                                    ,    #number_of_children_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #parent_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #first_child_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},            #last_child_
    Vector{Tuple{String,UInt8}}                                             ,    #properties_
    Union{Bool,Nothing}                                                     ,    #contains_selection_
    Union{Int64,Nothing}                                                    ,    #number_of_selected_children_
    Union{Int64,Nothing}                                                    ,    #number_of_children_containing_selection_
    Union{TimeStamp,Nothing}                                                ,    #selection_stamp_
    Union{TimeStamp,Nothing}                                                ,    #modification_stamp_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},           #trait_
    Bool                                                                #selected_
]
#----------------------------------

const system_names = [#13
    :name_,
    :number_of_children_,
    :first_child_,
    :last_child_,
    :properties_,
    :contains_selection_,
    :number_of_selected_children_,
    :number_of_children_containing_selection_,
    :selection_stamp_,
    :modification_stamp_,
    :trait_,
    :selected_,
    :dataframesystem_
]

const system_types = [
    Union{String,Nothing},                  #name_
    Union{Int64,Nothing},                   #number_of_children_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},           #first_child_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},           #last_child_
    Vector{Tuple{String,UInt8}},            #properties_
    Union{Bool,Nothing},                    #contains_selection_
    Union{Int64,Nothing},                   #number_of_selected_children_
    Union{Int64,Nothing},                   #number_of_children_containing_selection_
    Union{TimeStamp,Nothing},               #selection_stamp_
    Union{TimeStamp,Nothing},               #modification_stamp_
    Union{Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}, Nothing},           #trait_
    Bool,                                   #selected_
    Base.RefValue{DataFrameSystem}          #dataframesystem_
]


Base.show(io::IO, dfs::DataFrameSystem) = begin
    println(io, "systems : " ,dfs.systems)
    println(io, "chains  : " ,dfs.chains)
    println(io, "residues: " ,dfs.residues)
    println(io, "atoms   : " ,dfs.atoms)
    println(io, "bonds   : " ,dfs.bonds)
end

initBondsDF(bonds_df::DataFrame, names::Vector{Symbol}, types::Vector{Type}) = begin
    for (name, Type) in zip(names,types)
        setproperty!(bonds_df,name, Type[])
    end
    return bonds_df
end

initAtomDF(atoms_df::DataFrame, names::Vector{Symbol}, types::Vector{Type}) = begin

    for (name, Type) in zip(names,types)
        setproperty!(atoms_df,name, Type[])
    end
    return atoms_df
end

initResidueDF(residue_df::DataFrame, names::Vector{Symbol}, types::Vector{Type}) = begin

    for (name, Type) in zip(names,types)
        setproperty!(residue_df, name, Type[])
    end
    return residue_df
end

initChainDF(chain_df::DataFrame, names::Vector{Symbol}, types::Vector{Type}) = begin

    for (name, Type) in zip(names,types)
        setproperty!(chain_df, name, Type[])
    end
    return chain_df

end

initSystemDF(system_df::DataFrame, names::Vector{Symbol}, types::Vector{Type}) = begin

    for (name, Type) in zip(names,types)
        setproperty!(system_df, name, Type[])
    end
    return system_df
end



insert_systems_into_dfs(input_sys::SystemInterface, systems_df::DataFrame) = begin
    @inbounds for sys in collectSystems(input_sys)
        push!(systems_df,  ( sys[:name_], sys[:number_of_children_], nothing, nothing,
                                    sys[:properties_], sys[:contains_selection_],
                                    sys[:number_of_selected_children_],
                                    sys[:number_of_children_containing_selection_],
                                    sys[:selection_stamp_], sys[:modification_stamp_],
                                    sys[:trait_], sys[:selected_],
                                    Base.RefValue{DataFrameSystem}()
                            )
        )
    end
end


insert_chains_into_dfs(systems_df::DataFrame, chains_df::DataFrame, input_sys::SystemInterface) = begin
    #insert chains into DFS and set the correct references to parents, children etc.
    @inbounds for (sys_df_row, comp_sys) in zip(eachrow(systems_df), collectSystems(input_sys))
        for chain in getChildren(comp_sys)::Vector{Chain}
            push!(chains_df,  ( chain[:id_], chain[:number_of_children_], Ref(sys_df_row),
                                        nothing, nothing, chain[:properties_],
                                        chain[:contains_selection_],
                                        chain[:number_of_selected_children_],
                                        chain[:number_of_children_containing_selection_],
                                        chain[:selection_stamp_], chain[:modification_stamp_],
                                        chain[:trait_], chain[:selected_]
                                    )
            )
            #if isnothing(chain.previous_), then chain is a systems first_child_
            if isnothing(chain.previous_)
                sys_df_row.first_child_ = Ref(last(chains_df))
            end

            #if isnothing(chain.next_), then chain is a systems last_child_
            if isnothing(chain.next_)
                sys_df_row.last_child_ = Ref(last(chains_df))
            end
        end
    end
end

insert_residues_into_dfs(chains_df::DataFrame, residues_df::DataFrame, input_sys::SystemInterface) = begin
    @inbounds for (chain_df_row, comp_chain) in zip(eachrow(chains_df), collectChains(input_sys))
        for residue in getChildren(comp_chain)::Vector{Residue}
            push!(residues_df,  ( residue[:name_], residue[:number_of_children_], Ref(chain_df_row),
                                        nothing, nothing, residue[:properties_],
                                        residue[:contains_selection_],
                                        residue[:number_of_selected_children_],
                                        residue[:number_of_children_containing_selection_],
                                        residue[:selection_stamp_], residue[:modification_stamp_],
                                        residue[:trait_],           residue[:insertion_code_],
                                        residue[:is_disordered_],   residue[:res_number_],
                                        residue[:is_hetero_],       residue[:selected_]

                                    )
            )
            #if isnothing(chain.previous_), then chain is a systems first_child_
            if isnothing(residue.previous_)
                chain_df_row.first_child_ = Ref(last(residues_df))
            end

            #if isnothing(chain.next_), then chain is a systems last_child_
            if isnothing(residue.next_)
                chain_df_row.last_child_ = Ref(last(residues_df))
            end
        end
    end
end

insert_atoms_into_dfs(residues_df::DataFrame, atoms_df::DataFrame, input_sys::SystemInterface) = begin
    @inbounds for (res_df_row, comp_res) in zip(eachrow(residues_df), collectResidues(input_sys))
        for atom in getChildren(comp_res)::Vector{Atom}
            push!(atoms_df,  ( atom[:name_], Ref(res_df_row), atom[:type_name_],
                                        atom[:element_],        atom[:radius_], atom[:type_],
                                        atom[:number_of_bonds_],atom[:formal_charge_],
                                        atom[:position_],       atom[:charge_], atom[:velocity_],
                                        atom[:force_],          atom[:occupancy_], atom[:serial_],
                                        atom[:temp_factor_],    atom[:selected_],
                                        Ref(DataFrameRow[]),         atom[:properties_]
                                    )
            )
            #if isnothing(chain.previous_), then chain is a systems first_child_
            if isnothing(atom.previous_)
                res_df_row.first_child_ = Ref(last(atoms_df))
            end

            #if isnothing(chain.next_), then chain is a systems last_child_
            if isnothing(atom.next_)
                res_df_row.last_child_ = Ref(last(atoms_df))
            end
        end
    end
end

insert_bonds_into_dfs(atoms_df::DataFrame, bonds_df::DataFrame, input_sys::SystemInterface) = begin
    for comp_bond in viewBonds(input_sys)
        source_atom_serial::Int64 = comp_bond.source_.serial_
        target_atom_serial::Int64 = comp_bond.target_.serial_

        df_bond::DataFrameRow = last(
                                        push!(bonds_df,
                                                (comp_bond[:name_],
                                                    Ref(atoms_df[source_atom_serial,:]),
                                                    Ref(atoms_df[target_atom_serial,:]),
                                                    comp_bond[:bond_order_], comp_bond[:bond_type_],
                                                    comp_bond[:properties_]
                                                )
                                        )
                                    )
        push!(atoms_df.bonds_[source_atom_serial][], df_bond)
        push!(atoms_df.bonds_[target_atom_serial][], df_bond)
    end
end

"""
    DataFrameSystem(input_sys::System)

Constructs a [`DataFrameSystem`](@ref) out of a System. The `DataFrames` will have the same fields
and types as the objects in the tree of composites rooted in `input_sys`.
"""
DataFrameSystem(input_sys::T where T<:SystemInterface,
    atom_names::Vector{Symbol},     atom_types::Vector{Type},
    residue_names::Vector{Symbol},  residue_types::Vector{Type},
    chain_names::Vector{Symbol},    chain_types::Vector{Type},
    system_names::Vector{Symbol},   system_types::Vector{Type},
    bond_names::Vector{Symbol},     bond_types::Vector{Type})  = begin

    systems_df =    initSystemDF(DataFrame(),   system_names,   system_types)
    chains_df =     initChainDF(DataFrame(),    chain_names,    chain_types)
    residues_df =   initResidueDF(DataFrame(),  residue_names,  residue_types)
    atoms_df =      initAtomDF(DataFrame(),     atom_names,     atom_types)
    bonds_df =      initBondsDF(DataFrame(),    bond_names,     bond_types)

    insert_systems_into_dfs(input_sys, systems_df)

    insert_chains_into_dfs(systems_df, chains_df, input_sys)

    insert_residues_into_dfs(chains_df, residues_df, input_sys)

    insert_atoms_into_dfs(residues_df, atoms_df, input_sys)

    insert_bonds_into_dfs(atoms_df, bonds_df, input_sys)

    return DataFrameSystem(systems_df, chains_df, residues_df, atoms_df, bonds_df)
end

DataFrameSystem(input_sys::T where T<:SystemInterface) = begin
    #temp::Vector{Type} = bond_types
    dfs::DataFrameSystem = DataFrameSystem(input_sys,
                                            atom_names,     atom_types,
                                            residue_names,  residue_types,
                                            chain_names,    chain_types,
                                            system_names,   system_types,
                                            bond_names,     bond_types
    )
    for row in eachrow(dfs.systems)
        row.dataframesystem_ = Ref(dfs)
    end

    return dfs
end

coords(dfr::DataFrameRow) = dfr.position_

getChildren(dfr::DataFrameRow) = begin
    propertynames(dfr)[2] == :parent_ && return nothing
    target_df::DataFrame = getfield(getFirstChild(dfr), :df)
    first_child_idx::Int = getfield(getFirstChild(dfr), :dfrow)
    last_child_idx::Int = getfield(getLastChild(dfr), :dfrow)
    return eachrow(target_df[first_child_idx:last_child_idx, :])
end

length(df::DataFrame) = nrow(df)

getindex(df::AbstractDataFrame, idx::Int) = @view df[idx,:]

getNext(dfr::DataFrameRow) = begin
    target_df::DataFrame = getfield(dfr, :df)
    idx::Int64 = getfield(dfr, :dfrow) + 1
    return @view target_df[idx,:]
end

getSource(dfr::DataFrameRow) = dfr[:source_][]
getTarget(dfr::DataFrameRow) = dfr[:target_][]

getParent(dfr::DataFrameRow) = isnothing(dfr[:parent_]) ? nothing : dfr[:parent_][]
getBonds(dfr::DataFrameRow) = isnothing(dfr[:bonds_]) ? nothing : dfr[:bonds_][]

getFirstChild(dfr::DataFrameRow) = isnothing(dfr[:first_child_]) ? nothing : dfr[:first_child_][]
getLastChild(dfr::DataFrameRow) = isnothing(dfr[:last_child_]) ? nothing : dfr[:last_child_][]

getTrait(dfr::DataFrameRow) = isnothing(dfr[:trait_]) ? nothing : dfr[:trait_][]

isHetero(dfr::DataFrameRow) = dfr.is_hetero_

#= thanks to refs i can ignore this
(==)(df1::DataFrame, df2::DataFrame)= begin

end

(==)(dfr1::DataFrameRow, dfr2::DataFrameRow) = begin
    if DataFrames._equal_names(dfr1, dfr2)
        return getfield(dfr1, :dfrow) == getfield(dfr2, :dfrow)
    end
    return false
end

(==)(sdf1::SubDataFrame, sdf2::SubDataFrame) = begin
    if DataFrames._equal_names(sdf1, sdf2)
        return getfield(sdf1, :rows) == getfield(sdf2, :rows)
    end
    return false
end
=#

Base.show(io::IO, refrow::Base.RefValue{DataFrameRow{DataFrame, DataFrames.Index}}) =
    show(io, getfield(refrow[], :dfrow))

Base.show(io::IO, refrows::Base.RefValue{Vector{DataFrameRow}}) = show(io,refrows[])