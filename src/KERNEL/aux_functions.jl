import Base: show, <, >, ==, findall
export DataFrameSystem, countAtoms, countResidues, countChains,countSystems, collectAtoms,
    collectResidues, collectChains, collectBonds, findfirst, findall, collectSystems, countBonds,
    viewSystems, viewChains, viewResidues, viewAtoms, eachAtom, eachResidue, eachChain, eachSystem



"""
    countBonds(node::CompositeInterface)
Returns the number of `Bond`s in the subtree rooted in `node`.
"""
countBonds(node::CompositeInterface) = begin
    count::Int = 0
    for at in collectAtoms(node)
        count += length(getBonds(at))
    end
    return count
end

"""
    countBonds(dfs::DataFrameSystem)
Returns the number of `Bond`s in the `DataFrameSystem`.
"""
countBonds(dfs::DataFrameSystem) = length(dfs.bonds)



"""
    countAtoms(node::CompositeInterface)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countAtoms(node::CompositeInterface) = begin
    recursive_count(node, Atom)
end

"""
    countAtoms(dfs::DataFrameSystem)
Returns the number of `Atom`s in the `DataFrameSystem`.
"""
countAtoms(dfs::DataFrameSystem) = length(dfs.atoms)


"""
    countResidues(node::CompositeInterface)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countResidues(node::CompositeInterface) = begin
    recursive_count(node, Residue)
end

"""
    countResidues(dfs::DataFrameSystem)
Returns the number of `Residue`s in the `DataFrameSystem`.
"""
countResidues(dfs::DataFrameSystem) = length(dfs.residues)


"""
    countChains(node::CompositeInterface)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countChains(node::CompositeInterface) = begin
    recursive_count(node, Chain)
end

"""
    countChains(dfs::DataFrameSystem)
Returns the number of `Chain`s in the `DataFrameSystem`.
"""
countChains(dfs::DataFrameSystem) = length(dfs.chains)


"""
    countSystems(node::CompositeInterface)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countSystems(node::CompositeInterface) = begin
    recursive_count(node, System)
end

"""
    countSystems(dfs::DataFrameSystem)
Returns the number of `System`s in the `DataFrameSystem`.
"""
countSystems(dfs::DataFrameSystem) = length(dfs.systems)




"""
    collectAtoms(dfs::DataFrameSystem) -> Vector{Atom}
Collects (copies) all the atoms in a `DataFrameSystem`.
"""
collectAtoms(dfs::DataFrameSystem) = begin
    return dfs[:,:atoms]
end

"""
    eachAtom(node::CompositeInterface)
Returns an iterator of all `Atom`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachAtom(node::CompositeInterface) = begin
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
    return dfs[:,:residue]
end


"""
    collectResidues(node::CompositeInterface, selector::Function)
Collects all the `Residue`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectResidues(node::CompositeInterface, selector::Function) = begin
    filter!(selector, collectResidues(node))
end

"""
    eachResidue(node::CompositeInterface)
Collects a the `Residue`s of the subtree rooted in `node`. See [`collectResidues`](@ref)
"""
viewResidues(node::CompositeInterface) = begin
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
    collectChains(node::CompositeInterface, selector::Function)
Collects all the `Chain`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectChains(node::CompositeInterface, selector::Function) = begin
    filter!(selector, collectChains(node))
end

"""
    collectChains(dfs::DataFrameSystem)
Collects all the chains in a `DataFrameSystem`.
"""
collectChains(dfs::DataFrameSystem) = begin
    return dfs[:,:chain]
end

"""
    eachChain(node::CompositeInterface)
Returns an iterator of all `Chain`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachChain(node::CompositeInterface) = begin
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
    collectSystems(node::CompositeInterface, selector::Function)
Collects all the `System`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectSystems(node::CompositeInterface, selector::Function) = begin
    filter!(selector, collectSystems(node))
end

"""
    collectSystems(dfs::DataFrameSystem)
Collects all the systems in a `DataFrameSystem`.
"""
collectSystems(dfs::DataFrameSystem) = begin
    return dfs[:,:system]
end


"""
    eachSystem(node::CompositeInterface)
Returns an iterator of all `System`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachSystem(node::CompositeInterface) = begin
    return collectSystems(node)
end

"""
    eachSystem(::DataFrameSystem)
Returns an iterator of all systems in the `DataFrameSystem`.
"""
eachSystem(dfs::DataFrameSystem) = begin
    return dfs.system
end



Base.show(io::IO, comp::CompositeInterface) = print(io, typeof(comp)," \"",getName(comp), "\" with ",
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
const kerneltype = [[Atom,AtomInterface],[Residue,ResidueInterface],[Chain,ChainInterface],
                    [SystemInterface,System]]
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
    findfirst(start_node::CompositeInterface,target_type::Type{T}, chain_attributes=(),
        residue_attributes=(), atom_attributes=()) where T<:CompositeInterface
Finds the first node for which all the attributes in the `Named Tuple`s apply.
Omitting Tuples causes the function to stop early.
"""
findfirst(start_node::CompositeInterface,target_type::Type{T}, chain_attributes=(),
        residue_attributes=(), atom_attributes=()) where T<:CompositeInterface = begin

    target_type > Chain && return nothing
    cur_node::CompositeInterface = start_node

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

Base.getindex(x::CompositeInterface,sy::Core.Symbol) = Base.getfield(x,sy)
Base.getindex(x::Bond, sy::Core.Symbol) = Base.getfield(x,sy)
Base.getindex(x::System, i::Int) = collectChains(x)[i]
Base.getindex(x::Residue, i::Int) = collectResidues(x)[i]
Base.getindex(x::Chain, i::Int) = collectAtoms(x)[i]
"""
    Base.getindex(vec_chain::Vector{Chain}, id::String)
Idiomatic way to get a `Chain` by name.
"""
Base.getindex(vec_chain::Vector{Chain}, id::String) = Base.getindex(vec_chain, only(id))
Base.getindex(vec_chain::Vector{Chain}, id::Char) =  vec_chain[findfirst(x->x.id_ == id, vec_chain)]


##DEPRECATED
findall(start_node::CompositeInterface,target_type::Type{T}, chain_attributes=(),
        residue_attributes=(), atom_attributes=()) where T<:CompositeInterface = begin

    target_type > Chain && return start_node

    result = target_type[]
    cur_node::CompositeInterface = start_node

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

