export KernelInterface
"""
Objects can be selected and deselected for certain operations (in the future). Supertype of [`CompositeInterface`](@ref).
"""
abstract type Selectable end


"""
Interface which `KERNEL` types implement. See [`CompositeInterface`](@ref) and
[`DataFrameSystem`](@ref) which both implement `KernelInterface`.
"""
abstract type KernelInterface <: Selectable end

function select(x::Selectable)
    x.selected_ = true
end

function deselect(x::Selectable)
    x.selected_ = false
end

function isSelected(x::Selectable)
    return x.selected_
end

