## Helper functions

"""
    remove!(a, item)

Removes `item` from the collection `a`.
"""
function remove!(a, item)
    deleteat!(a, findfirst(==(item), a))
end


## Majority system for individual dances

"""
    skating_single_dance(results)
    skating_single_dance(results, majority_from; [initial_place, initial_column, depth])

Calculates a skating tableau and placement for judgment results of a single dance contained
in the DataFrame `results`. It must contain the starter numbers of the dancers as a first
column named `:Numbers`, and the places assigned by the different judges in the following
columns, for example as in
```julia
DataFrame(Number = [11, 12, 13, 14, 15],
        JudgeA = [1, 2, 3, 4, 5],
        JudgeB = [1, 3, 2, 4, 5],
        JudgeC = [1, 3, 2, 5, 4],
        JudgeD = [5, 1, 2, 3, 4],
        JudgeE = [2, 1, 5, 3, 4])
```

Returns a DataFrame with the skating tableau represented as strings, as well as a DataFrame
with the starter numbers and places.

For calculations on cropped tables, the majority of votes, the initial placement to fill,
the initial column in the tableau where skating should start as well as the desired depth of
the calculation can be defined by keyword arguments.
"""
function skating_single_dance(results::DataFrame, majority_from::Int; initial_place::Int = 1,
    initial_column::Int = 1, depth = size(results, 1))
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

    calculation[!, :Place] .= 0.0
    calculation_text = string.(copy(calculation))

    current_place = initial_place
    max_cols = depth
    current_col = initial_column
    tmp_col = initial_column
    steps = 0
    append_sum = false
    while current_place <= (initial_column - 1 + size(results, 1)) && steps <= 10
        # @info steps
        # clear majority
        @show current_col
        if count(>=(majority_from), calculation[!, current_col+1], dims = 1)[1] == 1
            @info "Clear Majority"
            idx = findfirst(>=(majority_from), calculation[!, current_col+1])
            calculation[idx, :Place] = current_place
            calculation_text[idx, :Place] = string(current_place)
            calculation_text[idx, (current_col+1)] = string(calculation[idx, (current_col+1)]) * "*"
            calculation_text[idx, (current_col+2):(max_cols+1)] .= "-"
            calculation[idx, (current_col+1):(max_cols+1)] .= 0
            current_place += 1
            current_col += 1
        else
            @info "Multiple Majorities"
            # multiple majorities
            idx = findall(>=(majority_from), calculation[!, current_col+1])
            tmp_col = copy(current_col)
            while !isempty(idx)
                @info idx
                if count(==(maximum(calculation[idx, tmp_col+1])), calculation[idx, tmp_col+1]) == 1
                    # clear majority
                    @info "Single maximal majority"
                    id = idx[findfirst(==(maximum(calculation[idx, tmp_col+1])), calculation[idx, tmp_col+1])]
                    calculation[id, :Place] = current_place
                    calculation_text[id, :Place] = string(current_place)
                    str = string(calculation[id, (tmp_col+1)]) * "*"
                    if append_sum
                        str = str * "(" * string(sum_of_eval[id, (tmp_col+1)]) * ")"
                    end
                    calculation_text[id, (tmp_col+1)] = str
                    calculation_text[id, (tmp_col+2):(max_cols+1)] .= "-"
                    calculation[id, (current_col+1):(max_cols+1)] .= 0
                    current_place += 1
                    append_sum = false
                    remove!(idx, id)
                else
                    # equal majority
                    # needs temporary lookup columns!
                    # id = findall(==(maximum(calculation[idx, current_col+1]), calculation[idx, current_col+1]))
                    # look at sum of evaluations up to current column
                    if length(findall(==(maximum(sum_of_eval[idx, tmp_col+1])), sum_of_eval[idx, tmp_col+1])) == 1
                        @info "Single sum minority"
                        id = findfirst(==(minimum(sum_of_eval[idx, tmp_col+1])), sum_of_eval[idx, tmp_col+1])
                        calculation[idx[id], :Place] = current_place
                        calculation_text[idx[id], :Place] = string(current_place)
                        calculation_text[idx[id], (tmp_col+1)] = string(calculation[idx[id], (tmp_col+1)]) * "*" * "(" * string(sum_of_eval[idx[id], (tmp_col+1)]) * ")"
                        calculation_text[idx[id], (tmp_col+2):(max_cols+1)] .= "-"
                        calculation[idx[id], (current_col+1):(max_cols+1)] .= 0
                        current_place += 1
                        append_sum = true
                        remove!(idx, idx[id])
                    else
                        @info "else"
                        calculation_text[idx, (tmp_col+1)] = string.(calculation[idx, (tmp_col+1)]) .* "*" .* "(" .* string.(sum_of_eval[idx, (tmp_col+1)]) .* ")"
                        steps += 1
                        tmp_col += 1
                        if tmp_col > max_cols
                            @info "tmp_cols > max_cols"
                            places = range(current_place, length = length(idx))
                            place = mean(places)
                            calculation[idx, :Place] .= place
                            calculation_text[idx, :Place] .= string(place)
                            current_place = maximum(places) + 1
                            calculation[idx, (current_col+1):(max_cols+1)] .= 0
                            @info current_col
                            idx = []
                            break
                        end
                        #break
                    end

                end
            end


            current_col += 1
        end
        # safety
        steps += 1
    end

    return calculation_text, calculation[!, [:Number, :Place]]
end

function skating_single_dance(results::DataFrame; initial_place = 1, initial_column = 1, depth = size(results, 1))
    return skating_single_dance(results::DataFrame, calc_majority(results);
        initial_place = initial_place, initial_column = initial_column, depth = depth)
end

"""
    calc_majority(results)

Returns the judge majority for a result DataFrame `results`.
"""
function calc_majority(results)
    return Int((size(results, 2) - 2) / 2 + 1)
end