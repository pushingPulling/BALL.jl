
export
    AtomBijection, calculateRMSD, assignByName, assignCAlphaAtoms, assignBackboneAtoms

"""
    AtomBijection
`AtomBijection` is a bijective Map of `Atom`s. Read usage at [Bijection's documentation](https://github.com/scheinerman/Bijections.jl#using-a-bijection)
"""
const AtomBijection = Bijection{Atom,Atom}


"""
    calculateRMSD(bijec::AtomBijection)
Gets the [Root-mean-square-deviation](https://en.wikipedia.org/wiki/Root-mean-square_deviation)
of the atom in `bijec`.
"""
function calculateRMSD(bijec::AtomBijection)
    sum_of_squares::Float64 = 0
    for (left_at, right_at) in bijec
        sum_of_squares += sqeuclidean(left_at.position_,right_at.position_)
    end
    sum_of_squares = sqrt(sum_of_squares / length(bijec))
    return sum_of_squares
    #= julia alternative
    return sqrt(sum(map(sqeuclidean, keys(bijec), values(bijec)))) / length(bijec))
    =#
end


"""
Maps atoms in `A` to atoms of equal name in `B`.
"""
function assignByName(A::T,  B::S, limit_to_selection::Bool) where {T,S<:AtomInterface}
    result = AtomBijection()
    A_names = Dict{String, Atom}([(atom.name_, atom) for atom in collectAtoms(A) ])
    for atom in collectAtoms(B)
        if haskey(A_names,atom.name_) &&
                    ( !limit_to_selection || isSelected(atom) || isSelected(A_names[atom.name_]))
             result[A_names[atom.name_]] = atom
        end
        delete!(A_names, atom.name_)
    end
    return result
end

"""
    assignCAlphaAtoms(A::Composite,  B::Composite, ::Bool)
Maps C-alpha atoms in `A` to C-alpha atoms in `B`.
"""
function assignCAlphaAtoms(A::CompositeInterface,  B::CompositeInterface, limit_to_selection::Bool) where {T,S<:AtomInterface}
    result = AtomBijection()
    res_list_A= collectResidues(A)
    res_list_B= collectResidues(B)
    for (res_A,res_B) in zip(res_list_A,res_list_B)
        at_A = getAtom(res_A,"CA")
        at_B = getAtom(res_B,"CA")
        if !isnothing(at_A) && !isnothing(at_B) &&
                                    (!limit_to_selection || isSelected(at_a) || isSelected(at_B))
            result[at_A] = at_B
        end
    end
    return result
end

"""
    assignBackboneAtoms(A::Composite, B::Composite, limit_to_selection::Bool)
Maps the backbone atoms in `A` to the backbone atoms in `B`.
"""
assignBackboneAtoms(A::CompositeInterface, B::CompositeInterface, limit_to_selection::Bool) where {T,S<:AtomInterface} = begin
    result = AtomBijection()
    res_list_A= collectResidues(A)
    res_list_B= collectResidues(B)
    for (res_A,res_B) in zip(res_list_A,res_list_B)
        backbone_atoms = String["CA", "C", "H", "O", "N"]
        for at_name in backbone_atoms
            at_A = getAtom(res_A,at_name)
            at_B = getAtom(res_B,at_name)

            if !isnothing(at_A) && !isnothing(at_B) &&
                                    (!limit_to_selection || isSelected(at_a) || isSelected(at_B))
                result[at_A] = at_B
            end
        end
    end
    return result
end
