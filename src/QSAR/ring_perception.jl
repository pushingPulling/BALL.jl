#=
ring_perception_processor:
- Julia version: 
- Author: Dan
- Date: 2021-08-05
=#
export SSSR

"""
    SSSR(root::AbstractComposite)
Calculate the [`SSSR`](https://en.wikipedia.org/wiki/Cycle_basis#Applications) using
 [`minimum_cycle_basis`](@ref)
"""
SSSR(root::Union{KernelInterface, DataFrameRow}) = begin
    if countBonds(root) - countAtoms(root) + 1 < 1
        println("No cycles possible")
        return Vector{Edge}[], Set{Atom}()
    end

    graph = MolecularGraph(root)
    to_delete::Vector{Edge} = Edge[]

    for edge in eachEdge(graph)
        bond_type = edge.bond_.bond_type_
        if bond_type == TYPE__HYDROGEN || bond_type == TYPE__DISULPHIDE_BRIDGE
            push!(to_delete, edge.bond_)
        end
    end

    for edge in to_delete
        deleteEdge(graph, edge)
    end

    sssr::Vector{Vector{Edge}} = STRUCTURE.minimum_cycle_basis(graph)

    ring_atoms::Set{Union{Atom, DataFrameRow}} = Set{Union{Atom, DataFrameRow}}()

    for edge in Iterators.flatten(sssr)
        push!(ring_atoms, edge.source_.atom_::Union{Atom, DataFrameRow}, edge.target_.atom_::Union{Atom, DataFrameRow})
    end

    for atom in ring_atoms
        setProperty(atom,("InRing",true))
    end

    for atom in eachAtom(root)
        if !hasProperty(atom,"InRing")
            setProperty(atom,("InRing",false))
        end
    end
    return sssr, ring_atoms
end

SSSR(dfs::DataFrameSystem) = SSSR(first(dfs.systems))