#=
spatial:
- Julia version: 
- Author: Dan
- Date: 2021-10-05
=#
export ramachandranangles, dihedralangle, phiangle, phiangles, psiangle, psiangles, rmsd, distance, ramaview,
    newrama,phis,psis, newdist

ramachandranangles(kern::KernelInterface) = begin
    phiangles(kern), psiangles(kern)
end

ramachandranangles(kern::DataFrameSystem) = begin
    phiangles(kern), psiangles(kern)
end

ramaview(kern::DataFrameSystem) = begin
    phianglesview(kern), psianglesview(kern)
end

"""
    dihedralangle(atom_a, atom_b, atom_c, atom_d)
    dihedralangle(vec_ab, vec_bc, vec_cd)
Calculate the dihedral angle in radians defined by four `AbstractAtom`s or
three vectors.
The angle between the planes defined by atoms (A, B, C) and (B, C, D) is
returned in the range -π to π.
Credit to this function goes to [BioStructures](https://doi.org/10.1093/bioinformatics/btaa502)
"""
dihedralangle(at_a::Union{DataFrameRow,AbstractAtom}, at_b::Union{DataFrameRow,AbstractAtom},
                at_c::Union{DataFrameRow,AbstractAtom}, at_d::Union{DataFrameRow,AbstractAtom}) =
    dihedralangle(
        coords(at_b) - coords(at_a),
        coords(at_c) - coords(at_b),
        coords(at_d) - coords(at_c)
    )

dihedralangle(vec_a::SVector{3,Float64}, vec_b::SVector{3,Float64}, vec_c::SVector{3,Float64}) =
    return atan(
        dot(cross(cross(vec_a, vec_b), cross(vec_b, vec_c)), vec_b / norm(vec_b)),
        dot(cross(vec_a, vec_b), cross(vec_b, vec_c)))


phiangle(prev_res::Union{T, DataFrameRow}, res::Union{T, DataFrameRow}) where T<: AbstractResidue = begin

    if !sequentialResidues(prev_res, res)
        return NaN
    end

    children = getChildren(res)
    child_names_res::Vector{String} = [x.name_ for x in children]
    child_names_prev_res::Vector{String} = [x.name_ for x in getChildren(prev_res)]
    if !in("C", child_names_prev_res) && !all(in(x, child_names_res) for x in ["C", "CA","N"])
        return NaN
    else
        c_atom_prev::Union{AbstractAtom, DataFrameRow} = getChildren(prev_res)[findfirst(x -> x == "C", child_names_prev_res)]
        n_atom::Union{AbstractAtom, DataFrameRow} =  children[findfirst(x -> x == "N", child_names_res)]
        ca_atom::Union{AbstractAtom, DataFrameRow} = children[findfirst(x -> x == "CA", child_names_res)]
        c_atom::Union{AbstractAtom, DataFrameRow} =  children[findfirst(x -> x == "C", child_names_res)]
        return dihedralangle(c_atom_prev, n_atom, ca_atom, c_atom)
    end
end


phiangles(kern::KernelInterface) = begin
    res_list = collectResidues(kern)
    if length(res_list) < 2
        throw(ArgumentError("At least 2 residues required to calculate dihedral angles"))
    end

    phi_angles = Float64[NaN]

    for i in 2:length(res_list)
        res = res_list[i]
        res_prev = res_list[i - 1]
        push!(phi_angles, phiangle(res_prev, res))
    end

    return phi_angles
end

phiangles(kern::DataFrameSystem) = begin
    res_list = eachResidue(kern)
    if length(res_list) < 2
        throw(ArgumentError("At least 2 residues required to calculate dihedral angles"))
    end

    phi_angles = Float64[NaN]

    for i in 2:length(res_list)
        res = res_list[i]
        res_prev = res_list[i - 1]
        push!(phi_angles, phiangle(res_prev, res))
    end

    return phi_angles
end


psiangle(res::Union{T, DataFrameRow}, res_next::Union{T, DataFrameRow}) where T<: AbstractResidue = begin

    if !sequentialResidues(res, res_next)
        return NaN
    end

    children = getChildren(res)
    child_names_res::Vector{String} = [x.name_ for x in children]
    child_names_next_res::Vector{String} = [x.name_ for x in getChildren(res_next)]
    if !in("N", child_names_next_res) && !all(in(x, child_names_res) for x in ["C", "CA","N"])
        return NaN
    else
        n_atom::Union{AbstractAtom, DataFrameRow} = children[findfirst(x -> x == "N", child_names_res)]
        n_atom_next::Union{AbstractAtom, DataFrameRow} = getChildren(res_next)[findfirst(x -> x == "N", child_names_next_res)]
        ca_atom::Union{AbstractAtom, DataFrameRow} = children[findfirst(x -> x == "CA", child_names_res)]
        c_atom::Union{AbstractAtom, DataFrameRow} = children[findfirst(x -> x == "C", child_names_res)]
        return dihedralangle(n_atom, ca_atom, c_atom, n_atom_next)
    end
end




psiangles(kern::KernelInterface) = begin
    res_list = collectResidues(kern)
    if length(res_list) < 2
        throw(ArgumentError("At least 2 residues required to calculate dihedral angles"))
    end

    psi_angles = Float64[]

    res = res_list[1]
    for i in 2:length(res_list)
        res_next = res_list[i]
        push!(psi_angles, psiangle(res, res_next))
        res = res_next
    end

    push!(psi_angles, NaN)
    return psi_angles
end



rmsd(comp1, comp2;calphaonly::Bool=true) = begin
    if calphaonly
        atoms1 = filter(x -> getName(x) == "CA", collectAtoms(comp1))
        atoms2 = filter(x -> getName(x) == "CA", collectAtoms(comp2))
    else
        atoms1 = collectAtoms(comp1)
        atoms2 = collectAtoms(comp2)
    end
    if length(atoms1) != length(atoms2)
        throw(ArgumentError("Inputs are of size $(length(atoms1)) and " *
                            "$(length(atoms2)) but must be the same for RMSD"))
    end
    diff = getPosition(atoms1) - getPosition(atoms2)
    return sqrt(dot(diff,diff) / length(diff))::Float64
end



distance(el1::Union{KernelInterface,AbstractDataFrame, DataFrameRow},
    el2::Union{KernelInterface,AbstractDataFrame, DataFrameRow}) = begin
    return sqrt(squaredDistance(el1,el2))
end


squaredDistance(comp1::Union{KernelInterface,AbstractDataFrame, DataFrameRow},
    comp2::Union{KernelInterface,AbstractDataFrame, DataFrameRow}) = begin
    atoms1 = collect(eachAtom(comp1))
    atoms2 = collect(eachAtom(comp2))
    min_dist = Inf
    for i = 1:length(atoms1)
        for j = i:length(atoms2)
            cur_dist::Float64 = sum( ( getPosition(atoms1[i]) - getPosition(atoms2[j]) ).^2)
            min_dist = min(min_dist, cur_dist)
        end
    end
    return min_dist
end


psis(kern::KernelInterface) = begin
    res_list = kern.residues
    if length(res_list) < 2
        throw(ArgumentError("At least 2 residues required to calculate dihedral angles"))
    end

    psi_angles = Float64[]

    res = res_list[1]
    next_atom_c, next_atom_ca, next_atom_n = getDihedralAtoms(res)

    for i in 2:length(res_list)
        #get current n, ca, c
        atom_c, atom_ca, atom_n = next_atom_c, next_atom_ca, next_atom_n

        res_next = res_list[i]

        dihedral_atoms = getDihedralAtoms(res_next)
        if !isnothing(dihedral_atoms)
            next_atom_c, next_atom_ca, next_atom_n = dihedral_atoms
            push!(psi_angles, dihedralangle(atom_n,atom_ca,atom_c,next_atom_n) )
        else
            push!(psi_angles, NaN)
        end

        res = res_next
    end


    push!(psi_angles, NaN)
    return psi_angles
end

phis(kern::KernelInterface) = begin
    res_list = kern.residues
    if length(res_list) < 2
        throw(ArgumentError("At least 2 residues required to calculate dihedral angles"))
    end

    phi_angles = Float64[NaN]

    res = res_list[1]
    atom_c, _, _ = getDihedralAtoms(res)

    for i in 2:length(res_list)
        prev_atom_c = atom_c
        res_next = res_list[i]
        dihedral_atoms = getDihedralAtoms(res_next)
        if !isnothing(dihedral_atoms)
            atom_c, atom_ca, atom_n = dihedral_atoms
            push!(phi_angles, dihedralangle(prev_atom_c,atom_n,atom_ca,atom_c) )
        else
            push!(phi_angles, NaN)
        end
        res = res_next
    end


    return phi_angles
end

const SubvectorType{T} = SubArray{T, 1, Vector{T}, Tuple{UnitRange{Int64}}, true}
getDihedralAtoms(row) = begin
    children = viewChildren(row)
    idxc::Int = 0
    idxca::Int = 0
    idxn::Int = 0
    for (idx, name::String) in enumerate(children.name_::SubvectorType{Union{Nothing, String}})
        if name =="N"
            idxn = idx
        end
        if name =="CA"
            idxca = idx
        end
        if name =="C"
            idxc = idx
        end
    end
    if 0 in (idxc, idxca,idxn)
        return nothing
    end
    return (children[idxc],children[idxca],children[idxn])
end

newrama(kern::DataFrameSystem) = begin
    phis(kern), psis(kern)
end



function newdist(dfs::DataFrameSystem)
    res1 = dfs.residues[51]
    res2 = dfs.residues[61]
    res1children = viewChildren(res1)
    res2children = viewChildren(res2)
    min_dist::Float64 = Inf
    for x::Int in 1:length(res1children.position_::SubvectorType{SVector{3, Float64}})
        for y::Int in x:length(res2children.position_::SubvectorType{SVector{3, Float64}})
            min_dist = min(min_dist, sum((res1children.position_[x]::SVector{3,Float64} -
                                            res2children.position_[y]::SVector{3,Float64}).^2))
        end
    end

    return min_dist
end