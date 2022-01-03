push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools
using StaticArrays
pdb_filepath = "1ake.pdb"

comp = System(pdb_filepath)
dfs = DataFrameSystem(comp)

comp2 = System(pdb_filepath)
for x in AtomIterator(comp2)
    setPosition(x, SVector{3,Float64}(x.position_[1]/sqrt(3),x.position_[2]/sqrt(3),x.position_[3]/sqrt(3)))
end


rmsd(comp, comp2,false)

elapsed = @elapsed rmsd(comp,comp2,false)

println(elapsed)
@show @benchmark rmsd(comp,comp2,false)

