import Base: show, <, >, findall
export DataFrameSystem, countAtoms, collectAtoms, collectResidues, collectChains, collectBonds, findfirst, findall

"""
    countAtoms(node::CompositeInterface)
Counts all the atoms in the Subtree rooted at `node`.
"""
countAtoms(node::CompositeInterface) = begin
    number_of_atoms::Int64 = 0
    if isnothing(node.first_child_)
        if isa(node,Atom)
            return 1
        else
            return 0
        end
    end

    cur = node.first_child_
    number_of_atoms += countAtoms(cur)
    while !isnothing(cur.next_)
        number_of_atoms += countAtoms(cur.next_)
        cur = cur.next_
    end
    return number_of_atoms
end

"""
    collectAtoms(node::CompositeInterface)
Collects all the `Atom`s of the subtree rooted in `node`.
"""
collectAtoms(node::CompositeInterface) = begin
    recursive_collect(node,Atom)
end

"""
    collectAtoms(node::CompositeInterface, selector::Function)
Collects all the `Atom`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectAtoms(node::CompositeInterface, selector::Function) = begin
    filter!(selector, collectAtoms(node))
end


"""
    collectResidue(node::CompositeInterface)
Collects all the `Residue`s of the subtree rooted in `node`.
"""
collectResidues(node::CompositeInterface) = begin
    recursive_collect(node,Residue)
end

"""
    collectResidues(node::CompositeInterface, selector::Function)
Collects all the `Residue`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectResidues(node::CompositeInterface, selector::Function) = begin
    filter!(selector, collectResidues(node))
end


"""
    collectChains(node::CompositeInterface)
Collects all the `Chain`s of the subtree rooted in `node`.
"""
collectChains(node::CompositeInterface) = begin
    recursive_collect(node,Chain)
end


"""
    collectChains(node::CompositeInterface, selector::Function)
Collects all the `Chain`s of the subtree rooted in `node`.  Filters the returned list using `selector`.
"""
collectChains(node::CompositeInterface, selector::Function) = begin
    filter!(selector, collectChains(node))
end


"""
    collectBonds(node::CompositeInterface)
Returns a `Set` of all the `Bond`s of the atoms in the subtree rooted in `node`.
"""
collectBonds(node::CompositeInterface) = begin
    bonds = Set{Bond}()
    for at in collectAtoms(node)
        length(values(getBonds(at))) > 0 && push!(bonds, values(getBonds(at))...)
    end
    return collect(bonds)
end

Base.show(io::IO, comp::CompositeInterface) = print(io, typeof(comp)," \"",getName(comp), "\" with ",
countChildren(comp), " child",countChildren(comp) == 1 ? "" : "ren", " containing ", countAtoms(comp)," Atoms")

const comparisonops = [:<,:>]
const kerneltype = [Atom,Residue,Chain,System]
for x in kerneltype
    for y in kerneltype
        for op in comparisonops
            @eval Base.$op(::Type{$x},::Type{$y}) =
                  (Base.$op(findfirst(lambda -> lambda == $x,$kerneltype),
                           findfirst(lambda -> lambda == $y,$kerneltype)))
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
Base.getindex(x::System, i::Int) = collectChains(x)[i]
Base.getindex(x::Residue, i::Int) = collectResidues(x)[i]
Base.getindex(x::Chain, i::Int) = collectAtoms(x)[i]

"""
    DataFrameSystem
`DataFrameSystem` is a collection of `DataFrame`s to store `KERNEL` types in.
"""
mutable struct DataFrameSystem
    models  ::DataFrame
    chains  ::DataFrame
    residues::DataFrame
    atoms   ::DataFrame
    DataFrameSystem() = new(nothing,nothing,nothing,nothing)
    DataFrameSystem(
        models::DataFrame,
        chains::DataFrame,
        residues::DataFrame,
        atoms::DataFrame,
    ) = new(models, chains, residues, atoms)
end

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

