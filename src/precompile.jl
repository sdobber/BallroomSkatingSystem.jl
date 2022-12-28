function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{typeof(skating_single_dance),DataFrame})   # time: 0.4183177
    Base.precompile(Tuple{typeof(write_result!),DataFrame,DataFrame,DataFrame,Int64,Int64,Int64,Int64,Int64})   # time: 0.0137808
    Base.precompile(Tuple{typeof(skating_combined),Vector{String},Vector{DataFrame}})   # time: 0.5728937
    Base.precompile(Tuple{typeof(write_places!),DataFrame,DataFrame,Vector{Int64},Float64,Int64})   # time: 0.003989675
end

_precompile_()