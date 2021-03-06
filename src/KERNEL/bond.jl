#=
bond:
- Julia version: 
- Author: Dan
- Date: 2021-06-01
=#
import ..CONCEPT: getProperties, hasProperty, getProperty
export
    Order, BondType, Bond, createBond, bondExists, printBonds, deleteBond,
    ORDER__SINGLE, TYPE__COVALENT, TYPE__HYDROGEN, TYPE__DISULPHIDE_BRIDGE, TYPE__SALT_BRIDGE

import Base.show
import BALL.CONCEPT.setProperty

@enum Order begin
        ORDER__UNKNOWN          = 0
        ORDER__SINGLE           = 1
        ORDER__DOUBLE           = 2
        ORDER__TRIPLE           = 3
        ORDER__QUADRUPLE        = 4
        ORDER__AROMATIC         = 5
        ORDER__ANY              = 6
end

@enum BondType begin
        TYPE__UNKNOWN           = 0
        TYPE__COVALENT          = 1
        TYPE__HYDROGEN          = 2
        TYPE__DISULPHIDE_BRIDGE = 3
        TYPE__SALT_BRIDGE       = 4
        TYPE__PEPTIDE           = 5
end

"""
Represents chemical Bonds between Atoms.
"""
mutable struct Bond <: AbstractBond
    #AbstractComposite is used as type since we can't use class `Atom`
    #because we can't forward reference it or have circular dependencies.
    #this class is only to be used with Atoms
        #the atom with the lower serial number is always the source one
        source_                      ::AbstractAtom
        target_                      ::AbstractAtom
        name_                        ::String
        bond_order_                  ::Order
        bond_type_                   ::BondType
        properties_                  ::Vector{Tuple{Symbol,Any}}


        Bond(x::AbstractComposite, y::AbstractComposite, name::String, bond_order::Order,
                bond_type::BondType, properties::Vector{Tuple{Symbol,Any}}) = begin
            throw(ErrorException("Bonds are only allowed between Atoms. Input: $x , $y."))
        end

        Bond(x::T, y::T, name::String, bond_order::Order,
                bond_type::BondType,
                properties::Vector{Tuple{Symbol,Any}}) where T<: AbstractAtom = begin
            if x == y
                throw(ErrorException("Bonds between the same Atom are disallowed. Input: $x , $y."))
            end
            if x.serial_ > y.serial_
                x, y = y, x
            end
            new(x,y,name,bond_order,bond_type,properties)
        end
end


Bond(at1::AbstractAtom, at2::AbstractAtom;
        name::String ="",
        order::Order = ORDER__ANY, type::BondType = TYPE__UNKNOWN,
        properties::Vector{Tuple{Symbol,Any}} = Tuple{Symbol,Any}[]) =
   Bond(at1,at2,name,order,type, properties)


"""
    createBond(at_owner::AbstractAtom, at_guest::AbstractAtom; name::String ="",
        order::Order = ORDER__ANY, type::BondType = TYPE__UNKNOWN, properties::Vector{Tuple{String,UInt8}})
Creates a Bond between two already existing Atoms. See `Order` and `BondType` in Bond.jl.
"""
createBond(at_owner::AbstractAtom, at_guest::AbstractAtom; name::String ="",
        order::Order = ORDER__ANY, type::BondType = TYPE__UNKNOWN,
         properties::Vector{Tuple{Symbol,Any}} = Tuple{Symbol,Any}[]) = begin
    bondExists(at_owner,at_guest) && return nothing
    temp = Bond(at_owner, at_guest, name = name, order = order, type = type, properties = properties)
    at_owner.bonds_[at_guest] = temp
    at_guest.bonds_[at_owner] = temp
    return temp
end

"""
    bondExists(::AbstractAtom, ::AbstractAtom)
Checks if a Bond exists.
"""
bondExists(at1::AbstractAtom, at2::AbstractAtom) = begin
    return haskey(at1.bonds_,at2)
end

"""
    deleteBond(::AbstractAtom, ::AbstractAtom)
Deletes a Bond between two `Atom`s. Has no effect if a Bond between the `Atom`s doesn't exist.
"""
deleteBond(at1::AbstractAtom, at2::AbstractAtom) = begin
    delete!(at1.bonds_, at2)
    delete!(at2.bonds_, at1)
    return nothing
end

printBonds(at::AbstractAtom, io::IO = Base.stdout) = begin
    println(io,"$at has bonds to ",
     join(keys(at.bonds_),", "),". ")
end
"""
    getProperties(::Bond)
"""
getProperties(comp::Bond) = begin
    return comp.properties_
end

"""
    hasProperty(::Bond, ::String)
"""
hasProperty(comp::Bond, property::String) = begin
    if any([property == x[1] for x in getProperties(comp) ])
       return true
    end
    return false
end

"""
    getProperty(::Bond, ::Tuple{Symbol,Any})
"""
getProperty(comp::Bond, property::Tuple{Symbol,Any}) = begin
    if hasProperty(comp,property)
        index = findfirst((x::Tuple{Symbol,Any})-> property[1] == x[1], getProperties(comp))
        return getProperties(comp)[index][2]
    end
    return nothing
end

"""
    setProperty(::Bond, ::Tuple{String,UInt8})
"""
setProperty(comp::Bond, property::Tuple{Symbol,Any}) = begin
    if hasProperty(comp,property[1])
        index = findfirst((x::Tuple{Symbol,Any})-> property[1] == x[1], getProperties(comp))
        deleteat!(getProperties(comp), index)
    end
    push!(comp.properties_, property)

end
"""
    setProperty(::Bond, ::Tuple{String,Bool})
"""
#setProperty(comp::Bond, property::Tuple{Symbol,Bool}) = setProperty(comp,(property[1],property[2]))


Base.show(io::IO, bond::Bond) = begin
    bond_order= "Unknown-order"
    bond_type = "unknown-type"
    if bond.bond_order_ == Order(1)
        bond_order= "Single"
    elseif bond.bond_order_ == Order(2)
        bond_order= "Double"
    elseif bond.bond_order_ == Order(3)
        bond_order= "Triple"
    elseif bond.bond_order_ == Order(4)
        bond_order= "Quadruple"
    elseif bond.bond_order_ == Order(5)
        bond_order= "Aromatic"
    end

    if bond.bond_type_ == BondType(1)
        bond_type= "covalent"
    elseif bond.bond_type_ == BondType(2)
        bond_type= "hydrogen"
    elseif bond.bond_type_ == BondType(3)
        bond_type= "disulphite-bridge"
    elseif bond.bond_type_ == BondType(4)
        bond_type= "salt-bridge"
    elseif bond.bond_type_ == BondType(5)
        bond_type= "peptide"
    end

    print(io,
        "$bond_order $bond_type bond: $(bond.source_) -> $(bond.target_)")

end
