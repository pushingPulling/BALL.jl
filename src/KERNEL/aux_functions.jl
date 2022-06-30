import Base: show, <, >, ==, findall
import ..CONCEPT: appendSibling
export countAtoms, countResidues, countChains,countSystems, collectAtoms,
    collectResidues, collectChains, collectBonds, findfirst, findall, collectSystems, countBonds,
    viewSystems, viewChains, viewResidues, viewAtoms, eachAtom, eachResidue, eachChain, eachSystem,
    eachBond, sequentialResidues, is_atom_dfr, is_residue_dfr, is_chain_dfr, is_system_dfr,
    is_atom_df, is_residue_df, is_chain_df, is_system_df







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
    countResidues(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countResidues(node::AbstractComposite) = begin
    recursive_count(node, Residue)
end

"""
    countChains(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countChains(node::AbstractComposite) = begin
    recursive_count(node, Chain)
end

"""
    countSystems(node::AbstractComposite)
Counts the `Atom`s in the subtree rooted in `node`.
"""
countSystems(node::AbstractComposite) = begin
    recursive_count(node, System)
end

"""
    eachAtom(node::AbstractComposite)
Returns an iterator of all `Atom`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachAtom(node::AbstractComposite) = begin
    return collectAtoms(node)
end

"""
    eachBond(::AbstractComposite)
Returns an iterator of all bonds in the `comp`-tree.
"""
eachBond(comp::AbstractComposite) = collectBonds(comp)

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
    collectChains(node::AbstractComposite, selector::Function)
Collects all the `Chain`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectChains(node::AbstractComposite, selector::Function) = begin
    filter!(selector, collectChains(node))
end

"""
    eachChain(node::AbstractComposite)
Returns an iterator of all `Chain`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachChain(node::AbstractComposite) = begin
    return collectResidues(node)
end

"""
    collectSystems(node::AbstractComposite, selector::Function)
Collects all the `System`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectSystems(node::AbstractComposite, selector::Function) = begin
    filter!(selector, collectSystems(node))
end

"""
    eachSystem(node::AbstractComposite)
Returns an iterator of all `System`s of the subtree rooted in `node`. See [`collectAtoms`](@ref)
"""
eachSystem(node::AbstractComposite) = begin
    return collectSystems(node)
end

Base.show(io::IO, comp::AbstractComposite) = print(io, typeof(comp)," \"",getName(comp), "\" with ",
countChildren(comp), " child",countChildren(comp) == 1 ? "" : "ren", " containing ", countAtoms(comp)," Atoms")

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

