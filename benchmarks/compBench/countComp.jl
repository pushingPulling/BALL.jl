#=
bachelorbench:
- Julia version: 
- Author: Dan
- Date: 2021-10-31
=#

push!(LOAD_PATH, "G:\\Python Programme\\BALL.jl\\src\\" )
using BALL

pdb_filepath = "1AKE.pdb"

comp = System(pdb_filepath)

function counterComp()
    res = collectResidues(comp)
    filter!(x->x.name_ == "ALA", res)
end

counterComp()
elapsed = @elapsed counterComp()

println(elapsed)



