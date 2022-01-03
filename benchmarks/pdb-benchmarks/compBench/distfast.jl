push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools

comp = collectSystems(System("../compBench/1htq.pdb"))[2]
dfs = DataFrameSystem(comp)

function dist1()
    firstChain::Union{Chain,Nothing} = comp.first_child_
    resIter::Residue = firstChain.first_child_
    res1 = Residue()
    res2 = Residue()
    for x in 1:60
        if x == 50
            res1 = resIter
        end
        
        if x ==60
            res2 = resIter
        end
        resIter = resIter.next_
    end
return distance(res1, res2)
end

function dist2()
    return distance(dfs.residues[50], dfs.residues[60])
end

@show @benchmark dist1()
@show @benchmark dist2()
