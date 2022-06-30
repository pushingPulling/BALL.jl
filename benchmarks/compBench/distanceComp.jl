#=
distanceComp:
- Julia version: 
- Author: Dan
- Date: 2021-11-27
=#

push!(LOAD_PATH, "G:\\Python Programme\\BALL.jl\\src\\" )
using BALL

pdb_filepath = "1AKE.pdb"

comp = System(pdb_filepath)

function distanceComp()
    return distance(comp['A'][50], comp['A'][60])
end

distanceComp()
elapsed = @elapsed distanceComp()

println(elapsed)