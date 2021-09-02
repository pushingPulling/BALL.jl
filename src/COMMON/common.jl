#import COMMON\common everywhere you want to import/"using" modules, as well as using globals
import Base.showerror

export
    printfields, capitalize, TooManyIterationsException


macro inherit(name, base, fields)
    base_type = Core.eval(@__MODULE__, base)
    base_fieldnames = fieldnames(base_type)
    base_types = [t for t in base_type.types]
    base_fields = [:($f::$T) for (f, T) in zip(base_fieldnames, base_types)]
    res = :(mutable struct $name end)
    push!(res.args[end].args, base_fields...)
    push!(res.args[end].args, fields.args...)
    return res
end

"""
    @printfields
Prints names and contents of `object`'s fields.
"""
macro printfields(object)
    return :(for name in fieldnames(typeof($object))
        println(name," ",typeof(getfield($object,name))," ", getfield($object,name))
    end)
end

"Capitalizes a word"
capitalize(str::AbstractString) = begin
    return string(uppercase(str[1]), lowercase(str[2:end]))
end


"""
    TooManyIterationsException
Exception for a routine with a limited number of Iterations.
"""
struct TooManyIterationsException
    max_iterations::Int64
end
Base.showerror(io::IO, e::TooManyIterationsException) = print(io, "rached maximum number ($(e.max_iterations)) of iterations")


#=
common:
- Julia version: 
- Author: Dan
- Date: 2021-06-02
=#
