#=
AtomInterface:
- Julia version: 
- Author: Dan
- Date: 2021-07-27
=#
export AtomInterface, ResidueInterface, ChainInterface, SystemInterface
"""
Abstract Type for Atom Classes.
See Also [`Atom`](@ref)
"""
abstract type AtomInterface <: CompositeInterface end

"""
Abstract Type for Atom Classes.
See Also [`Atom`](@ref)
"""
abstract type ResidueInterface <: CompositeInterface end

"""
Abstract Type for Atom Classes.
See Also [`Atom`](@ref)
"""
abstract type ChainInterface <: CompositeInterface end

"""
Abstract Type for Atom Classes.
See Also [`Atom`](@ref)
"""
abstract type SystemInterface <: CompositeInterface end
