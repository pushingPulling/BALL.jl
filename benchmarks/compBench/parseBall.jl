#=
parseBall:
- Julia version: 
- Author: Dan
- Date: 2021-11-28
=#

push!(LOAD_PATH, "G:\\Python Programme\\BALL.jl\\src\\" )
using BALL

pdb_filepath = "1AKE.pdb"

System(pdb_filepath)

elapsed = @elapsed System(pdb_filepath)

println(elapsed)