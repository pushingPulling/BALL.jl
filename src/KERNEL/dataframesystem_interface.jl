export prev, next, firstChild, lastChild, coords
import Base: length, getindex
import ..CONCEPT: removeChild

getindex(dfr::DataFrames.DataFrameRow) = getindex(DataFrames.DataFramesRow)
Base.iterate(x::T) where T <: AbstractDataFrame = begin a = Base.Iterators.Stateful(eachrow(x)); (popfirst!(a), a) end
Base.iterate(::T, s::Base.Iterators.Stateful{DataFrames.DataFrameRows{T}, Union{Nothing, Tuple{DataFrames.DataFrameRow{DataFrame, DataFrames.Index}, Tuple{Base.OneTo{Int64}, Int64}}}}) where T <: AbstractDataFrame =!isnothing(s.nextvalstate) ? (popfirst!(s),s) : nothing


getChildren(dfr::DFR) = begin
    propertynames(dfr)[2] == :parent_ && return nothing
    target_df::DataFrame = getfield(getFirstChild(dfr), :df)
    first_child_idx::Int = getfield(getFirstChild(dfr), :dfrow)
    last_child_idx::Int = getfield(getLastChild(dfr), :dfrow)
    return eachrow(target_df[first_child_idx:last_child_idx, :])
end


getNext(dfr::DFR) = begin
    target_df::DataFrame = getfield(dfr, :df)
    idx::Int64 = getfield(dfr, :dfrow) + 1
    return @view target_df[idx,:]
end

getPrev(dfr::DFR) = begin
    target_df::DataFrame = getfield(dfr, :df)
    idx::Int64 = getfield(dfr, :dfrow) - 1
    return @view target_df[idx,:]
end

getSource(dfr::DFR) = dfr[:source_][]
getTarget(dfr::DFR) = dfr[:target_][]

getParent(dfr::DFR) = isnothing(dfr[:parent_]) ? nothing : dfr[:parent_][]
getBonds(dfr::DFR) = isnothing(dfr[:bonds_]) ? nothing : dfr[:bonds_][]

getFirstChild(dfr::DFR) = isnothing(dfr[:first_child_]) ? nothing : dfr[:first_child_][]::DataFrameRow
getLastChild(dfr::DFR) = isnothing(dfr[:last_child_]) ? nothing : dfr[:last_child_][]::DataFrameRow

getTrait(dfr::DFR) = isnothing(dfr[:trait_]) ? nothing : dfr[:trait_][]

isHetero(dfr::DFR) = dfr.is_hetero_

setProperty(dfr::DFR, property::Tuple{String,UInt8}) = begin
    push!(dfr[:properties_], property)
end

hasProperty(dfr::DFR, property::Tuple{String,UInt8}) = begin
    return property in dfr[:properties_]
end

hasProperty(dfr::DFR, property::String) = begin
    for prop in dfr[:properties_]
        if prop[1] == property
            return true
        end
    return false
    end
end

setProperty(dfr::DFR, property::Tuple{String,Bool}) = setProperty(dfr,(property[1],UInt8(property[2])))

Base.show(io::IO, refrow::Base.RefValue{DFR{DataFrame, DataFrames.Index}}) =
    show(io, getfield(refrow[], :dfrow))

Base.show(io::IO, refrows::Base.RefValue{Vector{DataFrameRow}}) = show(io,refrows[])

"""
    countAtoms(dfs::DataFrameSystem)
Returns the number of `Atom`s in the `DataFrameSystem`.
"""
countAtoms(dfs::DataFrameSystem) = nrow(dfs.atoms)

"""
    countChains(dfs::DataFrameSystem)
Returns the number of `Chain`s in the `DataFrameSystem`.
"""
countChains(dfs::DataFrameSystem) = nrow(dfs.chains)

"""
    countResidues(dfs::DataFrameSystem)
Returns the number of `Residue`s in the `DataFrameSystem`.
"""
countResidues(dfs::DataFrameSystem) = nrow(dfs.residues)


"""
    countSystems(dfs::DataFrameSystem)
Returns the number of `System`s in the `DataFrameSystem`.
"""
countSystems(dfs::DataFrameSystem) = nrow(dfs.systems)

countAtoms(dfr::DFR) = begin
    return length(eachAtom(dfr))
end


"""
    collectAtoms(dfs::DataFrameSystem) -> Vector{Atom}
Collects (copies of) all the atoms in a `DataFrameSystem`.
"""
collectAtoms(dfs::DataFrameSystem) = begin
    return dfs.atoms
end


"""
    countBonds(dfs::DataFrameSystem)
Returns the number of `Bond`s in the `DataFrameSystem`.
"""
countBonds(dfs::DataFrameSystem) = nrow(dfs.bonds)

"""
    eachBond(::DataFrameSystem)
Returns an iterator of all bonds in the `DataFrameSystem`.
"""
eachBond(dfs::DataFrameSystem) = eachrow(dfs.bonds)

"""
    eachAtom(::DataFrameSystem)
Returns an iterator of all atoms in the `DataFrameSystem`.
"""
eachAtom(dfs::DataFrameSystem) = begin
    return eachrow(dfs.atoms)
end



"""
    collectResidues(dfs::DataFrameSystem)
Collects all the residues in a `DataFrameSystem`.
"""
collectResidues(dfs::DataFrameSystem) = begin
    return dfs.residues
end

"""
    eachResidue(::DataFrameSystem)
Returns an iterator of all Residues in the `DataFrameSystem`.
"""
eachResidue(dfs::DataFrameSystem) = begin
    return eachrow(dfs.residues)
end

"""
    collectChains(dfs::DataFrameSystem)
Collects all the chains in a `DataFrameSystem`.
"""
collectChains(dfs::DataFrameSystem) = begin
    return dfs.chains
end

"""
    eachChain(::DataFrameSystem)
Returns an iterator of all chains in the `DataFrameSystem`.
"""
eachChain(dfs::DataFrameSystem) = begin
    return eachrow(dfs.chains)
end




"""
    eachSystem(::DataFrameSystem)
Returns an iterator of all systems in the `DataFrameSystem`.
"""
eachSystem(dfs::DataFrameSystem) = begin
    return dfs.system
end


"""
    getFirstSystem(dfs::DataFrameSystem)
Returns the first System in the `dfs`.
"""
getFirstSystem(dfs::DataFrameSystem) = first(dfs.systems)


"""
    getFirstChain(dfs::DataFrameSystem)
Returns the first Chain in the `dfs`.
"""
getFirstChain(dfs::DataFrameSystem) = first(dfs.chains)


"""
    getFirstResidue(dfs::DataFrameSystem)
Returns the first Residue in the `dfs`.
"""
getFirstResidue(dfs::DataFrameSystem) = first(dfs.residue)


"""
    getFirstAtom(dfs::DataFrameSystem)
Returns the first Atom in the `dfs`.
"""
getFirstAtom(dfs::DataFrameSystem) = first(dfs.atoms)

#useful short definitions

next(dfr::DFR) = getNext(dfr)
prev(dfr::DFR) = getPrev(dfr)
firstChild(dfr::DFR) = getFirstChild(dfr)
lastChild(dfr::DFR) = getLastChild(dfr)
coords(dfr::DFR) = dfr.position_
length(df::DataFrame) = nrow(df)
getindex(df::AbstractDataFrame, idx::Int) = @view df[idx,:]


"""
    isDescendantOf(this::DFR, other::DFR)
Checks if `other` is a descendant of `this`.
"""
isDescendantOf(this::DFR,other::DFR) = begin
   this == other && return false
   while(this != other)
       if !is_system_df(this)
           this = getParent(this)
       else
           return false
       end
   end
   return true
end



"""
    merge(sdfs::SubDataFrame...)
Returns a `SubDataFrame` of the rows in the sdfs, removing duplicate rows.

This only works if the sdfs are all referencing the same parent `DataFrame`
"""
merge(sdfs::SubDataFrame...) = begin
   rows = Set{Int}(collect(Iterators.flatten(getfield.(sdfs,:rows))))
   return SubDataFrame(getfield(sdfs[1],:parent), collect(rows),:)
end

"""
    vcat(sdfs::SubDataFrame...)
Concatenates `SubDataFrame`s along the vertical axis.

This only works if the sdfs are all referencing the same parent `DataFrame`.
"""
vcat(sdfs::SubDataFrame...) = begin
   rows = collect(Iterators.flatten(getfield.(sdfs,:rows)))
   return SubDataFrame(getfield(sdfs[1],:parent), collect(rows),:)
end


"""
    viewChildren(dfr::DataFrameRow)
Returns a view of the childern of a `DataFrameRow`.
"""
viewChildren(dfr::DFR) = begin
    propertynames(dfr)[2] == :parent_ && return nothing
    first_child::DataFrameRow = getFirstChild(dfr)
    target_df::DataFrame = getfield(first_child, :df)
    first_child_idx::Int = getfield(first_child, :dfrow)
    last_child_idx::Int = getfield(getLastChild(dfr)::DataFrameRow, :dfrow)
    return @view target_df[first_child_idx:last_child_idx, :]
end

"""
    collectChildren(dfr::DataFrameRow)
Returns a copy of the childern of a `DataFrameRow`.
"""
collectChildren(dfr::DFR) = begin
    propertynames(dfr)[2] == :parent_ && return nothing
    first_child::DataFrameRow = getFirstChild(dfr)
    target_df::DataFrame = getfield(first_child, :df)
    first_child_idx::Int = getfield(first_child, :dfrow)
    last_child_idx::Int = getfield(getLastChild(dfr)::DataFrameRow, :dfrow)
    return target_df[first_child_idx:last_child_idx, :]
end


"""
    collectAtoms(df::DataFrameRow)
Returns a `DataFrame` of all atoms that are descendants of `df`
"""
collectAtoms(df::DFR) = begin

    if is_residue_df(df)
        return collectChildren(df)
    end

    if is_chain_df(df)
        return vcat(collectChildren.(eachrow(collectChildren(df)))...)
    end


    if is_system_df(df)
        chains = collectChildren(df)
        residues = vcat(eachrow.(collectChildren.(eachrow(chains)))...)
        return vcat(collectChildren.(residues)...)
    end

end


"""
    collectResidues(df::DataFrameRow)
Returns a `DataFrame` of all residues that are descendants of `df`
"""
collectResidues(df::DFR) = begin


    if is_chain_df(df)
        return collectChildren(df)
    end


    if is_system_df(df)
        return vcat( collectChildren.(eachrow(collectChildren(df))) ...)
    end

end

"""
    collectChains(df::DataFrameRow)
Returns a `DataFrame` of all Chains that are descendants of `df`
"""
collectChains(df::DFR) = begin
    if is_system_df(df)
        return collectChildren(df)
    end
end

collectSystems(dfs::DataFrameSystem) = copy(dfs.systems)


"""
    viewAtoms(df::DataFrameRow)
Returns a `SubDataFrame` of all atoms that are descendants of `df`
"""
viewAtoms(df::DFR) = begin
    if is_residue_df(df)
        return viewChildren(df)
    end

    if is_chain_df(df)
        return vcat(viewChildren.(eachrow(viewChildren(df)))...)
    end

    if is_system_df(df)
        chains = viewChildren(df)
        residues = vcat(viewChildren.(eachrow(chains))...)
        return vcat(viewChildren.(eachrow(residues))...)
    end
end


"""
    viewResidues(df::DataFrameRow)
Returns a `SubDataFrame` of all residues that are descendants of `df`
"""
viewResidues(df::DFR) = begin


    if is_chain_df(df)
        return viewChildren(df)
    end


    if is_system_df(df)
        return vcat( collectChildren.(eachrow(viewChildren(df))) ...)
    end

end

"""
    viewChains(df::DataFrameRow)
Returns a `SubDataFrame` of all Chains that are descendants of `df`
"""
viewChains(df::DFR) = begin
    if is_system_df(df)
        return viewChildren(df)
    end
end

viewSystems(dfs::DataFrameSystem) = dfs.systems


countBonds(dfr::DFR) = length(eachBond(dfr))

eachResidue(df::AbstractDataFrame) = begin
    residues = DataFrameRow[]

    if is_chain_df(df)
        for chain in eachrow(df)
            push!(residues, getChildren(chain)...)
        end
        return residues
    end


    if is_system_df(df)
        for system in eachrow(df)
            for chain in getChildren(system)
                push!(residues, getChildren(chain)...)
            end
        end
        return residues
    end
end

eachChain(df::AbstractDataFrame) = begin
    chains = DataFrameRow[]
    if is_system_df(df)
        for system in eachrow(df)
            push!(chains, getChildren(system)...)
        end
        return chains
    end
end

eachAtom(dfr::DFR) = begin
    if is_system_dfr(dfr)
        temp_chains = getChildren(dfr)
        temp_residues = DataFrameRow[]
        for chain in temp_chains
            push!(temp_residues, getChildren(chain)...)
        end
        atoms = DataFrameRow[]
        for child in temp_residues
            push!(atoms, getChildren(child)...)
        end

        return atoms
    end

    if is_chain_dfr(dfr)
        temp_residues = getChildren(dfr)
        atoms = DataFrameRow[]
        for child in temp_residues
            push!(atoms, getChildren(child)...)
        end

        return atoms
    end

    # if residue row get all children of row
    if is_residue_dfr(dfr)
        return getChildren(dfr)
    end

    return []
end

is_atom_dfr(df::DFR) = begin
    return length(getfield(df, :colindex)) == 18  #atom df has 18 columns
end

is_residue_dfr(df::DFR) = begin
    return length(getfield(df, :colindex)) == 17  #res df has 17 columns
end

is_chain_dfr(df::DFR) = begin
    return first(propertynames(df)) == :id_
end

is_system_dfr(df::DFR) = begin
    return !is_chain_dfr(df) && length(getfield(df, :colindex)) == 13
end

"""
    sequentialResidues(res::Union{DFR,AbstractResidue}, res_next::Union{DFR,AbstractResidue})
Returns true if `res` comes before `res_next` in the same Chain and if both are hetero/non-hetero residues.
"""
sequentialResidues(res::Union{DFR,AbstractResidue}, res_next::Union{DFR,AbstractResidue}) = begin
    return getParent(res) == getParent(res_next) &&
            isHetero(res) == isHetero(res_next) &&
            getNext(res) == res_next
end


removeChild(root::DFR, child_node::DFR) = begin
    if root == child_node || getParent(child_node) != root
        return false
    end

    #if child has no parent, we cannot remove it
    if isnothing(child_node.parent_)
        return false
    end

    #remove child from the list of children
    if root.first_child_ == child_node
        if root.last_child == child_node
            root.last_child_ = root.last_child_ = nothing
        end
        
        root.first_child_ = Ref(next(child_node))
    
    end   

    if root.last_child_ == child_node
        root.last_child_ = Ref(prev(child_node))
    end

    if is_atom_dfr(child_node)
        #must remove bonds that are adjacent to the atom we want to delete
        inds = getfield.(child_node.bonds_[], :dfrow)
        deleteat!(getDFS(child_node).bonds, inds)
    end

    deleteat!(root, getfield(child_node, :dfrow))

    return true
end

