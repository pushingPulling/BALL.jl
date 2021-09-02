# [Kernel](@id KERNEL_header)
`BALL`'s `KERNEL` defines Types and Functions to model Biological Systems.

## Overloading and Type ordering
See [`Overloading`](@ref Overloading) and [`Type Ordering`](@ref Type-Ordering).

## Types
```@docs
System
Chain
Residue
Atom
Bond
Element
AtomBijection
DataFrameSystem
```

## Functions
```@autodocs
Modules = [BALL.KERNEL]
Private = false
Order=[:function] 
```
```@docs
Base.iterate(::CompositeIterator)
Base.getindex(::Vector{Chain}, ::String)
```
### Getter and Setters
```@autodocs
    Modules=[]
    Pages=["getter_setter.jl"]
```
