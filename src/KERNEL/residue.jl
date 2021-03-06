#=
fragment:
- Julia version:
- Author: Dan
- Date: 2021-06-01
=#
import .CONCEPT.getName
export Residue, isAminoAcid, isNTerminal, isHetero

"Represents a Residue (e.g. An Amino-Acid). See also [`AbstractComposite`](@ref)."
mutable struct Residue <: AbstractResidue
    name_                                       ::Union{String,Nothing}
    number_of_children_                         ::Union{Int64,Nothing}
    parent_                                     ::Union{Nothing,AbstractComposite}
    previous_                                   ::Union{Nothing,AbstractComposite}
    next_                                       ::Union{Nothing,AbstractComposite}
    first_child_                                ::Union{Nothing,AbstractComposite}
    last_child_                                 ::Union{Nothing,AbstractComposite}
    properties_                                 ::Vector{Tuple{Symbol,Any}}
    contains_selection_                         ::Union{Bool,Nothing}
    number_of_selected_children_                ::Union{Int64,Nothing}
    number_of_children_containing_selection_    ::Union{Int64,Nothing}
    selection_stamp_                            ::Union{TimeStamp,Nothing}
    modification_stamp_                         ::Union{TimeStamp,Nothing}
    trait_                                      ::Union{Nothing,AbstractComposite}
    insertion_code_                             ::Union{Char,Nothing}
    is_disordered_                              ::Union{Bool,Nothing}
    res_number_                                 ::Union{Int64,Nothing}
    is_hetero_                                  ::Union{Bool,Nothing}
    selected_                                   ::Bool

    Residue() = new(nothing,nothing,nothing,nothing,nothing,nothing,nothing,Vector{Tuple{String,UInt8}}(),nothing,nothing,nothing,nothing,nothing,nothing,
    nothing,nothing,nothing,nothing,false)

    Residue(name_                                   ::Union{String,Nothing},
            number_of_children_                         ::Union{Int64,Nothing},
            parent_                                     ::Union{Nothing,AbstractComposite},
            previous_                                   ::Union{Nothing,AbstractComposite},
            next_                                       ::Union{Nothing,AbstractComposite},
            first_child_                                ::Union{Nothing,AbstractComposite},
            last_child_                                 ::Union{Nothing,AbstractComposite},
            properties_                                 ::Vector{Tuple{Symbol,Any}},
            contains_selection_                         ::Union{Bool,Nothing},
            number_of_selected_children_                ::Union{Int64,Nothing},
            number_of_children_containing_selection_    ::Union{Int64,Nothing},
            selection_stamp_                            ::Union{TimeStamp,Nothing},
            modification_stamp_                         ::Union{TimeStamp,Nothing},
            trait_                                      ::Union{Nothing,AbstractComposite},
            insertion_code_                             ::Union{Char,Nothing},
            is_disordered_                              ::Union{Bool,Nothing},
            res_number_                                 ::Union{Int64,Nothing},
            is_hetero_                                  ::Union{Bool,Nothing},
            selected_                                   ::Union{Bool,Nothing}) = new(


            name_,
            number_of_children_,
            parent_,
            previous_,
            next_,
            first_child_,
            last_child_,
            properties_,
            contains_selection_,
            number_of_selected_children_,
            number_of_children_containing_selection_,
            selection_stamp_,
            modification_stamp_,
            trait_,
            insertion_code_,
            is_disordered_,
            res_number_,
            is_hetero_,
            selected_
        )
end
Residue(res_name::String,num_of_children::Int64, ins_code::Char, res_number::Int64,hetero::Bool) =
    Residue(res_name,num_of_children,nothing,nothing,nothing,nothing,nothing,
            Vector{Tuple{String,UInt8}}(),nothing,nothing,nothing,nothing,nothing,nothing,
            ins_code, false,res_number,hetero,false)




getName(res::Residue) = !isnothing(res.name_) ? (res.name_) : "N/A"
"""
    isAminoAcid(res::Residue)
Checks if `res` is an [Amino Acid](@ref ).
"""
isAminoAcid(res::Residue) = return hasProperty(res, ("amino_acid",true) )

"""
    isNTerminal(res::Residue)
Checks if `res` is a [N-Terminus](https://en.wikipedia.org/wiki/N-terminus).
"""

isNTerminal(res::Residue) = begin
    !isAminoAcid(res) && return false
    chain = res.parent_
    typeof(chain) == Residue && return false
    residues = collectResidues(chain)
    current_res = residues[1]
    for x in residues
        if (x == res) || (!isAminoAcid(x))
            current_res = x
            break
        end
    end
    return (current_res == res)
end

Base.show(io::IO, res::Residue) =
    print(io,
    "$(getName(res)), ",
    "$(countAtoms(res)) atoms"
)

isHetero(res::Residue) = res.is_hetero_