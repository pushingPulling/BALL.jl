export AtomDF,ResidueDF, ChainDF, SystemDF, BioFrame, BondDF, display

import Base: display
import DataFrames: DataFrameRow, DataFrame





abstract type BioFrame <: AbstractDataFrame end

mutable struct AtomDF <: BioFrame
    df::DataFrame
    dfs     #this is a dataframesystem. Just can't declare as such due to mutally circular types problem
end

mutable struct ResidueDF <: BioFrame
    df::DataFrame
    dfs     #this is a dataframesystem. Just can't declare as such due to mutally circular types problem
end

mutable struct ChainDF <: BioFrame
    df::DataFrame
    dfs     #this is a dataframesystem. Just can't declare as such due to mutally circular types problem
end

mutable struct SystemDF <: BioFrame
    df::DataFrame
    dfs     #this is a dataframesystem. Just can't declare as such due to mutally circular types problem
end

mutable struct BondDF <: BioFrame
    df::DataFrame
    dfs     #this is a dataframesystem. Just can't declare as such due to mutally circular types problem
end

"""
    DataFrameSystem
`DataFrameSystem` is a collection of `DataFrame`s to store `BioFrame` types in.
"""
mutable struct DataFrameSystem <: KernelInterface
    systems ::SystemDF
    chains  ::ChainDF
    residues::ResidueDF
    atoms   ::AtomDF
    bonds   ::BondDF
    DataFrameSystem(
        systems::SystemDF,
        chains::ChainDF,
        residues::ResidueDF,
        atoms::AtomDF,
        bonds::BondDF
    ) = begin 
            self = new(systems, chains, residues, atoms, bonds) 
            systems.dfs = self
            chains.dfs = self
            residues.dfs = self
            atoms.dfs = self
            bonds.dfs = self
        end
end


AtomDF(pairs::Vector{Pair{Symbol, _A} where _A}) = AtomDF(DataFrame(pairs),nothing)
ResidueDF(pairs::Vector{Pair{Symbol, _A} where _A}) = ResidueDF(DataFrame(pairs),nothing)
ChainDF(pairs::Vector{Pair{Symbol, _A} where _A}) = ChainDF(DataFrame(pairs),nothing)
SystemDF(pairs::Vector{Pair{Symbol, _A} where _A}) = SystemDF(DataFrame(pairs),nothing)
BondDF(pairs::Vector{Pair{Symbol, _A} where _A}) = BondDF(DataFrame(pairs),nothing)

AtomDF(df::DataFrames.DataFrame) = AtomDF(df,nothing)
ResidueDF(df::DataFrames.DataFrame) = ResidueDF(df,nothing)
ChainDF(df::DataFrames.DataFrame) = ChainDF(df,nothing)
SystemDF(df::DataFrames.DataFrame) = SystemDF(df,nothing)
BondDF(df::DataFrames.DataFrame) = BondDF(df,nothing)

DataFrameSystem(
    systems::DataFrame,
    chains::DataFrame,
    residues::DataFrame,
    atoms::DataFrame,
    bonds::DataFrame
) = DataFrameSystem(SystemDF(systems), ChainDF(chains), ResidueDF(residues),
         AtomDF(atoms), BondDF(bonds))


AtomDF(pairs::Vector{Pair{Symbol, _A} where _A}, dfs::DataFrameSystem) = AtomDF(DataFrame(pairs),dfs)
ResidueDF(pairs::Vector{Pair{Symbol, _A} where _A}, dfs::DataFrameSystem) = ResidueDF(DataFrame(pairs),dfs)
ChainDF(pairs::Vector{Pair{Symbol, _A} where _A}, dfs::DataFrameSystem) = ChainDF(DataFrame(pairs),dfs)
SystemDF(pairs::Vector{Pair{Symbol, _A} where _A}, dfs::DataFrameSystem) = SystemDF(DataFrame(pairs),dfs)
BondDF(pairs::Vector{Pair{Symbol, _A} where _A}, dfs::DataFrameSystem) = BondDF(DataFrame(pairs),dfs)



DataFrameRow(df::BioFrame, i::Int, a::Any) = DataFrameRow(getfield(df,:df),i,a)
Base.display(df::BioFrame) = display(getfield(df,:df)::DataFrames.DataFrame)
