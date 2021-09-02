# Concept
`BALL`'s [`KERNEL`](kernel_page.md) types are Subtypes of [`CompositeInterface`](@ref). `CONCEPT` defines an
Interface and a general [`Composite`](@ref) type.
## Types
```@docs
CompositeInterface
SystemInterface
ChainInterface
ResidueInterface
AtomInterface
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
collect(node::T) where T <: CompositeInterface
```
