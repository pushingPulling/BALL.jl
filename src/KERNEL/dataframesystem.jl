
export DataFrameSystem, getSource, getTarget, getFirstChild, getLastChild, getTrait, viewChildren,
        collectChildren,AtomDF,ResidueDF, ChainDF, SystemDF, BioFrame, getproperty, nrow,
        BioFrame, AtomDF, ResidueDF, ChainDF, SystemDF, BondDF

using DataFrames: MultiColumnIndex
import .CONCEPT: getChildren, getParent, setProperty
import .KERNEL: coords, isHetero, collectAtoms, viewAtoms
import Base: length, getindex, ==, show, vcat, merge, eachcol, insert!, deleteat!, show, names, ncol,display



const DFR = DataFrames.DataFrameRow


const bond_names = [    #6
   :name_,
   :source_,
   :target_,
   :bond_order_,
   :bond_type_,
   :properties_
]

const bond_types = [
    String[],
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],
    Order[],
    BondType[],
    Vector{Tuple{Symbol,Any}}[]
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
    :properties_,
    :dfs
]

const atom_types = [
    Union{String,Nothing}[],                  #name_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #parent_
    Union{String,Nothing}[],                  #type_name_
    Union{Element,Nothing}[],                 #element_
    Union{Float64,Nothing}[],                 #radius_
    Union{UInt8,Nothing}[],                   #type_
    Union{UInt8,Nothing}[],                   #number_of_bonds_
    Union{Int64,Nothing}[],                   #formal_charge_
    SVector{3,Float64}[],      #position_
    Union{Float64,Nothing}[],                 #charge_
    Union{SVector{3,Float64},Nothing}[],      #velocity_
    Union{SVector{3,Float64},Nothing}[],      #force_
    Union{Float64, Nothing}[],                #occupancy_
    Union{Int64,Nothing}[],                   #serial_
    Union{Float64,Nothing}[],                 #temp_factor_
    Bool[],                                   #selected_
    Union{Base.RefValue{Vector{DataFrames.DataFrameRow}}, Nothing}[],    #bonds_
    Vector{Tuple{Symbol,Any}}[],                 #properties_
    Union{Base.RefValue{DataFrameSystem}, Nothing}[]            #dfs
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
    :selected_,
    :dfs
]


const residue_types = [
    String[],                  #name_
    Union{Int64,Nothing}[],                   #number_of_children_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #parent_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #first_child_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #last_child_
    Vector{Tuple{Symbol,Any}}[],            #properties_
    Union{Bool,Nothing}[],            #contains_selection_
    Union{Int64,Nothing}[],           #number_of_selected_children_
    Union{Int64,Nothing}[],           #number_of_children_containing_selection_
    Union{TimeStamp,Nothing}[],               #selection_stamp_
    Union{TimeStamp,Nothing}[],               #modification_stamp_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #trait_
    Union{Char,Nothing}[],                    #insertion_code_
    Union{Bool,Nothing}[],                    #is_disordered_
    Union{Int64,Nothing}[],                   #res_number_
    Union{Bool,Nothing}[],                    #is_hetero_
    Bool[],                                   #selected_
    Union{Base.RefValue{DataFrameSystem}, Nothing}[]        #dfs
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
    :selected_,
    :dfs

]


const chain_types = [
    Union{Char, Nothing}[]                                                    ,    #id_
    Union{Int64,Nothing}[]                                                    ,    #number_of_children_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #parent_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #first_child_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],            #last_child_
    Vector{Tuple{Symbol,Any}}[]                                             ,    #properties_
    Union{Bool,Nothing}[]                                                     ,    #contains_selection_
    Union{Int64,Nothing}[]                                                    ,    #number_of_selected_children_
    Union{Int64,Nothing}[]                                                    ,    #number_of_children_containing_selection_
    Union{TimeStamp,Nothing}[]                                                ,    #selection_stamp_
    Union{TimeStamp,Nothing}[]                                                ,    #modification_stamp_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],           #trait_
    Bool[],                                                                #selected_
    Union{Base.RefValue{DataFrameSystem}, Nothing}[]
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
    :dfs
]

const system_types = [
    Union{String,Nothing}[],                  #name_
    Union{Int64,Nothing}[],                   #number_of_children_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],           #first_child_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],           #last_child_
    Vector{Tuple{Symbol,Any}}[],            #properties_
    Union{Bool,Nothing}[],                    #contains_selection_
    Union{Int64,Nothing}[],                   #number_of_selected_children_
    Union{Int64,Nothing}[],                   #number_of_children_containing_selection_
    Union{TimeStamp,Nothing}[],               #selection_stamp_
    Union{TimeStamp,Nothing}[],               #modification_stamp_
    Union{Base.RefValue{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}}, Nothing}[],           #trait_
    Bool[],                                   #selected_
    Union{Base.RefValue{DataFrameSystem}, Nothing}[]          #dataframesystem_
]


Base.show(io::IO, dfs::DataFrameSystem) = begin
    show(io, "systems : " ,dfs.systems)
    show(io, "chains  : " ,dfs.chains)
    show(io, "residues: " ,dfs.residues)
    show(io, "atoms   : " ,dfs.atoms)
    show(io, "bonds   : " ,dfs.bonds)
end

Base.show(dfs::DataFrameSystem) = begin
    show("systems : " ,dfs.systems)
    show("chains  : " ,dfs.chains)
    show("residues: " ,dfs.residues)
    show("atoms   : " ,dfs.atoms)
    show("bonds   : " ,dfs.bonds)
end 

Base.display(dfs::DataFrameSystem) = begin
    display(dfs.systems)
    display(dfs.chains)
    display(dfs.residues)
    display(dfs.atoms)
    display(dfs.bonds)
end 

"""
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
"""


insert_systems_into_dfs(input_sys::AbstractSystem, systems_df::DataFrame, dfs::DataFrameSystem) = begin
    @inbounds for sys in collectSystems(input_sys)
        push!(systems_df,  ( sys[:name_], sys[:number_of_children_], nothing, nothing,
                                    sys[:properties_], sys[:contains_selection_],
                                    sys[:number_of_selected_children_],
                                    sys[:number_of_children_containing_selection_],
                                    sys[:selection_stamp_], sys[:modification_stamp_],
                                    sys[:trait_], sys[:selected_],
                                    Base.RefValue{DataFrameSystem}(dfs)
                            )
        )
    end
end


insert_chains_into_dfs(systems_df::DataFrame, chains_df::DataFrame, input_sys::AbstractSystem, dfs::DataFrameSystem) = begin
    #insert chains into DFS and set the correct references to parents, children etc.
    @inbounds for (sys_df_row, comp_sys) in zip(eachrow(systems_df), collectSystems(input_sys))
        for chain in getChildren(comp_sys)::Vector{Chain}
            push!(chains_df,  ( chain[:id_], chain[:number_of_children_], Ref(sys_df_row),
                                        nothing, nothing, chain[:properties_],
                                        chain[:contains_selection_],
                                        chain[:number_of_selected_children_],
                                        chain[:number_of_children_containing_selection_],
                                        chain[:selection_stamp_], chain[:modification_stamp_],
                                        chain[:trait_], chain[:selected_],
                                        Base.RefValue{DataFrameSystem}(dfs)
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

insert_residues_into_dfs(chains_df::DataFrame, residues_df::DataFrame, input_sys::AbstractSystem, dfs::DataFrameSystem) = begin
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
                                        residue[:is_hetero_],       residue[:selected_],
                                        Base.RefValue{DataFrameSystem}(dfs)

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

insert_atoms_into_dfs(residues_df::DataFrame, atoms_df::DataFrame, input_sys::AbstractSystem, dfs::DataFrameSystem) = begin
    @inbounds for (res_df_row, comp_res) in zip(eachrow(residues_df), collectResidues(input_sys))
        for atom in getChildren(comp_res)::Vector{Atom}
            push!(atoms_df,  ( atom[:name_], Ref(res_df_row), atom[:type_name_],
                                        atom[:element_],        atom[:radius_], atom[:type_],
                                        atom[:number_of_bonds_],atom[:formal_charge_],
                                        atom[:position_],       atom[:charge_], atom[:velocity_],
                                        atom[:force_],          atom[:occupancy_], atom[:serial_],
                                        atom[:temp_factor_],    atom[:selected_],
                                        Ref(Vector{DataFrames.DataFrameRow}()),         atom[:properties_],
                                        Base.RefValue{DataFrameSystem}(dfs)
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

insert_bonds_into_dfs(atoms_df::DataFrame, bonds_df::DataFrame, input_sys::AbstractSystem) = begin
    for comp_bond in viewBonds(input_sys)
        source_atom_serial::Int64 = comp_bond.source_.serial_
        target_atom_serial::Int64 = comp_bond.target_.serial_

        df_bond::DataFrames.DataFrameRow = last(
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
DataFrameSystem()

Constructs an empty [`DataFrameSystem`](@ref). The `BioFrames` will have typed Colums and no rows.
"""
DataFrameSystem() = begin
    DataFrameSystem(SystemDF(Pair.(system_names, system_types)), ChainDF(Pair.(chain_names, chain_types)),
                        ResidueDF(Pair.(residue_names, residue_types)), AtomDF(Pair.(atom_names,atom_types)),
                        BondDF(Pair.(bond_names,bond_types)))
end


"""
    DataFrameSystem(input_sys::System)

Constructs a [`DataFrameSystem`](@ref) out of a System. The `DataFrames` will have the same fields
and types as the objects in the tree of composites rooted in `input_sys`.
"""
DataFrameSystem(input_sys::T where T<:AbstractSystem)  = begin

    dfs::DataFrameSystem = DataFrameSystem()
    systems_df =    getfield(dfs.systems,:df)
    chains_df =     getfield(dfs.chains,:df)
    residues_df =   getfield(dfs.residues,:df)
    atoms_df =      getfield(dfs.atoms,:df)
    bonds_df =      getfield(dfs.bonds,:df)

    insert_systems_into_dfs(input_sys, systems_df, dfs)

    insert_chains_into_dfs(systems_df, chains_df, input_sys, dfs)

    insert_residues_into_dfs(chains_df, residues_df, input_sys, dfs)

    insert_atoms_into_dfs(residues_df, atoms_df, input_sys,dfs)

    insert_bonds_into_dfs(atoms_df, bonds_df, input_sys)


    return dfs
end



"""
    Base.iterate(x::T) where T <: AbstractDataFrame
In BALL.jl the standard behaviour of `DataFrames` is overridden; instead of throwing an error, now
`iterate` and the for loop now invoke `eachrow(df)` which iterates over all rows.
"""
#DEPRECATED for now
#Type checking functions
"""
    is_atom_df(df::Union{AbstractDataFrame,DataFrameRow})
Checks if `df` is an atom or an atom `DataFrame`.
"""
#is_atom_df(df::Union{AbstractDataFrame,DataFrameRow}) = begin
#    return length(getfield(df, :colindex)) == 18  #atom df has 18 columns
#end

"""
    is_residue_df(df::Union{AbstractDataFrame,DataFrameRow})
Checks if `df` is a residue or an residue `DataFrame`.
"""
#is_residue_df(df::Union{AbstractDataFrame,DataFrameRow}) = begin
#    return length(getfield(df, :colindex)) == 17  #res df has 17 columns
#end

"""
    is_chain_df(df::Union{AbstractDataFrame,DataFrameRow})
Checks if `df` is a chain or a chain `DataFrame`.
"""
#is_chain_df(df::Union{AbstractDataFrame,DataFrameRow}) = begin
#    return first(propertynames(df)) == :id_
#end

"""
    is_system_df(df::Union{AbstractDataFrame,DataFrameRow})
Checks if `df` is a system or a system `DataFrame`.
"""
#is_system_df(df::Union{AbstractDataFrame,DataFrameRow}) = begin
#    return !is_chain_df(df) && length(getfield(df, :colindex)) == 13
#end