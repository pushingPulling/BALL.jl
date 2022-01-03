#=
AbstractAtom:
- Julia version: 
- Author: Dan
- Date: 2021-07-27
=#
export AbstractAtom, AbstractResidue, AbstractChain, AbstractSystem, AbstractBond
"""
Abstract Type for Atom Types.
See Also [`Atom`](@ref)
"""
abstract type AbstractAtom <: AbstractComposite end

"""
Abstract Type for Atom Types.
See Also [`Atom`](@ref)
"""
abstract type AbstractResidue <: AbstractComposite end

"""
Abstract Type for Atom Types.
See Also [`Atom`](@ref)
"""
abstract type AbstractChain <: AbstractComposite end

"""
Abstract Type for Atom Types.
See Also [`Atom`](@ref)
"""
abstract type AbstractSystem <: AbstractComposite end

"""
Abstract Type for Bond Types.
See Also [`Bond`](@ref)
"""
abstract type AbstractBond <: AbstractComposite end
