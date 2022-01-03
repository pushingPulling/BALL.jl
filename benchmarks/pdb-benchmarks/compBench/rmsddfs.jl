push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src/" )
using BALL
using BioStructures
using DataFrames
using BenchmarkTools

struc = System("1ake.pdb")
println(struc)



internal = System("/mnt/g/Python Programme/BALL.jl/1ake.pdb")
internal2 = deepcopy(internal)
dfs = DataFrameSystem(internal)
#ramachandranangles(dfs)
dfs2 = deepcopy(dfs)
struc = read("/mnt/g/Python Programme/BALL.jl/1ake.pdb", PDB)
struc2 = deepcopy(struc)

for sys in struc2 for ch in sys for res in ch for at in res
	isdisorderedatom(at) && continue
    coords!(at, at.coords .+= 1/sqrt(3))
end end end end

for row in eachrow(dfs2.atoms)
    row.position_ = getPosition(row) .+ 1/sqrt(3)
end

for at in AtomIterator(internal2)
    at.position_ = getPosition(at) .+ 1/sqrt(3)
end

println(BALL.rmsd(dfs,dfs2))
println(BioStructures.rmsd(struc,struc2,superimpose=false))
println(BALL.rmsd(internal, internal2))

@show @benchmark BALL.rmsd(dfs,dfs2)
@show @benchmark BioStructures.rmsd(struc,struc2,superimpose=false)
@show @benchmark BALL.rmsd(internal, internal2)

@show @benchmark BALL.rmsd(dfs,dfs2, calphaonly=false)
@show @benchmark BioStructures.rmsd(struc,struc2,allselector,superimpose=false)
@show @benchmark BALL.rmsd(internal, internal2,false)
