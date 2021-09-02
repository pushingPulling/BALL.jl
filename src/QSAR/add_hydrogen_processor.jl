#=
add_hydrogen_processor:
- Julia version: 
- Author: Dan
- Date: 2021-07-03
=#

"""
    addHydrogen(composite::CompositeInterface)
Adds Hydrogen to a `composite`. First, the [`SSSR`](@ref) is calculated and aromaticity of the composite
is analyzed, then Hydrogen will be added.
"""
addHydrogen(composite::KernelInterface) = begin
    for residue in eachResidue(composite)
        placePeptideBondH_()
    end

    atom_nr::Int64 = 1
    last_atom::Atom = Atom()
    for atom in eachAtom(composite)
        ring_atoms_::Set{Atom}

        atom_nr_ += 1
        last_atom_ = atom

        if length(getBonds(atom)) ==1 && isAtomatic(first(values(getBonds(atom))))
            continue
        end

        connectivity = getConnectivity(atom)
        sum__bond_orders = countBondOrders(atom)

    end

end