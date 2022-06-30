import DataFrames: _check_consistency, index, getindex, getproperty, ncol, nrow, show, deleteat!, eachcol, getDFS
import ..CONCEPT: getProperties, getProperty, setProperty, hasProperty
import Base: insert!

export getDFS
_check_consistency(df::BioFrame) = _check_consistency(getfield(df,:df))
nrow(df::BioFrame) = nrow(getfield(df,:df))
ncol(df::BioFrame) = nrow(getfield(df,:df))
show(df::BioFrame) = show(getfield(df,:df))
getproperty(a::BioFrame, sy::Symbol) = getproperty(getfield(a,:df),sy)
eachcol(a::BioFrame) = eachcol(getfield(a,:df))
insert!(a::BioFrame, idx::Int, t::Tuple) = insert!.(eachcol(a),idx,t)
insert!(a::BioFrame, idx::Int, t::DataFrames.DataFrameRow) = insert!(a,idx,(t...,))
deleteat!(a::BioFrame, inds) = deleteat!(getfield(a,:df), inds)

index(df::BioFrame, i::Int, c::Colon) = index(getfield(df,:df),i,c)
Base.getindex(df::BioFrame, rowind::Integer,
                                       colinds::MultiColumnIndex) = getindex(getfield(df,:df,rowind,colinds))
Base.getindex(df::BioFrame, rowind::Integer, ::Colon) =
                                        getindex(getfield(df,:df), rowind, :)



"""
    getProperties(::AbstractComposite)
Getter of property-Vector
"""
getProperties(dfr::DFR) = begin
    return dfr.properties_
end
"""
    hasProperty(comp::AbstractComposite, property::String)
Checks if `comp` has property `property`.
"""
hasProperty(dfr::DFR, property::Symbol) = begin
    if any([property == x[1] for x in getProperties(dfr) ])
        return true
    end
    return false
end

"""
    getProperty(comp::AbstractComposite, property::String)
Gets value of `property` if set, else `nothing`.
"""
getProperty(dfr::DFR, property::Symbol) = begin
    if hasProperty(dfr,property)
        index = findfirst((x::Tuple{Symbol,Any})-> property == x[1], getProperties(dfr))
        return getProperties(dfr)[index][2]
    end
    return nothing
end

"""
    setProperty(::AbstractComposite, ::Tuple{String,UInt8})
Setter. Deletes old property if needed.
"""
setProperty(dfr::DFR, property::Tuple{Symbol,Any}) = begin
    if hasProperty(dfr,property[1])
        index = findfirst((x::Tuple{Symbol,Any})-> property[1] == x[1], getProperties(dfr))
        deleteat!(getProperties(dfr), index)
    end
    push!(dfr.properties_, property)
end
#setProperty(comp::AbstractComposite, property::Tuple{String,Bool}) = setProperty(comp,(property[1],property[2]))


getDFS(df::BioFrame) = begin
    return getfield(df,:dfs)
end


#only to be used with DataFrameRows in a BioFrame
getDFS(dfr::DataFrames.DataFrameRow) = dfr.:dfs[]
