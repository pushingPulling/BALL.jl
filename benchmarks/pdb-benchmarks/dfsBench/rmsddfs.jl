push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools
using StaticArrays
pdb_filepath = "1ake.pdb"

comp = System(pdb_filepath)
dfs = DataFrameSystem(comp)

dfs2 = DataFrameSystem(comp)
for x in dfs.atoms.position_
    x = SVector{3,Float64}(x[1]/sqrt(3),x[2]/sqrt(3),x[3]/sqrt(3))
end


rmsd(dfs, dfs2, calphaonly=false)

elapsed = @elapsed rmsd(dfs,dfs2)

println(elapsed)
@show @benchmark rmsd(dfs,dfs2)

