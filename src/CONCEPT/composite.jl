#=
composite:
- Julia version: 
- Author: Dan
- Date: 2021-06-04
=#

export
    Composite

"""
`Composite` implements the minimum set of fields that `System`, `Chain`, `Residue`, `Atom` must also
implement. An object of `Composite` is a Node in a hierarchical tree of many types which subtype
`AbstractComposite`.\n
See also [`AbstractComposite`](@ref),[`System`](@ref), [`Chain`](@ref), [`Residue`](@ref), [`Atom`](@ref)
"""
mutable struct Composite <: AbstractComposite
    name_                                       ::String
    number_of_children_                         ::Int64
    parent_                                     ::Union{AbstractComposite, Nothing}
    previous_                                   ::Union{Nothing, AbstractComposite}
    next_                                       ::Union{AbstractComposite, Nothing}
    first_child_                                ::Union{AbstractComposite, Nothing}
    last_child_                                 ::Union{AbstractComposite, Nothing}
    properties_                                 ::UInt64
    contains_selection_                         ::Bool
    number_of_selected_children_                ::Int64
    number_of_children_containing_selection_    ::Int64
    selection_stamp_                            ::Union{TimeStamp,Nothing}
    modification_stamp_                         ::Union{TimeStamp,Nothing}
    trait_                                      ::Union{Nothing,AbstractComposite}

    #default constructor
    Composite() = Composite("",0,nothing,nothing,nothing,nothing,nothing,UInt64(0),false,0,0,nothing,nothing,nothing)
    Composite(xd::Bool) = new(0,nothing,nothing,nothing,nothing,nothing,nothing,0,false
    ,0,0,nothing,nothing,nothing)

    #full constructor
    Composite(
        name_                                   ::String,
        number_of_children                      ::Int64,
        parent                                  ::Composite,
        previous                                ::Composite,
        next                                    ::Composite,
        first_child                             ::Composite,
        last_child                              ::Composite,
        properties                              ::UInt8,
        contains_selection                      ::Bool,
        number_of_selected_children             ::Int64,
        number_of_children_containing_selection ::Int64,
        selection_stamp                         ::TimeStamp,
        modification_stamp                      ::TimeStamp,
        trait                                   ::AbstractComposite

    ) = new(
            name_,
            number_of_children,
            parent,
            previous,
            next,
            first_child,
            last_child,
            properties,
            contains_selection,
            number_of_selected_children,
            number_of_children_containing_selection,
            selection_stamp,
            modification_stamp,
            trait
        )
end
#partial constructor: Refs to other Composites and the obj itself
Composite(
    number_of_children              ::Int64,
    parent                          ::AbstractComposite,
    prev                            ::AbstractComposite,
    next                            ::AbstractComposite,
    first_child                     ::AbstractComposite,
    last_child                      ::AbstractComposite,
    trait                           ::AbstractComposite
) = begin

    Composite(
        number_of_children,
        parent,
        prev,
        next,
        first_child,
        last_child,
        0,
        false,
        false,
        0,
        0,
        nothing,
        nothing,
        trait,
    )
end
