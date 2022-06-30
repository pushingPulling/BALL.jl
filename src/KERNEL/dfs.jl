export DataFrameSystem, getSource, getTarget, getFirstChild, getLastChild, getTrait, viewChildren,
        collectChildren,AtomDF,ResidueDF, ChainDF, SystemDF, BioFrame, getproperty, nrow,
        BioFrame, AtomDF, ResidueDF, ChainDF, SystemDF, BondDF, display

using DataFrames: MultiColumnIndex
import .CONCEPT: getChildren, getParent, setProperty
import .KERNEL: coords, isHetero, collectAtoms, viewAtoms
import Base: length, getindex, ==, show, vcat, merge, eachcol, insert!, deleteat!, show, names, ncol,display
import DataFrames: _check_consistency, index, getindex, getproperty, names, ncol, nrow

