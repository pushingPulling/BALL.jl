# Interfaces

## The Composite Tree and `CompositeInterface`

Currently the main datastructure for representing biological systems is a tree of various
types. `Composite`, `System`, `Chain`, `Residue` and`Atom` - here called 
the *composites* - 
contain a the same set of fields and are all concrete types of `CompositeInterface`.
This interface implements tree traversal, iteration and modifications to the tree.\
All those types have a `parent_` field and a `first_child_` and `last_child_`field, which
enables forward and backward iteration to the children. The fields `next_` and `previous_`
grant access to the siblings. \
\

## Interfaces for Kernel Types

Currently there is only an interface for `Atom`s via `AtomInterface`.\ 
The goal is to enable many implementations of Kernel types, such that for example
`AtomInterface` implements common functionality for `Atom` as well as other types which 
substitute for Atom.\
\
In the future, a mechanism to convieniently inherit from a minimal working type will be added.\
Let's assume there is a `MinimalAtom` type that has all needed fields to satisfy the
`AtomInterface`; New types can be built like this:\
```
    @inherit MinimalAtom NewAtom begin
        new_field::Any
        more_fields::Vector{Any}
    end
```
 

# Other Functionality

## Selections
A mechanism to mark composites and Kernel types in a tree is (almost) in place. The `Selectable`
Interface can be used to set the `contains_selection_` field shared by composites.\
The field `modification_stamp_` can carry a Datetime object.


## Overloading
`System`, `Chain`, `Residue` overload the `[]` operator for convenience:\
```
sys = System()
sys[i]      -> returns the i-th chain 
```
Etc. for the other types.
(See [`collectChain`](@ref) function)\



## Type Ordering
The Kernel Types `Atom`, `Residue`, `Chain` and `System` are ordered such that the `<` and
`>` operators imply the transitive ordering `Atom` < `Residue` < `Chain` < `System`. 
Aim is to enable those orderings for the Interfaces and their subtypes.