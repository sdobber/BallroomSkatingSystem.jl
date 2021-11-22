## Helper functions

"""
    remove!(a, item)

Removes `item` from the collection `a`.
"""
function remove!(a, item)
    deleteat!(a, findfirst(==(item), a))
end

"""
    prepare_sums(results, depth)

Returns the DataFrame for the calculation of the majority of votes, as well as the sum of
evaluations up to a given rank.
"""
function prepare_sums(results, depth)
    calculation = DataFrame(Number = results[!, :Number])
    sum_of_eval = DataFrame(Number = results[!, :Number])
    for i = 1:depth
        insertcols!(calculation, Symbol("1-$(i)") => vec(count(<=(i), results[!, Not(:Number)] |> Array, dims = 2)))
        if i == 1
            insertcols!(sum_of_eval, Symbol("1-$(i)") => calculation[:, i+1])
        else
            insertcols!(sum_of_eval, Symbol("1-$(i)") => i .* (calculation[:, i+1] - calculation[:, i]) + sum_of_eval[:, i])
        end
    end
    return calculation, sum_of_eval
end
