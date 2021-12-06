#=
spatial:
- Julia version: 
- Author: Dan
- Date: 2021-10-05
=#
export ramachandranangles, dihedralangle, phiangle, phiangles, psiangle, psiangles, rmsd, distance

ramachandranangles(kern::KernelInterface) = begin
    phiangles(kern), psiangles(kern)
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
dihedralangle(at_a::Union{DataFrameRow,AtomInterface}, at_b::Union{DataFrameRow,AtomInterface},
                at_c::Union{DataFrameRow,AtomInterface}, at_d::Union{DataFrameRow,AtomInterface}) =
    dihedralangle(
        coords(at_b) - coords(at_a),
        coords(at_c) - coords(at_b),
        coords(at_d) - coords(at_c)
    )

dihedralangle(vec_a::SVector{3,Float64}, vec_b::SVector{3,Float64}, vec_c::SVector{3,Float64}) =
    return atan(
        dot(cross(cross(vec_a, vec_b), cross(vec_b, vec_c)), vec_b / norm(vec_b)),
        dot(cross(vec_a, vec_b), cross(vec_b, vec_c)))


phiangle(prev_res::Union{T, DataFrameRow}, res::Union{T, DataFrameRow}) where T<: ResidueInterface = begin

    if !sequentialResidues(prev_res, res)
        return NaN
    end

    child_names_res::Vector{String} = [x.name_ for x in getChildren(res)]
    child_names_prev_res::Vector{String} = [x.name_ for x in getChildren(prev_res)]
    if !in("C", child_names_prev_res) && !all(in(x, child_names_res) for x in ["C", "CA","N"])
        return NaN
    else
        c_atom_prev::Union{AtomInterface, DataFrameRow} = getChildren(prev_res)[findfirst(x -> x == "C", child_names_prev_res)]
        n_atom::Union{AtomInterface, DataFrameRow} = getChildren(res)[findfirst(x -> x == "N", child_names_res)]
        ca_atom::Union{AtomInterface, DataFrameRow} = getChildren(res)[findfirst(x -> x == "CA", child_names_res)]
        c_atom::Union{AtomInterface, DataFrameRow} = getChildren(res)[findfirst(x -> x == "C", child_names_res)]
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

psiangle(res::Union{T, DataFrameRow}, res_next::Union{T, DataFrameRow}) where T<: ResidueInterface = begin

    if !sequentialResidues(res, res_next)
        return NaN
    end

    child_names_res::Vector{String} = [x.name_ for x in getChildren(res)]
    child_names_next_res::Vector{String} = [x.name_ for x in getChildren(res_next)]
    if !in("N", child_names_next_res) && !all(in(x, child_names_res) for x in ["C", "CA","N"])
        return NaN
    else
        n_atom::Union{AtomInterface, DataFrameRow} = getChildren(res)[findfirst(x -> x == "N", child_names_res)]
        n_atom_next::Union{AtomInterface, DataFrameRow} = getChildren(res_next)[findfirst(x -> x == "N", child_names_next_res)]
        ca_atom::Union{AtomInterface, DataFrameRow} = getChildren(res)[findfirst(x -> x == "CA", child_names_res)]
        c_atom::Union{AtomInterface, DataFrameRow} = getChildren(res)[findfirst(x -> x == "C", child_names_res)]
        return dihedralangle(n_atom, ca_atom, c_atom, n_atom_next)
    end
end

psiangles(kern::KernelInterface) = begin
    res_list = collectResidues(kern)
    if length(res_list) < 2
        throw(ArgumentError("At least 2 residues required to calculate dihedral angles"))
    end

    psi_angles = Float64[]

    for i in 1:length(res_list) -1
        res = res_list[i]
        res_next = res_list[i + 1]
        push!(psi_angles, psiangle(res, res_next))
    end

    push!(psi_angles, NaN)
    return psi_angles
end




rmsd(dfs1::DataFrameSystem, dfs2::DataFrameSystem; calphaonly=true) = begin
    if calphaonly
        atoms1 = filter(x -> getName(x) == "CA", dfs1.atoms)
        atoms2 = filter(x -> getName(x) == "CA", dfs2.atoms)
    else
        atoms1 = dfs1.atoms
        atoms2 = dfs2.atoms
    end
    if length(atoms1) != length(atoms2)
        throw(ArgumentError("Inputs are of size $(length(atoms1)) and " *
                            "$(length(atoms2)) but must be the same for RMSD"))
    end
    diff = getPosition(atoms1) - getPosition(atoms2)
    return sqrt.(dot(diff,diff) / length(diff))
end

rmsd(comp1::CompositeInterface, comp2::CompositeInterface,calphaonly=true) = begin
    if calphaonly
        atoms1 = filter(x -> getName(x) == "CA", eachAtom(comp1))
        atoms2 = filter(x -> getName(x) == "CA", eachAtom(comp2))
    else
        atoms1 = dfs1.atoms
        atoms2 = dfs2.atoms
    end
    if length(atoms1) != length(atoms2)
        throw(ArgumentError("Inputs are of size $(length(atoms1)) and " *
                            "$(length(atoms2)) but must be the same for RMSD"))
    end
    diff = getPosition(atoms1) - getPosition(atoms2)
    return sqrt.(dot(diff,diff) / length(diff))
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


