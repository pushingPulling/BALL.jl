#=
atom:
- Julia version: 
- Author: Dan
- Date: 2021-06-01
=#

export
    Atom, getBonds, collectBonds, setFormalCharge, getElementSymbol, coords
using Distances: euclidean, sqeuclidean

"""
Standard representation for an Atom (e.g. in a Molecule). See also [`CompositeInterface`](@ref).
"""
mutable struct Atom <: AtomInterface    #AtomInterface inherits from CompositeInterface
    name_           ::Union{String,Nothing}
    parent_         ::Union{Nothing,CompositeInterface}
    previous_       ::Union{Nothing,CompositeInterface}
    next_           ::Union{Nothing,CompositeInterface}
    first_child_    ::Union{CompositeInterface, Nothing}
    last_child_     ::Union{CompositeInterface, Nothing}
    type_name_      ::Union{String,Nothing}
    element_        ::Union{Element,Nothing}
    radius_         ::Union{Float64,Nothing}
    type_           ::Union{UInt8,Nothing}
    number_of_bonds_::Union{UInt8,Nothing}
    formal_charge_  ::Union{Int64,Nothing}
    position_       ::Union{SVector{3,Float64},Nothing}
    charge_         ::Union{Float64,Nothing}
    velocity_       ::Union{SVector{3,Float64},Nothing}
    force_          ::Union{SVector{3,Float64},Nothing}
    occupancy_      ::Union{Float64, Nothing}
    serial_         ::Union{Int64,Nothing}
    temp_factor_    ::Union{Float64,Nothing}
    selected_       ::Bool
    bonds_          ::Dict{Atom, Bond}
    properties_     ::Vector{Tuple{String,UInt8}}

    Atom() = new(nothing,nothing,nothing,nothing,nothing,nothing,nothing,
    nothing,nothing,nothing,nothing,nothing,nothing,nothing,nothing,nothing,
    nothing,nothing,nothing,false,Dict{Atom, Bond}(),Vector{Tuple{String,UInt8}}())


        Atom(   name_           ,
                parent_         ,
                previous_       ,
                next_           ,
                first_child_    ,
                last_child_     ,
                type_name_      ,
                element_        ,
                radius_         ,
                type_           ,
                number_of_bonds_,
                formal_charge_  ,
                position_       ,
                charge_         ,
                velocity_       ,
                force_          ,
                occupancy_      ,
                serial_         ,
                temp_factor_

            )   = new(name_           ,
                    parent_         ,
                    previous_       ,
                    next_           ,
                    first_child_    ,
                    last_child_     ,
                    type_name_      ,
                    element_        ,
                    radius_         ,
                    type_           ,
                    number_of_bonds_,
                    formal_charge_  ,
                    position_       ,
                    charge_         ,
                    velocity_       ,
                    force_          ,
                    occupancy_      ,
                    serial_         ,
                    temp_factor_    ,
                    false,
                    BondsDict(),
                    Vector{Tuple{String,Int8}}()
            )
end

const BondsDict = Dict{Atom, Bond}

Atom(   atomname::String, x::Float64, y::Float64, z::Float64,
        elem::String, charge::Union{Float64,Nothing},
         occupancy::Float64,serial::Int64, temp_factor::Float64) = begin

        Atom(atomname,
            nothing,
            nothing,
            nothing,
            nothing,
            nothing,
            nothing,
            Element(capitalize(elem)),
            nothing,
            nothing,
            nothing,
            nothing,
            SA_F64[x,y,z],
            charge,
            nothing,
            nothing,
            occupancy,
            serial,
            temp_factor)
    end



getBonds(at::T) where T<:AtomInterface = at.bonds_

"""
    collectBonds(node::CompositeInterface)
Returns a `Set` of all the `Bond`s of the atoms in the subtree rooted in `node`.
"""

"""
    coords(at::Atom)
Resturns a `SVector` with the Atoms coordinates.
"""
coords(at::Atom) = at.position_


collectBonds(node::CompositeInterface) = begin
    bonds = Set{Bond}()
    for at in collectAtoms(node)
        length(values(getBonds(at))) > 0 && push!(bonds, values(getBonds(at))...)
    end
    return collect(bonds)
end
viewBonds(node::CompositeInterface) = collectBonds(node)


"""
    getElementSymbol(at::Atom) -> String
Returns the Periodic Talble of Elements' symbol of the element of the atom.
"""
getElementSymbol(at::T) where T<:AtomInterface = at.element_.symbol_

setFormalCharge(at::T, new_charge::Int64) where T<:AtomInterface = begin at.formal_charge_ = new_charge end

Base.show(io::IO, at::Atom) = print(io, "Atom$(at.serial_)[",
    #"$( (isnothing(at.element_)) ? "-" : string(at.element_.symbol_) )|",
    "$( (isnothing(at.element_) || isnothing(at.element_.symbol_)) ? "-" : at.element_.symbol_)|",
    "$( (isnothing(at.parent_) || isnothing(at.parent_.name_)) ? "-" : at.parent_.name_ )]")
