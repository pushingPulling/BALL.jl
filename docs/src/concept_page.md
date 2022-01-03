# Concept
`BALL`'s [`KERNEL`](kernel_page.md) types are Subtypes of [`AbstractComposite`](@ref). `CONCEPT` defines an
Interface and a general [`Composite`](@ref) type.
## Types
```@docs
AbstractComposite
AbstractSystem
AbstractChain
AbstractResidue
AbstractAtom
Composite

BALL.CONCEPT.Selectable
```
## Functions
```@autodocs
Modules = [BALL.CONCEPT]
Private = false
Order=[:function] 
```
```@docs
setProperty(::Bond,::Tuple{String,Bool})
setProperty(::Bond,::Tuple{String,UInt8})
collect(node::T) where T <: AbstractComposite
```
