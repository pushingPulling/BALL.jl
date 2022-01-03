import Base: show, <, >, ==, findall
import ..CONCEPT: appendSibling
export DataFrameSystem, countAtoms, countResidues, countChains,countSystems, collectAtoms,
    collectResidues, collectChains, collectBonds, findfirst, findall, collectSystems, countBonds,
    viewSystems, viewChains, viewResidues, viewAtoms, eachAtom, eachResidue, eachChain, eachSystem,
    eachBond, sequentialResidues, is_atom_dfr, is_residue_dfr, is_chain_dfr, is_system_dfr,
    is_atom_df, is_residue_df, is_chain_df, is_system_df


const DFR = DataFrameRow

# because a dataframerow from a dataframes/subdataframes has the same column indices, these functions
# work on any AbstractDataFrame

is_atom_dfr(df::DataFrameRow) = begin
    return length(getfield(df, :colindex)) == 18  #atom df has 18 columns
end

is_residue_dfr(df::DataFrameRow) = begin
    return length(getfield(df, :colindex)) == 17  #res df has 17 columns
end

is_chain_dfr(df::DataFrameRow) = begin
    return first(propertynames(df)) == :id_
end

is_system_dfr(df::DataFrameRow) = begin
    return !is_chain_dfr(df) && length(getfield(df, :colindex)) == 13
end

is_atom_df(df::AbstractDataFrame) = begin
    return length(getfield(df, :colindex)) == 18  #atom df has 18 columns
end

#---

is_residue_df(df::AbstractDataFrame) = begin
    return length(getfield(df, :colindex)) == 17  #res df has 17 columns
end

is_chain_df(df::AbstractDataFrame) = begin
    return first(propertynames(df)) == :id_
end

is_system_df(df::AbstractDataFrame) = begin
    return !is_chain_df(df) && length(getfield(df, :colindex)) == 13
end


"""
    countBonds(node::AbstractComposite)
Returns the number of `Bond`s in the subtree rooted in `node`.
"""
countBonds(node::AbstractComposite) = begin
    count::Int = 0
    for at in collectAtoms(node)
        count += length(getBonds(at))
    end
    return count
end




"""
    countAtoms(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countAtoms(node::AbstractComposite) = begin
    recursive_count(node, Atom)
end

"""
    countAtoms(dfs::DataFrameSystem)
Returns the number of `Atom`s in the `DataFrameSystem`.
"""
countAtoms(dfs::DataFrameSystem) = nrow(dfs.atoms)


"""
    countResidues(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countResidues(node::AbstractComposite) = begin
    recursive_count(node, Residue)
end

"""
    countResidues(dfs::DataFrameSystem)
Returns the number of `Residue`s in the `DataFrameSystem`.
"""
countResidues(dfs::DataFrameSystem) = nrow(dfs.residues)


"""
    countChains(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countChains(node::AbstractComposite) = begin
    recursive_count(node, Chain)
end

"""
    countChains(dfs::DataFrameSystem)
Returns the number of `Chain`s in the `DataFrameSystem`.
"""
countChains(dfs::DataFrameSystem) = nrow(dfs.chains)


"""
    countSystems(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countSystems(node::AbstractComposite) = begin
    recursive_count(node, System)
end

"""
    countSystems(dfs::DataFrameSystem)
Returns the number of `System`s in the `DataFrameSystem`.
"""
countSystems(dfs::DataFrameSystem) = nrow(dfs.systems)

countAtoms(dfr::DataFrameRow) = begin
    return length(eachAtom(dfr))
end





"""
    collectAtoms(dfs::DataFrameSystem) -> Vector{Atom}
Collects (copies of) all the atoms in a `DataFrameSystem`.
"""
collectAtoms(dfs::DataFrameSystem) = begin
    return dfs.atoms
end

eachAtom(df::AbstractDataFrame) = begin
    atoms = DataFrameRow[]

    if is_residue_df(df)
        for row in eachrow(df)
            push!(atoms, getChildren(row)...)
        end
        return atoms
    end

    if is_chain_df(df)
        for chain in eachrow(df)
            for res in getChildren(chain)
                push!(atoms, getChildren(res)...)
            end
        end
        return atoms
    end


    if is_system_df(df)
        for system in eachrow(df)
            for chain in getChildren(system)
                for res in getChildren(chain)
                    push!(atoms, getChildren(res)...)
                end
            end
        end
        return atoms
    end
end

collectAtoms(dfr::DataFrameRow) = begin
    return eachAtom()
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
    eachBond(::DataFrameSystem)
Returns an iterator of all bonds in the `comp`-tree.
"""
eachBond(comp::AbstractComposite) = collectBonds(comp)

eachBond(dfr::DataFrameRow) = begin
    result_set = Set{DataFrameRow}()
    for at in eachAtom(dfr)
        push!(result_set, getBonds(at)...)
    end
    return result_set
end

countBonds(dfr::DataFrameRow) = length(eachBond(dfr))

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

eachAtom(dfr::DataFrameRow) = begin
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

"""
    eachAtom(node::AbstractComposite)
Returns an iterator of all `Atom`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachAtom(node::AbstractComposite) = begin
    return collectAtoms(node)
end

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
    collectResidues(node::AbstractComposite, selector::Function)
Collects all the `Residue`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectResidues(node::AbstractComposite, selector::Function) = begin
    filter!(selector, collectResidues(node))
end

"""
    eachResidue(node::AbstractComposite)
Collects a the `Residue`s of the subtree rooted in `node`. See [`collectResidues`](@ref)
"""
viewResidues(node::AbstractComposite) = begin
    return collectResidues(node)
end

"""
    eachResidue(::DataFrameSystem)
Returns an iterator of all Residues in the `DataFrameSystem`.
"""
eachResidue(dfs::DataFrameSystem) = begin
    return eachrow(dfs.residues)
end



"""
    collectChains(node::AbstractComposite, selector::Function)
Collects all the `Chain`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectChains(node::AbstractComposite, selector::Function) = begin
    filter!(selector, collectChains(node))
end

"""
    collectChains(dfs::DataFrameSystem)
Collects all the chains in a `DataFrameSystem`.
"""
collectChains(dfs::DataFrameSystem) = begin
    return dfs.chains
end

"""
    eachChain(node::AbstractComposite)
Returns an iterator of all `Chain`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachChain(node::AbstractComposite) = begin
    return collectResidues(node)
end

"""
    eachChain(::DataFrameSystem)
Returns an iterator of all chains in the `DataFrameSystem`.
"""
eachChain(dfs::DataFrameSystem) = begin
    return eachrow(dfs.chains)
end




"""
    collectSystems(node::AbstractComposite, selector::Function)
Collects all the `System`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectSystems(node::AbstractComposite, selector::Function) = begin
    filter!(selector, collectSystems(node))
end

"""
    collectSystems(dfs::DataFrameSystem)
Collects all the systems in a `DataFrameSystem`.
"""
collectSystems(dfs::DataFrameSystem) = begin
    return dfs.systems
end


"""
    eachSystem(node::AbstractComposite)
Returns an iterator of all `System`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachSystem(node::AbstractComposite) = begin
    return collectSystems(node)
end

"""
    eachSystem(::DataFrameSystem)
Returns an iterator of all systems in the `DataFrameSystem`.
"""
eachSystem(dfs::DataFrameSystem) = begin
    return dfs.system
end



Base.show(io::IO, comp::AbstractComposite) = print(io, typeof(comp)," \"",getName(comp), "\" with ",
countChildren(comp), " child",countChildren(comp) == 1 ? "" : "ren", " containing ", countAtoms(comp)," Atoms")


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


const comparisonops = [:<,:>]
const kerneltype = [[Atom,AbstractAtom],[Residue,AbstractResidue],[Chain,AbstractChain],
                    [AbstractSystem,System]]
for x in kerneltype
    for y in kerneltype
        for op in comparisonops
            for x_type in x
                for y_type in y
                    @eval Base.$op(::Type{$x_type},::Type{$y_type}) =
                          (Base.$op(findfirst(lambda -> lambda == $x,$kerneltype),
                                   findfirst(lambda -> lambda == $y,$kerneltype)))
                end
            end

        end
    end
end

import Base.findfirst
"""
    findfirst(start_node::AbstractComposite,target_type::Type{T}, chain_attributes=(),
        residue_attributes=(), atom_attributes=()) where T<:AbstractComposite
Finds the first node for which all the attributes in the `Named Tuple`s apply.
Omitting Tuples causes the function to stop early.
"""
findfirst(start_node::AbstractComposite,target_type::Type{T}, chain_attributes=(),
        residue_attributes=(), atom_attributes=()) where T<:AbstractComposite = begin

    target_type > Chain && return nothing
    cur_node::AbstractComposite = start_node

    if typeof(cur_node) > Chain && !isempty(chain_attributes)
        for ch in collectChains(cur_node)
            if all([ch[attr] == value for (attr,value) in pairs(chain_attributes)])
                cur_node = ch
                break
            end
        end
    end

    target_type > Residue && return nothing

    if typeof(cur_node) > Residue && !isempty(residue_attributes)
        for res in collectResidues(cur_node)
            if all([res[attr] == value for (attr,value) in pairs(residue_attributes)])
                cur_node = res
                break
            end
        end
    end

    target_type > Atom && return nothing

    if typeof(cur_node) > Atom && !isempty(atom_attributes)
        for at in collectAtoms(cur_node)
            if all([at[attr] == value for (attr,value) in pairs(atom_attributes)])
                cur_node = at
                break
            end
        end
    end

    cur_node == start_node && return nothing
    return cur_node
end

import Base.getindex

Base.getindex(x::AbstractComposite,sy::Core.Symbol) = Base.getfield(x,sy)
Base.getindex(x::Atom,sy::Core.Symbol) = Base.getfield(x,sy)
Base.getindex(x::Bond, sy::Core.Symbol) = Base.getfield(x,sy)
Base.getindex(x::System, i::Int) = collectChains(x)[i]
Base.getindex(x::System, c::Char) = Base.getindex(x, Int(c- 'A') + 1)
Base.getindex(x::Residue, i::Int) = collectResidues(x)[i]
Base.getindex(x::Chain, i::Int) = collectAtoms(x)[i]
"""
    Base.getindex(vec_chain::Vector{Chain}, id::String)
Idiomatic way to get a `Chain` by name.
"""
Base.getindex(vec_chain::Vector{Chain}, id::String) = Base.getindex(vec_chain, only(id))
Base.getindex(vec_chain::Vector{Chain}, id::Char) =  vec_chain[findfirst(x->x.id_ == id, vec_chain)]


##DEPRECATED
findall(start_node::AbstractComposite,target_type::Type{T}, chain_attributes=(),
        residue_attributes=(), atom_attributes=()) where T<:AbstractComposite = begin

    target_type > Chain && return start_node

    result = target_type[]
    cur_node::AbstractComposite = start_node

    if typeof(cur_node) > Chain && !isempty(chain_attributes)
        for ch in collectChains(cur_node)
            if all([ch[attr] == value for (attr,value) in pairs(chain_attributes)])
                cur_node = ch
                if target_type == Chain
                    push!(result,ch)
                end
                break
            end
        end
    end

    if target_type > Residue
        if cur_node == start_node
            return nothing
        else
            return result
        end
    end

    if typeof(cur_node) > Residue && !isempty(residue_attributes)
        for res in collectResidues(cur_node)
            if all([res[attr] == value for (attr,value) in pairs(residue_attributes)])
                cur_node = res
                if target_type == Residue
                    push!(result,res)
                end
                break
            end
        end
    end

    if target_type > Atom
        if cur_node == start_node
            return nothing
        else
            return result
        end
    end

    if typeof(cur_node) > Atom && !isempty(atom_attributes)
        for at in collectAtoms(cur_node)
            if all([at[attr] == value for (attr,value) in pairs(atom_attributes)])
                cur_node = at
                if target_type == Atom
                    push!(result,at)
                end
                break
            end
        end
    end

    cur_node == start_node && return nothing
    return result

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