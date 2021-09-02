
import Base.==
export
    Edge, Node, MolecularGraph, AbstractMolGraph, AbstractNode, getNumberOfEdges, getNumberOfNodes,
    deleteNode, newNode, collectPartnerEdges, deleteEdge, newEdge, collectPartnerNodes,
    breadthFirstSearch, collectNodes, collectEdges, getFirstNode, getFirstEdge, eachPartnerEdge,
    eachPartnerNode, eachNode, eachEdge

"""
Interface which defines some getters, setters and constructors in conjunction
with [`AbstractMolGraph`](@ref).
"""
abstract type AbstractNode end

"""
Interface for graphs which describe some topology of biological systems.
"""
abstract type AbstractMolGraph end

const DFR = DataFrameRow

"""
Type to represent Edges in [`MolecularGraph`](@ref).
"""
mutable struct Edge{NodeType<:Union{AbstractNode, DFR}, BondType<:Union{Bond,DFR}}
    source_ ::NodeType
    target_ ::NodeType
    bond_   ::BondType
    Edge(source::AbstractNode, target::AbstractNode, bond::Bond) = new{AbstractNode,Bond}( source, target, bond )
    Edge(source::DFR, target::DFR, bond::DFR) = new{DFR,DFR}( source, target, bond )
end
Base.show(io::IO, edge::Edge) = print(io, "E[$(getSource(edge)) | $(getTarget(edge))]")
(==)(x::Edge, y::Edge) = return (x === y || x.bond_ == y.bond_)


"""
Type to represent Nodes in [`MolecularGraph`](@ref).
"""
mutable struct Node{NodeType<:Union{AbstractNode, DFR}, AtomType<:Union{Atom, DFR}, BondType<:Union{Bond, DFR}} <: AbstractNode
    adjacent_edges_ ::Vector{Edge{NodeType,BondType}}
    atom_           ::AtomType
    Node(at::Atom) = new{Node,Atom, Bond}( Edge{Node, Bond}[], at )
    Node(dfr::DFR) = new{DFR, DFR, DFR}( Edge{DFR, DFR}[], dfr )
end
Base.show(io::IO, node::AbstractNode) = print(io, "N[$(getSerial(node.atom_))]")


#atoms_to_nodes_ relates atoms to nodes in this Graph and bodns_to_edges_ bonds to edges
 #
"""
Implements [`AbstractMolGraph`](@ref). Uses `Dicts` to manage the [`Node`](@ref)s
 and [`Edge`](@ref)s in it.
"""
mutable struct MolecularGraph{      AtomType<:Union{DFR, AtomInterface},
                                    EdgeType<:Union{AbstractNode, DFR},
                                    BondType<:Union{Bond,DFR},
                                    NodeType<:AbstractNode} <: AbstractMolGraph
    atoms_to_nodes_::Dict{AtomType,NodeType}
    bonds_to_edges_::Dict{BondType, Edge{EdgeType, AtomType}}

    MolecularGraphComposite() = new{AtomInterface, AbstractNode, Bond,AbstractNode}(Dict{T,AbstractNode}(), Dict{BondType, Edge{EdgeType, AtomType}}())
    MolecularGraphDFR() = new{DFR,DFR,DFR,Node}( Dict{DFR,Node}(), Dict{DFR,Edge{DFR,DFR}} )
    MolecularGraph( AtomType::Union{Type{DFR}, Type{AtomInterface}},
                    EdgeType::Union{Type{AbstractNode}, Type{DFR}},
                    BondType::Union{Type{Bond}, Type{DFR}},
                    NodeType::Type{typ} = Node) where typ<:AbstractNode = new{AtomType,EdgeType,BondType,NodeType}(
                        Dict{AtomType,NodeType}(), Dict{BondType, Edge{EdgeType, AtomType}}()
                )
    MolecularGraph(NodeType::Type{typ}) where typ<:AbstractNode =
                            new{AtomInterface,AbstractNode,Bond,NodeType}( Dict{T,NodeType}(), Dict{BondType, Edge{EdgeType, AtomType}}() )

end



getFirstNode(graph::MolecularGraph) = begin
    return first(values(graph.atoms_to_nodes_))
end

getFirstEdge(graph::MolecularGraph) = begin
    return first(values(graph.bonds_to_edges_))
end


"""
    eachNode(graph::MolecularGraph)
Returns a Dict-Values iterator over the nodes in the graph.
"""
eachNode(graph::MolecularGraph) = begin
    return values(graph.atoms_to_nodes_)
end
collectNodes(graph::MolecularGraph) = eachNodes(graph)

"""
    eachPartnerNode(node::AbstractNode)
Gets all the nodes, which are connected to `node` via edges.
"""
eachPartnerNode(node::AbstractNode) = begin
    return [x.source_ == node ? x.target_ : x.source_ for x in values(node.adjacent_edges_)]
end
collectPartnerNodes(node::AbstractNode) = eachPartnerNode(node)

"""
    eachPartnerEdge(node::AbstractNode)
Returns a Dict-Values iterator over the edges adjacent to `node`.
"""
eachPartnerEdge(node::AbstractNode) = begin
    return values(node.adjacent_edges_)
end
collectPartnerEdges(node::AbstractNode) = collectPartnerEdges(node)

"""
    eachEdge(graph::MolecularGraph)
Returns a Dict-Values iterator over the edges in `graph`.
"""
eachEdge(graph::MolecularGraph) = begin
    return values(graph.bonds_to_edges_)
end
collectEdges(graph::MolecularGraph) = collectEdges(graph)

"""
    getNumberOfNodes(graph::MolecularGraph)
Returns the number of Nodes in `graph`.
"""
countNodes(graph::MolecularGraph) = begin
    return length(graph.atoms_to_nodes_)
end


"""
    getNumberOfEdges(graph::MolecularGraph)
Returns the number of Nodes in `graph`.
"""
countEdges(graph::MolecularGraph) = begin
    return length(graph.bonds_to_edges_)
end


"""
    newNode(graph::MolecularGraph, at::Atom, NodeType::Type{typ} = Node) where typ<:AbstractNode
Creates and inserts a node of type `typ`, carrying `at` into `graph`.
"""
newNode(graph::MolecularGraph, at::Atom, NodeType::Type{typ} = Node) where typ<:AbstractNode = begin
    if haskey(graph.atoms_to_nodes_, at)
        return false
    end
    temp::NodeType = NodeType(at)
    graph.atoms_to_nodes_[at] = temp
    return temp
end


"""
    newNode(graph::MolecularGraph, at::DataFrameRow, NodeType::Type{typ} = Node) where typ<:AbstractNode
Creates and inserts a node of type `typ`, carrying `at` into `graph`.
"""
newNode(graph::MolecularGraph, at::DataFrameRow, NodeType::Type{typ} = Node) where typ<:AbstractNode = begin

    println(graph.atoms_to_nodes_," len")
    if haskey(graph.atoms_to_nodes_, at)
        return false
    end
    temp = NodeType(at)
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
newEdge(graph::MolecularGraph, bond::Union{Bond,DataFrameRow}) = begin
    if haskey(graph.bonds_to_edges_, bond)
        return false
    end

    if !haskey(graph.atoms_to_nodes_, bond.source_) || !haskey(graph.atoms_to_nodes_, bond.target_)
        return false
    end

    temp = Edge(graph.atoms_to_nodes_[bond.source_], graph.atoms_to_nodes_[bond.target_], bond)
    graph.bonds_to_edges_[bond] = temp
    push!(graph.atoms_to_nodes_[bond.source_].adjacent_edges_, temp)
    push!(graph.atoms_to_nodes_[bond.target_].adjacent_edges_, temp)
end


"""
    MolecularGraph(root::T, NodeType::Type{typ} = Node) where typ<:AbstractNode where T<:Union{System, Chain, Residue}
Constructs a `MolecularGraph` mirroring the structure of the tree rooted in `root`.
The nodes will be of type `typ`.
"""
MolecularGraph(root::KernelInterface,
                AtomType::Union{Type{DFR}, Type{AtomInterface}},
                EdgeType::Union{Type{AbstractNode}, Type{DFR}},
                BondType::Union{Type{Bond}, Type{DFR}},
                NodeType::Type{typ} = Node) where typ<:AbstractNode = begin
    graph = MolecularGraph(AtomType,EdgeType,BondType,NodeType)#empty graph
    for at in eachAtom(root)
        newNode(graph, at)
    end

    for bond in eachBond(root)
        newEdge(graph, bond)
    end
    return graph
end

MolecularGraph(root::CompositeInterface) = MolecularGraph(root,Atom,Node,Bond)

MolecularGraph(dfs::DataFrameSystem) = MolecularGraph(dfs,DataFrameRow,DataFrameRow ,DataFrameRow)


"""
    breadthFirstSearch(graph::MolecularGraph, root::Node, NodeType::Type{typ} = Node) where typ<:AbstractNode
Generic BFS algorithm, that returns the BFS of `graph` rooted in `root`. The resulting
graph will have nodes of type `typ`.
"""
breadthFirstSearch(graph::MolecularGraph, root::T where T<:AbstractNode, NodeType::Type{typ} = Node) where typ<:AbstractNode = begin
    bfs = MolecularGraph(NodeType)
    q::Queue{NodeType} = Queue{NodeType}()
    visited_nodes::Set{NodeType} = Set{NodeType}()
    cur::NodeType = root
    newNode(bfs, root.atom_, NodeType)
    push!(visited_nodes, root)
    cur = root
    while true
        for edge in eachPartnerEdge(cur)
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
