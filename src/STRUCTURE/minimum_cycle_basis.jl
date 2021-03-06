
import BALL.STRUCTURE.breadthFirstSearch
using DataStructures

export BackpointingNode

"""
A specialization of [`SimpleMolecularGraph.Node`](@ref). Adds `Edge`s pointing back to the parent.
"""
mutable struct BackpointingNode <: AbstractNode
    adjacent_edges_ ::Vector{Edge}
    atom_           ::Union{Atom, DataFrameRow}
    parent_         ::BackpointingNode
    BackpointingNode(at::Union{Atom, DataFrameRow}) = (x = new(Edge[], at); x.parent_ = x)
end


"""
    collectPathToRoot(node::BackpointingNode) -> Vector{BackpointingNode}
Collects `BackpointingNode`s from `node` to the root of the tree `node` is in.
"""
collectPathToRoot(node::BackpointingNode) = begin
    path::Vector{BackpointingNode} = BackpointingNode[]
    cur::BackpointingNode = node
    while cur.parent_ != cur
        push!(path, cur)
        cur = cur.parent_
    end
    push!(path, cur)
    return path
end



partnerNodePredicate(edge::Edge, node::BackpointingNode)= begin
    ( (edge.source_ == node && edge.target_ == node.parent_) ||
        (edge.target_ == node && edge.source_ == node.parent_) )
end


"""
    collectBackpathEdges(path::Vector{BackpointingNode})
Collects the `Edge`s that connect the `BackpointingNode`s in `path`.
"""
collectBackpathEdges(path::Vector{BackpointingNode}) = begin
    #make sure path[1] contains a node whose parent you dont care about

    edge_path::Vector{Edge} = Edge[]
    for node in reverse(path[1:end-1])
        pos_in_vector = findfirst(x->partnerNodePredicate(x,node), node.adjacent_edges_)
        pushfirst!(edge_path, node.adjacent_edges_[pos_in_vector])
    end
    return edge_path
end


"""
    breadthFirstSearchMCB(graph::MolecularGraph, root::Node, deep::Bool=true)
A specialization of [`breadthFirstSearch`](@ref) of the [`minimum_cycle_basis`](@ref) algorithm.\n
It uses [`backpointingNode`](@ref)s and unless `deep` is `false` it will calculate a BFS of all
atoms in `graph`.
"""
breadthFirstSearchMCB(graph::MolecularGraph, root::T where T<:AbstractNode, deep::Bool=true) = begin
#iterating over a tree of node with type Node and making a bfs with nodetype BackpointingNode
    bfs = MolecularGraph(BackpointingNode)
    graph_node_type = typeof(getFirstNode(graph))
    q::Queue{graph_node_type} = Queue{graph_node_type}()
    visited_nodes::Set{graph_node_type} = Set{graph_node_type}()

    #init: the root node's parent is itself
    previous_bfs_node::BackpointingNode = newNode(bfs,root.atom_, BackpointingNode)
    temp::BackpointingNode = previous_bfs_node  #dummy initilization to keep temp alive through loop
    push!(visited_nodes, root)
    cur = root
    depth::Int64 = 0

    #do while loop
    while true
        for edge in eachPartnerEdge(cur)
            neighbour::Node = edge.source_ == cur ? edge.target_ : edge.source_
            if !(neighbour in visited_nodes)
                push!(visited_nodes, neighbour)
                enqueue!(q, neighbour)

                temp = newNode(bfs, neighbour.atom_, BackpointingNode)
                temp.parent_ = previous_bfs_node
                newEdge(bfs, edge.bond_)
            end
        end
        isempty(q) && break
        cur = dequeue!(q)
        previous_bfs_node = bfs.atoms_to_nodes_[cur.atom_]
        depth+=1
        if !deep && depth > BALL_HALF_OF_MAX_RING_SIZE
            break
        end
    end
    return bfs
end
breadthFirstSearch(graph::MolecularGraph, root::Node, BackpointingNode) = breadthFirstSearchMCB(graph,root)

"""
    minimum_cycle_basis(graph::MolecularGraph)
Finds the [Minimum Cycle Basis] of `graph` using [`Horton's Algorithm`](https://en.wikipedia.org/wiki/Cycle_basis#Polynomial_time_algorithms).
This algorithm is only correct for undirected Graphs with edgeweight equals 1 for all edges in the graph.
"""
minimum_cycle_basis(graph::MolecularGraph) = begin
    num_nodes = countNodes(graph)
    num_edges = countEdges(graph)

    mcb::Vector{Vector{Edge}} = Vector{Edge}[]
    tested_cycles::Set{Vector{Edge}} = Set{Edge}()

    #optimization: by constructing one big bfs with all the nodes, we can make the setdiff and find out
    #which edges are not in the bfs. Start horton's algo with these nodes, as these will be in a cycle
    bfs = breadthFirstSearchMCB(graph, first(values(graph.atoms_to_nodes_)),true)
    bfs_bonds =  Set([x.bond_ for x in eachEdge(bfs)])
    graph_bonds =  Set([x.bond_ for x in eachEdge(graph)])
    nodes_with_missing_edges = [graph.atoms_to_nodes_[getSource(bond)] for bond in setdiff(graph_bonds, bfs_bonds)]
    graph_nodes = filter(x->!in(x,nodes_with_missing_edges), collect(eachNode(graph)))
    graph_nodes = vcat(nodes_with_missing_edges, graph_nodes)
    i = 1
    #for node in graph_nodes
    for node in graph_nodes
        i += 1
        #only do a bfs of limited depth, as cycles can only have a limited number of atoms
        bfs = breadthFirstSearchMCB(graph, node,false)
        bfs_bonds =  Set([x.bond_ for x in eachEdge(bfs)])
        graph_bonds =  Set([x.bond_ for x in eachEdge(graph)])
        edges_not_in_bfs = [graph.bonds_to_edges_[x] for x in setdiff(graph_bonds, bfs_bonds)]
        #each edge that is not in the bfs will create a cycle if restored
        for edge in edges_not_in_bfs
            #create cycles and put them into mcb or prune them
            #let `edge` = (w,x). Make the cycle: Path(w to node) + Path(x to node) + (w,x)
            #but only if node is the lowest common ancestor of w,x

            w::BackpointingNode = bfs.atoms_to_nodes_[edge.source_.atom_]
            x::BackpointingNode = bfs.atoms_to_nodes_[edge.target_.atom_]
            w_nodes = collectPathToRoot(w)
            x_nodes = collectPathToRoot(x)
            #if node is not the lca then the 2nd-to-last node on the paths will be the same
            if w_nodes[end-1] == x_nodes[end-1]
                continue;
            end
            w_path = collectBackpathEdges(w_nodes)
            x_path = collect(reverse(collectBackpathEdges(x_nodes)))

            new_cycle = vcat(w_path, x_path, edge)
            (new_cycle in tested_cycles) && break
            push!(tested_cycles, new_cycle)

            #test if linearly independent
            for (i,cyc1) in enumerate(mcb)
                for cyc2 in mcb[i+1:end]
                    (new_cycle == symdiff(cyc1, cyc2)) && break
                end
            end

            pos_in_mcb = findfirst(x->length(x) > length(new_cycle), mcb)
            isnothing(pos_in_mcb) && (pos_in_mcb = 1)
            insert!(mcb, pos_in_mcb, new_cycle)

            if length(mcb) == num_edges - num_nodes +1
                return mcb
            end
        end
    end
end

