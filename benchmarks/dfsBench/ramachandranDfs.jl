#=
countDfs:
- Julia version:
- Author: Dan
- Date: 2021-11-28
=#

push!(LOAD_PATH, "G:\\Python Programme\\BALL.jl\\src\\" )
using BALL

pdb_filepath = "1AKE.pdb"

comp = System(pdb_filepath)
dfs = DataFrameSystem(comp)


ramachandranangles(dfs)

elapsed = @elapsed ramachandranangles(dfs)

println(elapsed)
