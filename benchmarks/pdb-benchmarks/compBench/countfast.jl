function manual()
    firstChain::Union{Chain,Nothing} = comp.first_child_
    resIter::Union{Residue,Nothing} = firstChain.first_child_
    counter::Int = 0
    while !isnothing(firstChain)
        while !isnothing(resIter)
            if resIter.name_ == "ALA"
                counter += 1
            end
        resIter = resIter.next_
        end
    firstChain = firstChain.next_
   !isnothing(firstChain) ? resIter = firstChain.first_child_ : nothing
    end
    return counter
end

function man2()
counter::Int = 0
for x in ResidueIterator(comp)
    if x.name_ == "ALA"
        counter +=1
    end
end
return counter
end

function man3()
    counter::Int = 0
    for x in eachrow(dfs.residues)
        if x.name_ =="ALA"
            counter += 1
        end
    end
return counter
end

function man4()
    counter::Int = 0
    for x in dfs.residues.name_
        if x == "ALA"
            counter += 1
        end
    end
return counter
end

function man5()
return length(filter(x->x == "ALA", dfs.residues.name_))
end

