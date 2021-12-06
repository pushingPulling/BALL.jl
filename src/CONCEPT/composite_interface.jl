
export
    CompositeInterface, isDescendantOf, countDescendants, removeChild, getParent,
    getChildren, appendChild, isSibling, appendSibling, prependSibling, hasProperty,
    recursive_collect, clearSelectionTree, countChildren, getProperties,
    getProperty, setProperty, getName, recursive_count, removeComposite,
    getFirstAtom, getFirstResidue, getFirstChain, getFirstSystem

import Base.convert, Base.iterate

"""
An Interface which implements functions for tree traversal, exploration, manipulation, iteration.
Implements getters and setters. Also implements functions to collect objects from the tree.\n
See also [`System`](@ref), [`Chain`](@ref), [`Residue`](@ref), [`Atom`](@ref).
"""
abstract type CompositeInterface <: KernelInterface end


#=  Preorder, Neutral-Left-Right iterator
    (first current object, then DFS-like left subtree,
    then DFS-like right subtree)
=#
"""
    Base.iterate(::CompositeInterface)
Iterates over the tree rooted in `c` in [Pre-order](https://en.wikipedia.org/wiki/Tree_traversal#Pre-order,_NLR).
Use [`recursive_collect`](@ref) as `Base.iterate` is slower.
"""
Base.iterate(c :: CompositeInterface) = (c, CompositeInterface[c])
function Base.iterate(_ :: CompositeInterface, stack :: Vector{CompositeInterface})
    cp = last(stack)
    if cp.first_child_ !== nothing
        return (cp.first_child_, push!(stack, cp.first_child_))
    else
        if cp.next_ !== nothing
            stack[end] = cp.next_
            return (cp.next_, stack)
        else # backtracks
            pop!(stack)
            while !isempty(stack)
                if !isdefined(last(stack),:next_)
                    println(typeof(last(stack)), " ",last(stack))
                end
                cp = last(stack).next_
                if cp !== nothing
                    stack[end] = cp
                    return (cp, stack)
                end
                pop!(stack)
            end
            return nothing
        end
    end
end


Base.length(C::CompositeInterface) = countDescendants(C)
Base.eltype(::CompositeInterface) = CompositeInterface

"""
    isDescendantOf(this::T, other::S) where {T,S <: CompositeInterface}
Checks if `other` is a descendant of `this`.
"""
isDescendantOf(this::T, other::S) where {T,S <: CompositeInterface} = begin
    cur::CompositeInterface = this
    while !isnothing(cur.parent_)
        cur = cur.parent_
        (cur == other) && return true
    end
    return false
end

"""
    countDescendants(node::Type) where {Type <: CompositeInterface}
Counts the numbers of descendants of `node`.
"""
countDescendants(node::Type) where {Type <: CompositeInterface} = begin
    number_of_descendants::Int64 = 1
    if isnothing(node.first_child_)
        return 1
    end

    cur = node.first_child_
    number_of_descendants += countDescendants(cur)
    while !isnothing(cur.next_)
        number_of_descendants += countDescendants(cur.next_)
        cur = cur.next_
    end
    return number_of_descendants
end

"""
    removeChild(root::T, child_node::S) where{T,S <: CompositeInterface}
Removes `child_node` from `root`. Return `false` if `child_node` is not `root`'s child.
"""
removeChild(root::T, child_node::S) where{T,S <: CompositeInterface} = begin
    # avoid self-removal and removal of ancestors
    if root == child_node || isDescendantOf(root, child_node)
        return false
    end

    #if child has no parent, we cannot remove it
    if isnothing(child_node.parent_)
        return false
    end

    #remove child from the list of children
    if root.first_child_ == child_node
        root.first_child_ = root.first_child_.next_

        if (!isnothing(root.first_child_))
            first_child_->previous_ = nothing
        else
            root.last_child_ = nothing
        end
        root.number_of_children_ -= (!isnothing(countDescendants(child_node)) ? countDescendants(child_node) : 0)

        root.child.next_ = nothing
    else
        if root.last_child_ == child_node
            root.last_child_ = child_node.previous_
            root.last_child_.next_ = child_node.previous_ = nothing
        else
            #println(root, child_node)
            child_node.previous_.next_ = child_node.next_

            child_node.next_.previous_ = child_node.previous_

            child_node.previous_ = child_node.next_ = nothing
        end

        root.number_of_children_ -= countDescendants(child_node)
    end

    # delete the child`s parent pointer
    child_node.parent_ = nothing

    # adjust some counters
    root.number_of_children_ -= 1

    #=
    if (child_node.contains_selection_)
        number_of_children_containing_selection_ -= 1
        if (child_node.selected_)
            number_of_selected_children_ -= 1
        end
    end

    # update the selection
    updateSelection_();

    # update modification time stamp
    stamp(MODIFICATION);
    =#
    return true

end

"""
    removeChild(child::T) where T<:CompositeInterface
Removes `child_node` from `root`. Return `false` if `child_node` is not `root`'s child.
"""
removeChild(child::T) where T<:CompositeInterface = removeChild(child.parent_, child)

"""
    removeComposite(comp::T) where T<:CompositeInterface
Removes `child_node` from `root`. Return `false` if `child_node` is not `root`'s child.
"""
removeComposite(comp::T) where T<:CompositeInterface = removeChild(comp.parent_, comp)


"""
    getParent(node::CompositeInterface)
Gets `node`'s parent. Can return `nothing`.
"""
getParent(node::CompositeInterface) = begin
    return node.parent_
end

"""
    getChildren(node::T) where T <: CompositeInterface
Gets `node`'s immediate children.
"""
getChildren(node::T) where T <: CompositeInterface = begin

    if node.first_child_ !== nothing
        cur = node.first_child_
        children = (typeof(node.first_child_))[node.first_child_]
        while cur.next_ !== nothing
            push!(children,cur.next_)
            cur = cur.next_
        end
        return children

    end

end

"""
    appendChild(old_node::T, new_node::S) where {T,S <: CompositeInterface}
Appends `new_node` to `old_node`. Returns `nothing` if not possible and removes `old_node`'s previous
parent if needed.\n
See also [`removeChild`](@ref).
"""
appendChild(old_node::T, new_node::S) where {T,S <: CompositeInterface} = begin
    #avoid self-appending and appending of parent nodes
    if old_node == new_node || isDescendantOf(new_node, old_node)
       return nothing
    end

    # if composite has a parent, remove it from there
    if !isnothing(new_node.parent_)
        removeChild(new_node.parent_, new_node);
    end

    # insert it
    if isnothing(old_node.last_child_)
        # its the only child - easy!
        old_node.first_child_ = old_node.last_child_ = new_node
    else
        # append it to the list of children
        old_node.last_child_.next_ = new_node
        new_node.previous_ = old_node.last_child_
        old_node.last_child_ = new_node
    end

    isnothing(old_node.number_of_children_) && ( old_node.number_of_children_ = 0)
    old_node.number_of_children_ += countDescendants(new_node)

    new_node.parent_ = old_node



    #=

    # update modification time stamp
    old_node.last_child_.stamp(MODIFICATION);

    # update selection counters
    if (new_node.containsSelection())
        number_of_children_containing_selection_ += 1
        if (new_node.selected_)
            number_of_selected_children_+=1
        end
        # recursively update the nodes` states
        (old_node.)updateSelection_();
    end
    =#

end

appendChild(::Nothing, ::S) where S<:CompositeInterface = nothing
appendChild(::S, ::Nothing) where S<:CompositeInterface = nothing

"""
   isSibling(comp::CompositeInterface, other::CompositeInterface)
Returns `true` if `other` and `comp are siblings`, else `false`
"""
isSibling(comp::CompositeInterface, other::CompositeInterface) = begin
    if !isnothing(comp.parent_)
        return (other in getChildren(comp.parent_))
    else
        return false
    end
end

"""
    appendSibling(comp::T, other::T) where T<:CompositeInterface
Inserts `other` after `comp` in the list of Siblings.\n
See also [`prependSibling`](@ref).
"""
appendSibling(comp::T, other::T) where T<:CompositeInterface = begin
    isSibling(comp, other) && return
    cur::T = comp
    while !isnothing(cur.next_)
         cur = cur.next_
    end
    cur.next_ = other
    other.previous_ = cur
    other.parent_ = comp.parent_

    if !isnothing(comp.parent_)
        comp.parent_.number_of_children_ += countDescendants(other)
    end
end

appendSibling(::Nothing, ::S) where S<:CompositeInterface = nothing
appendSibling(::S, ::Nothing) where S<:CompositeInterface = nothing

"""
    prependSibling(comp::T, other::T) where T<:CompositeInterface
Inserts `other` before `comp` in the list of Siblings. \n
See also [`appendSibling`](@ref).
"""
prependSibling(comp::T, other::T) where T<:CompositeInterface = begin
    isSibling(comp, other) && return
    cur::T = comp
    while !isnothing(cur.previous_)
         cur = cur.previous_
    end
    cur.prev_ = other
    other.next_ = cur
    other.parent_ = comp.parent_

    if !isnothing(comp.parent_)
        comp.parent_.number_of_children_ += countDescendants(other)
    end
end

countDescendants_iterate(node::Type) where {Type <: CompositeInterface} = begin
    number_of_descendants::Int64 = 0
    for descendants in node
        number_of_descendants += 1
    end
    return number_of_descendants
end

"""
    recursive_count(node::Type1, collectType::Type{Type2} where {Type1, Type2 <: CompositeInterface}
Counts nodes of the tree rooted in `node`. `collectType` filters the type to be counted.
"""
recursive_count(node::Type1, collectType::Type{Type2}) where {Type1, Type2 <: CompositeInterface} = begin

    recursive_count_counter = 0
        recursive_count(node::Type1,counter::Int64, collectType::Type{Type2}) where {Type1, Type2 <: CompositeInterface} = begin
        if collectType == CompositeInterface
            recursive_count_counter += 1
        end
        (typeof(node) == collectType) && (recursive_count_counter +=1)
        if !isnothing(node.first_child_)
            cur = node.first_child_
            recursive_count(cur,counter,collectType)
            while !isnothing(cur.next_)
                recursive_count(cur.next_,counter,collectType)
                cur = cur.next_
            end
        end
        return
    end

    recursive_count(node,0,collectType)
    return recursive_count_counter
end




"""
    recursive_collect(node::Type1, collectType::Type{Type2}) where {Type1, Type2 <: CompositeInterface}
Collects nodes of the tree rooted in `node` in [Pre-order](https://en.wikipedia.org/wiki/Tree_traversal#Pre-order,_NLR).
`collectType` filters the type to be collected. \n
See also [`collectAtoms`](@ref), [`collectResidues`](@ref), [`collectChains`](@ref).
"""
recursive_collect(node::Type1, collectType::Type{Type2}) where {Type1, Type2 <: CompositeInterface} = begin
    #performs a collect on current node and all its ancestors
    vec = Vector{collectType}()

    recursive_collect(node::Type1,vec::Vector{Type2}, collectType::Type{Type2}) where {Type1, Type2 <: CompositeInterface} = begin
        if collectType == CompositeInterface
            push!(vec,node)
        end
        (typeof(node) == collectType) && push!(vec,node)
        if !isnothing(node.first_child_)
            cur = node.first_child_
            recursive_collect(cur,vec,collectType)
            while !isnothing(cur.next_)
                recursive_collect(cur.next_,vec,collectType)
                cur = cur.next_
            end
        end
        return vec
    end

    recursive_collect(node,vec,collectType)
    return vec
end
"""
    collect(node::T) where T <: CompositeInterface
Collects all nodes in the subtree rooted in `node`.
"""
Base.collect(node::T) where T <: CompositeInterface = begin
    return recursive_collect(node,CompositeInterface)
end

"""
    clearSelectionTree(x::CompositeInterface)
Deselets any selected Nodes. See [`Selectable`](@ref).
"""
function clearSelectionTree(x::CompositeInterface)
    for node in x
        deselect(x)
    end
end

"""
    countChildren(comp::CompositeInterface)
Counts the number of immediate Children.
"""
countChildren(comp::CompositeInterface) = begin
    count = 0
    if !isnothing(comp.first_child_)
        count = 1
        cur = comp.first_child_
        while !isnothing(cur.next_)
            count += 1
            cur = cur.next_
        end
    end
    return count
end

"""
    getProperties(::CompositeInterface)
Getter of property-Vector
"""
getProperties(comp::CompositeInterface) = begin
    return comp.properties_
end
"""
    hasProperty(comp::CompositeInterface, property::String)
Checks if `comp` has property `property`.
"""
hasProperty(comp::CompositeInterface, property::String) = begin
    if any([property == x[1] for x in getProperties(comp) ])
       return true
    end
    return false
end

"""
    getProperty(comp::CompositeInterface, property::String)
Gets value of `property` if set, else `nothing`.
"""
getProperty(comp::CompositeInterface, property::String) = begin
    if hasProperty(comp,property)
        index = findfirst((x::Tuple{String,UInt8})-> property == x[1], getProperties(comp))
        return getProperties(comp)[index][2]
    end
    return nothing
end

"""
    setProperty(::CompositeInterface, ::Tuple{String,UInt8})
Setter. Deletes old property if needed.
"""
setProperty(comp::CompositeInterface, property::Tuple{String,UInt8}) = begin
    if hasProperty(comp,property[1])
        index = findfirst((x::Tuple{String,UInt8})-> property[1] == x[1], getProperties(comp))
        deleteat!(getProperties(comp), index)
    end
    push!(comp.properties_, property)
end
setProperty(comp::CompositeInterface, property::Tuple{String,Bool}) = setProperty(comp,(property[1],UInt8(property[2])))

"""
    getFirstAtom(comp::CompositeInterface)
Returns the first object that is an `AtomInterface` subtype.
"""
getFirstAtom(comp::CompositeInterface) = begin
    cur::T where T <: CompositeInterface = comp
    while !isnothing(cur)
        if typeof(cur) <: AtomInterface
            return cur
        end
        cur = cur.first_child_
    end
    return nothing
end

"""
    getFirstResidue(comp::CompositeInterface)
Returns the first object that is an `ResidueInterface` subtype.
"""
getFirstResidue(comp::CompositeInterface) = begin
    cur::T where T <: CompositeInterface = comp
    while !isnothing(cur)
        if typeof(cur) <: ResidueInterface
            return cur
        end
        cur = cur.first_child_
    end
    return nothing
end

"""
    getFirstChain(comp::CompositeInterface)
Returns the first object that is an `ChainInterface` subtype.
"""
getFirstChain(comp::CompositeInterface) = begin
    cur::T where T <: CompositeInterface = comp
    while !isnothing(cur)
        if typeof(cur) <: ChainInterface
            return cur
        end
        cur = cur.first_child_
    end
    return nothing
end

"""
    getFirstSystem(comp::CompositeInterface)
Returns the first object that is an `SystemInterface` subtype.
"""
getFirstSystem(comp::CompositeInterface) = begin
    cur::T where T<:CompositeInterface = comp
    while !isnothing(cur)
        if typeof(cur) <: SystemInterface
            return cur
        end
        cur = cur.first_child_
    end
    return nothing
end



"""
    getName(comp::CompositeInterface)
Fallback getter for a `Composite`'s' name.\n See also [getName(::System)](@ref), [getName(::Chain)](@ref),
 [getName(::Atom)](@ref), [getName(::Residue)](@ref)
"""
getName(comp::CompositeInterface) = begin
#chain and residue override this function in their respective julia file
    !isnothing(comp.name_) ? (return comp.name_) : "-"
end

getName(::Any) = "N/A"





