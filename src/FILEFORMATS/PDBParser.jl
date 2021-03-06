
import ..KERNEL.System



"Save information needed to identify a SSBond"
struct SSBond    #Tuple of chain_id and residue_number
    chain_id::Char
    res_num::Int64
end

"Packages the parsed fields from a conect line in a struct to avoid allocations"
mutable struct ConectLineParams
    bonding_atoms::Vector{Int}
    tokens::Vector{String}

end

"Packages the parsed fields from an atom line in a struct to avoid allocations"
mutable struct AtomLineParams
    name::String
    x::Float64
    y::Float64
    z::Float64
    elem::String
    occupancy::Union{Float64,Nothing}
    temp_factor::Union{Float64,Nothing}
    charge::Union{Float64,Nothing}
    serial::Int64

    AtomLineParams() = new()
end

"""
    parseConectLine(line::String)
Parses a line starting with "CONNECT" in a PDB file.
"""
parseConectLine(params::ConectLineParams, line::String) = begin

    if length(line) == 16
        push!(params.tokens, line[12:16])
    elseif length(line) == 21
       push!(params.tokens, line[12:16], line[17:21])
    elseif length(line) == 26
        push!(params.tokens, line[12:16], line[17:21],
                line[22:26])
    else
        push!(params.tokens, line[12:16], line[17:21],
                line[22:26], line[27:31])
    end

    for x in params.tokens
        if strip(x) != ""
            push!(params.bonding_atoms, parse(Int,strip(x)))
        end
    end
    return params
end

"""
    parseAtomLine(line::String)
Parses a line starting with "ATOM" or "HET" in a PDB file.
"""
parseAtomLine(params::AtomLineParams, line::String) = begin

    params.name = strip(line[13:16])
    params.x = parse(Float64,line[31:38])
    params.y = parse(Float64,line[39:46])
    params.z = parse(Float64,line[47:54])
    params.elem = strip(line[77:78])
    params.occupancy = strip(line[55:60]) == "" ? nothing : parse(Float64,line[55:60])
    params.temp_factor = strip(line[61:66]) == "" ? nothing : parse(Float64,line[61:66])

    if length(line) >= 80
        params.charge = strip(line[79:80]) == "" ? nothing : parse(Float64,line[79:80])
    else
        params.charge = nothing
    end

    result = Atom(params.name,params.x,params.y,params.z,params.elem,params.charge,
                    params.occupancy,params.serial,params.temp_factor)::Atom
    if startswith(line,"HET")
        setProperty(result,(:hetero,true))
    end

    return result
end


"""
    compare_ssbonds(b1::SSBond, b2::SSBond)
Comparison function for sorting.
"""
compare_ssbonds(b1::SSBond, b2::SSBond) = begin
    b1.chain_id < b2.chain_id && return true
    b1.chain_id == b2.chain_id && b1.res_num < b2.res_num && return true
    return false
end


"""
    parseSSBondLine(line::String)
Parses a line starting with "SSOBND" ina PDB file.
"""
parseSSBondLine(line::String) = begin
    ssbond1::SSBond = SSBond(line[16], parse(Int,strip(line[18:21])))
    ssbond2::SSBond = SSBond(line[30] ,parse(Int,strip(line[32:35])))
    return (ssbond1, ssbond2)
end #returns 2 ssbonds
#only use following Function to build a System initially



"""
    adjust_ter_indices(indices::Vector{Int64}, ter_pos::Vector{Int64})
Adjusts the indices in a list of stom serials read from a PDB file. The "TER" entries in PDB files
have a serial number like the Atoms, which makes the serial numbers not continuous.
"""
adjust_ter_indices(indices::Vector{Int64}, ter_pos::Vector{Int64}) = begin
    for i in 1:length(indices)
         c = 0
         for ter in ter_pos
            if indices[i] > ter
                c += 1
            end
         end
         indices[i] -= c
    end
    return indices
end
adjust_ter_indices(x::Int64, ter_pos::Vector{Int64}) = adjust_ter_indices([x],ter_pos)



"""
    parsePDB(path::String)
Parses a PDB file from `path`. Creates a representation using [`KERNEL`](@ref KERNEL_header) types.\n
If the file has multiple models the property \"fromNMR\" is added to `root`.
See [Hint](https://www.wwpdb.org/documentation/file-format-content/format33/sect9.html#MODEL).
"""
parsePDB(path::String) = begin
     # `ssbonds` holds all the ssbonds in order of appearance in the file
    ssbonds::Vector{SSBond} = Vector{SSBond}()

    # When reading the atoms from the file, relate the atom to an SSBond endpoint
    ssbonds_to_atoms::Dict{SSBond, Int64} = Dict{SSBond, Int64}() #mapping ssbonds to atom serial number

    #List of pairs of atoms bonded by a SSBond
    ssbond_pairs::Vector{Tuple{SSBond,SSBond}} = Vector{Tuple{SSBond,SSBond}}()

    current_ssbond_index::Int = 1

    root::System = System()
    target_system::System = System()
    atoms::Vector{Atom} = Atom[]
    ter_positions::Vector{Int} = Int64[]

    latest_chain::Chain = Chain()  #assume chains are named in alphabetical order with capitalized letters
    latest_residue::Residue = Residue()
    latest_residue.res_number_ = -127   #init value, which hopefully is NOT the same as the first residue-number in the file
    atom_counter::Int = 0


    latest_chain.id_ = '-'  #init value, which hopefully is NOT the same as the first chain id in the file
    appendChild(target_system, latest_chain)

    seen_header::Bool = false::Bool
    ready_to_sort_ssbonds::Bool = false
    seen_ssbonds::Bool = false
    seen_atoms::Bool = false
    seen_model::Bool = false

    #init fields for parsing a "CONECT" line
    conect_line_params::ConectLineParams = ConectLineParams(Int[],String[])

    #init fields for parsing a "ATOM" line
    atom_line_params::AtomLineParams = AtomLineParams()

    record_residue_name::String = ""



    open(path) do file
        for line in eachline(file)
            #header
            if !seen_header && startswith(line,"HEADER")
                if length(line) >= 66
                    root.name_ = strip(line[63:66])
                end
                seen_header = true::Bool
            end


            if startswith(line,"TER")
                push!(ter_positions, parse(Int64,strip(line[7:11])))
            end


            #save infos about the atoms which participate in ssbonds
            if !seen_ssbonds && startswith(line, "SSBOND")
                pair = parseSSBondLine(line)
                push!(ssbond_pairs, pair)
                push!(ssbonds, pair...)
                ready_to_sort_ssbonds = true
            end

            #after having seen all of the ssbonds sort them to later find the correct atoms easier
            if ready_to_sort_ssbonds && !startswith(line,"SSBOND")
                seen_ssbonds = true
                ready_to_sort_ssbonds = false
                sort!(ssbonds, alg=InsertionSort, lt = compare_ssbonds)
            end

            #atoms of name "SG" belong to ssbonds. associate atom to ssbond entry
            if (current_ssbond_index <= length(ssbonds)) && startswith(line,"ATOM") &&
                                                           (strip(line[13:16]) == "SG")
                #find items from SSBOND
                current_ssbond = ssbonds[current_ssbond_index]
                #replace "SG" with a list of possible names of atoms which engage in ssbonds
                if line[22] == current_ssbond.chain_id && current_ssbond.res_num ==  parse(Int,strip(line[23:26]))
                    ssbonds_to_atoms[current_ssbond] = adjust_ter_indices(parse(Int64,strip(line[7:11])), ter_positions)[1]
                    current_ssbond_index += 1
                end
            end



            #model lines - means we need to construct a new model
            if startswith(line,"MODEL")
                if !seen_model
                    nothing
                else
                    #finalize target_system and append it to system
                    appendChild(root, target_system)
                    target_system = System()
                    latest_chain = Chain()
                    latest_chain.id_ = 'A'

                    prev_residue_name = latest_residue.name_
                    latest_residue = Residue()
                    latest_residue.res_number_ = 1
                    latest_residue.name_ = prev_residue_name
                    latest_residue.is_hetero_ = false

                    appendChild(target_system, latest_chain)
                    appendChild(latest_chain, latest_residue)
                    atom_counter = 0
                end
                seen_model = true
            end

            if (!seen_atoms && startswith(line,"ATOM") ||
                                !seen_atoms && startswith(line,"HETATM"))  &&
                                line[17] in (' ','A')
                atom_counter += 1
                record_chain_id = line[22]
                latest_chain.id_ == '-' && (latest_chain.id_ = record_chain_id)
                record_residue_name = strip(line[18:20])
                record_residue_number = parse(Int64,strip(line[23:26]))

                #create chain if new chain
                if record_chain_id != latest_chain.id_
                    #is the next residues belong to another chain, create the chain
                    latest_chain = Chain()
                    latest_chain.id_ = record_chain_id
                    appendChild(target_system, latest_chain)
                end

               if record_residue_number != latest_residue.res_number_
                    latest_residue = Residue()
                    latest_residue.res_number_ = record_residue_number
                    latest_residue.name_ = record_residue_name
                    latest_residue.is_hetero_ = false
                    if latest_residue.name_ in Amino_Acids
                        setProperty(latest_residue, (:amino_acid,true))
                    end
                    appendChild(latest_chain, latest_residue)

                end
               #create atoms
                atom_line_params.serial = atom_counter
                parsed_atom::Atom = parseAtomLine(atom_line_params, line)
                #the only property right now can be the hetero property
                if length(parsed_atom.properties_) != 0
                    latest_residue.is_hetero_ = true
                end

                appendChild(latest_residue, parsed_atom)
            end


            if startswith(line, "CONECT")
                if seen_atoms == false
                    seen_atoms = true
                    atoms = collectAtoms(target_system)
                end

                if seen_model
                    appendChild(root, target_system)
                end

                empty!(conect_line_params.bonding_atoms)
                empty!(conect_line_params.tokens)
                bonding_atom_serials = parseConectLine(conect_line_params, line).bonding_atoms
                bonding_atom_serials = adjust_ter_indices(bonding_atom_serials, ter_positions)
                for serial in bonding_atom_serials[2:end]
                    createBond(atoms[bonding_atom_serials[1]], atoms[serial],
                                order=ORDER__SINGLE, type=TYPE__COVALENT)
                end
            end
        end
    end

    #for each ssbond pair, make a bond betwen the two corresponding atoms using the dict
    for (ssbond1, ssbond2) in ssbond_pairs
        deleteBond(atoms[ssbonds_to_atoms[ssbond1]], atoms[ssbonds_to_atoms[ssbond2]])
        a = createBond(atoms[ssbonds_to_atoms[ssbond1]], atoms[ssbonds_to_atoms[ssbond2]],
                                order=ORDER__SINGLE, type=TYPE__DISULPHIDE_BRIDGE)
    end


    if root.name_ == ""
        temp = findlast("/",path)
        if isnothing(temp)
           root_name_ = path[1:end-4]
        else
            root.name_ = path[temp[1]+1:end-4]
        end
    end

    if !seen_model
        target_system.name_ = root.name_
        i = 1
        for chain in collectChains(target_system)
            if chain.id_ < 'A'+(i-1)
                idx = Int(chain.id_) - Int('A') +1
                if idx < 1      #catch chains with empty/too low char
                    chain.id_ = 'A'+(i-1)
                    i += 1
                    continue
                end
                ch_l = collectChains(target_system)[idx]
                appendSibling(ch_l.last_child_, chain.first_child_)
                removeChild(chain)
            else
                chain.id_ = 'A'+(i-1)
                i += 1
            end
        end

        return target_system
    else
        setProperty(root,("fromNMR",true))
        for (num,system) in enumerate(collectSystems(root)[2:end])
            system.name_ = root.name_*"-"*string(num)
            i = 1
            for chain in collectChains(target_system)
                if chain.id_ < 'A'+(i-1)
                    idx = Int(chain.id_) - Int('A') +1
                    ch_l = collectChains(target_system)[idx]
                    appendSibling(ch_l.last_child_, chain.first_child_)
                    removeChild(chain)
                else
                    chain.id_ = 'A'+(i-1)
                    i += 1
                end
            end
        end

        #copy bonds over
        last_sys = last(getChildren(root))
        last_sys_bonds = collectBonds(last_sys)
        atom_serials_pairs::Vector{Tuple{Int64, Int64}} = [(bond.source_.serial_, bond.target_.serial_)
                                                        for bond in last_sys_bonds]

        for sys in getChildren(root)
            atoms = collectAtoms(sys)
            for bond in last_sys_bonds
                createBond(atoms[bond.source_.serial_], atoms[bond.target_.serial_],
                            name = bond.name_, order = bond.bond_order_, type = bond.bond_type_,
                            properties = bond.properties_)
            end

        end
        return root
    end


    return root
end


# BioStructures reads structure and internal parser only the bonds
"""
    System(path::String)
Constructs a `System` from a PDB file at `path`.
"""
function System(path::String)
    if endswith(path, ".pdb")
        root = parsePDB(path)::System
        for sys in collectSystems(root)
            sys.number_of_children_ = countChildren(sys)

        end
        return root
    end
end
