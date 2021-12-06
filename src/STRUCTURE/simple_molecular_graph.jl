import Base.==
using DataFrames

export
    Edge, Node, MolecularGraph, AbstractMolGraph, AbstractNode, getNumberOfEdges, getNumberOfNodes,
    deleteNode, newNode, collectPartnerEdges, deleteEdge, newEdge, collectPartnerNodes,
    breadthFirstSearch, collectNodes, collectEdges, eachEdge, eachNode

const DFR = DataFrameRow

"""
Interface which defines some getters, setters and constructors in conjunction
with [`AbstractMolGraph`](@ref).
"""
abstract type AbstractNode end

"""
Interface for graphs which describe some topology of biological systems.
"""
abstract type AbstractMolGraph end


"""
Type to represent Edges in [`MolecularGraph`](@ref).
"""
mutable struct Edge
    source_ ::Union{AbstractNode, DFR}
    target_ ::Union{AbstractNode, DFR}
    bond_   ::Union{Bond, DFR}
    Edge(source::Union{AbstractNode, DFR}, target::Union{AbstractNode, DFR},
            bond::Union{Bond, DFR}) = new(source, target, bond)
end
Base.show(io::IO, edge::Edge) = print(io, "E[$(edge.source_) | $(edge.target_)]")
(==)(x::Edge, y::Edge) = return (x === y || x.bond_ == y.bond_)

"""
Type to represent Nodes in [`MolecularGraph`](@ref).
"""
mutable struct Node <: AbstractNode
    adjacent_edges_ ::Vector{Edge}
    atom_           ::Union{Atom, DFR}
    Node(at::Union{Atom, DFR}) = new(Edge[], at)
end
Base.show(io::IO, node::AbstractNode) = print(io, "N[$(node.atom_.serial_)]")


#atoms_to_nodes_ relates atoms to nodes in this Graph and bodns_to_edges_ bonds to edges
 #
"""
Implements [`AbstractMolGraph`](@ref). Uses `Dicts` to manage the [`Node`](@ref)s
 and [`Edge`](@ref)s in it.
"""
mutable struct MolecularGraph <: AbstractMolGraph

    atoms_to_nodes_::Dict{Union{Atom, DFR},AbstractNode}
    bonds_to_edges_::Dict{Union{Bond, DFR},Edge}
    MolecularGraph() = new(Dict{Union{Atom, DFR},AbstractNode}(), Dict{Union{Bond, DFR},Edge}())
    MolecularGraph(NodeType::Type{typ}) where typ<:AbstractNode =
                            new(Dict{Union{Atom, DFR},NodeType}(), Dict{Union{Bond, DFR},Edge}())

end
Base.show(io::IO, gr::MolecularGraph) =
    print(io, "$(length(gr.atoms_to_nodes_)) nodes, $(length(gr.bonds_to_edges_)) edges")

"""
    getFirstNode(graph::MolecularGraph)
Returns the first Node in `graph`.
"""
getFirstNode(graph::MolecularGraph) = begin
    return first(values(graph.atoms_to_nodes_))
end

"""
    getFirstNode(graph::MolecularGraph)
Returns the first Edge in `graph`.
"""
getFirstEdge(graph::MolecularGraph) = begin
    return first(values(graph.bonds_to_edges_))
end


"""
    collectNodes(graph::MolecularGraph)
Returns a Dict-Values iterator over the nodes in the graph.
"""
collectNodes(graph::MolecularGraph) = begin
    return values(graph.atoms_to_nodes_)
end


"""
    eachPartnerNode(node::AbstractNode)
Gets all the nodes, which are connected to `node` via edges.
"""
eachPartnerNode(node::AbstractNode) = begin
    return [x.source_ == node ? x.target_ : x.source_ for x in values(node.adjacent_edges_)]
end

"""
    eachPartnerEdge(node::AbstractNode)
Returns a Dict-Values iterator over the edges adjacent to `node`.
"""
eachPartnerEdge(node::AbstractNode) = begin
    return values(node.adjacent_edges_)
end

"""
    eachEdge(graph::MolecularGraph)
Returns a Dict-Values iterator over the edges in `graph`.
"""
eachEdge(graph::MolecularGraph) = begin
    return values(graph.bonds_to_edges_)
end


"""
    eachNode(graph::MolecularGraph)
Returns a Dict-Values iterator over the nodes in `graph`.
"""
eachNode(graph::MolecularGraph) = begin
    return values(graph.atoms_to_nodes_)
end


"""
    countNodes(graph::MolecularGraph)
Returns the number of Nodes in `graph`.
"""
countNodes(graph::MolecularGraph) = begin
    return length(graph.atoms_to_nodes_)
end


"""
    countEdges(graph::MolecularGraph)
Returns the number of Nodes in `graph`.
"""
countEdges(graph::MolecularGraph) = begin
    return length(graph.bonds_to_edges_)
end


"""
    newNode(graph::MolecularGraph, at::Atom, NodeType::Type{typ} = Node) where typ<:AbstractNode
Creates and inserts a node of type `typ`, carrying `at` into `graph`.
"""
newNode(graph::MolecularGraph, at::Union{Atom,DFR}, NodeType::Type{typ} = Node) where typ<:AbstractNode = begin
    if haskey(graph.atoms_to_nodes_, at)
        return false
    end
    temp::NodeType = NodeType(at)
    graph.atoms_to_nodes_[at] = temp
    return temp
end


"""
    deleteEdge(graph::MolecularGraph, e::Edge)
Deletes `e` from all adjacency lists of `Node`s in `graph` and from `graph` itself.
"""
deleteEdge(graph::MolecularGraph, e::Edge) = begin
    source = e.source_
    target = e.target_
    delete!(graph.bonds_to_edges_,e.bond_)
    filter!(x -> !(x == e),source.adjacent_edges)
    filter!(x -> !(x == e),target.adjacent_edges)
end


"""
    deleteNode(graph::MolecularGraph,node::AbstractNode)
Deletes `node` from `graph` and deletes all edges adjacent to `node`.
"""
deleteNode(graph::MolecularGraph,node::AbstractNode) = begin
    for edge in node.adjacent_edges_
        deleteEdge(graph, edge)
    end
    delete!(graph.atoms_to_bodes_, node.atom_)
end


"""
    newEdge(graph::MolecularGraph, bond::Bond)
Creates an edge connecting the two `Node`s that represents the atoms that `bond` connects.
Has no effect if the respective nodes do not exist.
"""
newEdge(graph::MolecularGraph, bond::Union{Bond, DFR}) = begin
    if haskey(graph.bonds_to_edges_, bond)
        return false
    end

    if !haskey(graph.atoms_to_nodes_, getSource(bond)) || !haskey(graph.atoms_to_nodes_, getTarget(bond))
        return false
    end

    temp = Edge(graph.atoms_to_nodes_[getSource(bond)], graph.atoms_to_nodes_[getTarget(bond)], bond)
    graph.bonds_to_edges_[bond] = temp
    push!(graph.atoms_to_nodes_[getSource(bond)].adjacent_edges_, temp)
    push!(graph.atoms_to_nodes_[getTarget(bond)].adjacent_edges_, temp)
end


"""
    MolecularGraph(root::T, NodeType::Type{typ} = Node) where typ<:AbstractNode where T<:Union{System, Chain, Residue}
Constructs a `MolecularGraph` mirroring the structure of the tree rooted in `root`.
The nodes will be of type `typ`.
"""
MolecularGraph(root::KernelInterface, NodeType::Type{typ} = Node) where typ<:AbstractNode = begin
    graph = MolecularGraph(NodeType)
    for at in eachAtom(root)
        newNode(graph, at)
    end

    for bond in eachBond(root)
        newEdge(graph, bond)
    end
    return graph
end

"""
    MolecularGraph(dfs::DataFrameSystem) = MolecularGraph(dfs.systems[1,:system],
        NodeType::Type{typ} = Node) where typ<:AbstractNode where T<:Union{System, Chain, Residue}
Gets the first `System` in `dfs` and constructs a Graph from it.
"""


"""
    breadthFirstSearch(graph::MolecularGraph, root::Node, NodeType::Type{typ} = Node) where typ<:AbstractNode
Generic BFS algorithm, that returns the BFS of `graph` rooted in `root`. The resulting
graph will have nodes of type `typ`.
"""
breadthFirstSearch(graph::MolecularGraph, root::Node, NodeType::Type{typ} = Node) where typ<:AbstractNode = begin
    bfs = MolecularGraph(NodeType)
    q::Queue{NodeType} = Queue{NodeType}()
    visited_nodes::Set{NodeType} = Set{NodeType}()
    cur::NodeType = root
    newNode(bfs,root.atom_, NodeType)
    push!(visited_nodes, root)
    cur = root
    while true
        for edge in collectPartnerEdges(cur)
            neighbour::Node = edge.source_ == cur ? edge.target_ : edge.source_
            if !(neighbour in visited_nodes)
                push!(visited_nodes, neighbour)
                enqueue!(q, neighbour)

                newNode(bfs, neighbour.atom_, BackpointingNode)
                newEdge(bfs, edge.bond_)
            end
        end
        isempty(q) && break
        cur = dequeue!(q)
    end
    return bfs
end
