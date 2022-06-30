#import COMMON\common everywhere you want to import/"using" modules, as well as using globals
import Base.showerror
import InteractiveUtils

export @printfields, capitalize, TooManyIterationsException, @datatype, subfunction, @wrapperType,
@test,function_string_to_assignment_expr,laste, @hehe




macro inherit(name, base, fields)
    base_type = Core.eval(@__MODULE__, base)
    :(println($base_type))
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

"""

should
    - replace source type with wrapper type
    - remove definition from not source
    - make sure to not overwrite things that have source as substring
    - redefine functions by doing wrapper.df
"""



subfunction(function_string::String, wrapper::Type, wrapper_binding::String, function_names::Set{String},
            eval_strings::Vector{String},mod::Module) = begin
#use eachmatch() to find all matches

    function_name_regex = r"^.*?(?=\()"
    variable_name_regex = r"(?!=(,|\())(\w+)(?=::DataFrame)"

    push!(function_names, match(function_name_regex, function_string).match)

    variable_name = match(variable_name_regex, function_string)#.match
    !isnothing(variable_name) && (variable_name = variable_name.match)



    r_str = replace(function_string, r"(?<=::).*?(?=\)[^,]|\)$|, \w+::|,\w+::|\.\.\.|;)" => "")
    function_string = replace(function_string, r"\bDataFrame\b" => "/$(mod)./$(wrapper)")
    r_str = replace(r_str,r"::"=> "")
    #println(function_string," ",r_str)
    if !isnothing(variable_name)
        r_str = replace(r_str, Regex("\\b$(variable_name)\\b") => variable_name*"."*wrapper_binding)
    else
        b = collect(findfirst("(",function_string))[1]
        function_string = function_string[1:b] * "df" * function_string[b+1:end]
        r_str = r_str[1:b] * "df" * r_str[b+1:end]
    end

    println(function_string * " = " * r_str)
    push!(eval_strings, function_string * " = " * r_str)

end

#sooo quote end is a piece of code evalueated at runttime?
macro wrapperType(sourcetype, wrapper, sourcemodule, mod)
#write inner constructor? because acutally AtomDF() is not yet defined


    #hacky shit, should remove as soon i find a proper solution
    #i need this to load the source module, so i can corretly import the functions of the source module
    cur_mod = @__MODULE__




    println(cur_mod)
    println(string(wrapper))

    println(sourcetype)
    #sourcetype = getfield(sourcemodule, Symbol(string(sourcetype)))
    #println(wrapper(sourcetype(A=[1,2,3])))
    #println(eval(  wrapper( sourcetype(A=[1,2,3]) )  ))

    println("using $(string(sourcemodule))")
    open("tempfile_include.jl","w") do io
        write(io, "using $(string(sourcemodule))")
    end
    include("tempfile_include.jl")
    rm("tempfile_include.jl")

    println(sourcetype,typeof(sourcetype))  #expression
    println(wrapper,typeof(wrapper))        #symbol
    println(sourcemodule,typeof(sourcemodule))#symbol
    println(mod,typeof(mod))                #expression

    #println(wrapper(DataFrame(A=[1,2,3])))
    #println(eval(  wrapper( DataFrame(A=[1,2,3]) )  ))


    wrapper_binding = quote string(fieldnames($(wrapper))[1]) end
    methods = quote string.(InteractiveUtils.methodswith($(sourcetype))) end
    function_names = Set{String}()
    eval_strings = String[]
    import_strings = String[]
    to_delete = Int[]
    quote
        for i in 1:length($(methods))
            idx = findfirst(" in DataFrames at ", $(methods)[i])
            !isnothing(idx) && (idx = first(idx))
            if isnothing(idx)
                push!(to_delete, i)
                continue
            end
            methods[i] = methods[i][1:idx-1]
        end
    end
    quote deleteat!(methods, to_delete) end

    quote
        for function_string in methods
            subfunction(function_string, wrapper,wrapper_binding, function_names, eval_strings,mod)
        end
    end

    import_strings = collect(function_names)
    for i in 1:length(import_strings)
        #pm0 = eval(Meta.parse(import_strings[i]))
        #pm = string(parentmodule(pm0))
        #te = "import " * pm * "." * import_strings[i]
        import_strings[i] = "import DataFrames."*import_strings[i]
    end

    quote @eval($(mod), Meta.parse(join($(import_strings),";")))end
    println("done1")
    println(wrapper)
    quote
        for x in $eval_strings
            @eval(mod,Meta.parse(x))
            println(x,"-/\\-",Meta.parse(x))
        end
    end
    export_strings = replace.(import_strings, "import DataFrames." => "")
    quote @eval($(mod), Meta.parse("export "*join($(export_strings),","))) end
    return quote InteractiveUtils.methodswith($(mod).$(wrapper)) end

end

macro test6(class)
println(:($class, " ", $(__module__), "   ", $(typeof(class)), " ", $(typeof(__module__))))
println(:($__source__))
           @eval __module__ setproperty!(df::$class, col_ind::Symbol, v) = setproperty!(getfield(df,:df),col_ind,v)
            end



function recursive_expr_tree_walk!(ex,func::Function)
    exprs = Expr[]
    for expr in ex.args
        !isa(expr, Expr) && continue
        func(expr)
        recursive_expr_tree_walk!(expr,func)
    end
end



#do recursive seach for Expr in the tree that have head :(::) and only 1 arg; add 1st arg
function function_string_to_assignment_expr(met::String, MyType,OriginalType)
    cut_off_pos = match(r"in [\w+\.]+ at", met).offset

    met = met[1:cut_off_pos-2]
    rhs = Meta.parse(met)
    if rhs.head == :where
        union_symb = rhs.args[2]
        rhs = rhs.args[1]
        lhs, rhs = create_assignments(rhs,MyType, OriginalType)
        rhs = Expr(:where, rhs, union_symb)
        lhs = Expr(:where, lhs, union_symb)
    else
        lhs, rhs =create_assignments(rhs,MyType, OriginalType)
    end
    expr = Expr(:(=),lhs,rhs)
    recursive_expr_tree_walk!(expr,x->x.head == :(::) && length(x.args) == 1 && (insert!(x.args,1,:c)))
    return expr
end

function create_assignments(rhs,MyType, OriginalType)
    lhs = copy(rhs)
    df_arg_pos = findfirst(x->isa(x,Expr) && x.head == :(::) && in(:DataFrame,x.args), rhs.args)

    rhs.args[df_arg_pos] = :(df.df::$OriginalType)
    lhs.args[df_arg_pos] = :(df::$MyType)
    return (lhs,rhs)
end

#sack this and use @forward https://github.com/FluxML/MacroTools.jl/blob/master/src/examples/forward.jl
#instead. make a macro like "@gen_wrapper AtomDF DataFrames; mutable df" to do the same work
function laste(MyType, OriginalType, source_module)
    println(fieldnames(MyType))
    final_exprs = Expr[]
    import_names = Set{Symbol}()
    import_expr = :(import $(Symbol(source_module)): placeholder)

    for x in string.(InteractiveUtils.methodswith(OriginalType))
        name_cutoff = first(findfirst("(", x))
        push!(import_names, Symbol(x[1:name_cutoff-1]))
        ex = function_string_to_assignment_expr(x,MyType, OriginalType)
        push!(final_exprs, ex)
    end


    for x in import_names
        push!(import_expr.args[1].args, :($(Expr(:., x))) )
    end

    #delete placeholder
    deleteat!(import_expr.args[1].args,[2])

    @eval $import_expr
    i = 1
    while i<length(final_exprs)
        try
            @eval $(final_exprs[i])
            i += 1
        catch y
            if isa(y,ErrorException)
                i+=1
                println("Error: ",sprint(showerror, y)," at expression $i: \'$(final_exprs[i]) was not evaluated\'")
            end

            if isa(y,UndefVarError)
                x = Symbol(source_module)
                @eval import $x.$(y.var)
            end
        end
    end
    @eval import Base.getproperty
    @eval getproperty(df::$(MyType),f::Symbol) = getproperty(getfield(df,:df),f)

end

macro hehe(ex)

end
#=
common:
- Julia version: 
- Author: Dan
- Date: 2021-06-02
=#
