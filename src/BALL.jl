#=
BALL:
- Julia version: 
- Author: Dan
- Date: 2021-08-19
=#
module BALL
using Reexport
        #require bijections, DataFrames
    module COMMON
        include("./COMMON/global.jl")
        include("./COMMON/common.jl")
    end

    module CONCEPT
        using ..COMMON
        include("./CONCEPT/selectable.jl")
        include("./CONCEPT/composite_interface.jl")
        include("./CONCEPT/timeStamp.jl")
        include("./CONCEPT/composite.jl")
        include("./CONCEPT/kernel_interfaces.jl")
    end

    module KERNEL
        using ..COMMON
        using ..CONCEPT
        using Bijections
        using StaticArrays
        using DataFrames
        include("./KERNEL/bond.jl")
        include("./KERNEL/PTE.jl")
        include("./KERNEL/atom.jl")
        include("./KERNEL/atom_bijection.jl")
        include("./KERNEL/chain.jl")
        include("./KERNEL/residue.jl")
        include("./KERNEL/system.jl")
        include("./KERNEL/composite_iterator.jl")
        include("./KERNEL/dataframesystem.jl")
        include("./KERNEL/getter_setter.jl")
        include("./KERNEL/aux_functions.jl")
    end

    module SPATIAL
        using ..COMMON
        using ..CONCEPT
        using ..KERNEL
        using StaticArrays
        using DataFrames
        using LinearAlgebra
        include("./SPATIAL/spatial.jl")
    end


    module MOLMEC
        using ..COMMON
        using ..CONCEPT
        using ..KERNEL
        include("./MOLMEC/MMFF94Parameters.jl")
    end

    module FILEFORMATS
        using ..COMMON
        using ..CONCEPT
        using ..KERNEL
        #include("./BioStructures_interface")#slipt dataformat up
        include("./FILEFORMATS/PDBParser.jl")#split dataformat up
    end

    module STRUCTURE
        using DataFrames
        using ..COMMON
        using ..CONCEPT
        using ..KERNEL
        include("./STRUCTURE/simple_molecular_graph.jl")
        include("./STRUCTURE/minimum_cycle_basis.jl")

    end

    module QSAR
        using ..COMMON
        using ..CONCEPT
        using ..KERNEL
        using ..STRUCTURE
        using DataFrames
        include("./QSAR/add_hydrogen_processor.jl")
        include("./QSAR/ring_perception.jl")
    end

    @reexport using .COMMON
    @reexport using .CONCEPT
    @reexport using .KERNEL
    @reexport using .MOLMEC
    @reexport using .FILEFORMATS
    @reexport using .STRUCTURE
    @reexport using .QSAR
    @reexport using .SPATIAL
    export COMMON, CONCEPT, KERNEL, MOLMEC, FILEFORMATS, STRUCTURE, QSAR, SPATIAL

end