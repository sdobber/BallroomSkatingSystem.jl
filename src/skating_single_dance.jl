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

    calculation, sum_of_eval = prepare_sums(results, depth)

    calculation[!, :Place] .= 0.0
    calculation_text = string.(copy(calculation))

    current_place = initial_place
    max_cols = depth
    current_col = initial_column
    tmp_col = initial_column
    append_sum = false
    while current_place <= (initial_column - 1 + size(results, 1))
        if count(>=(majority_from), calculation[!, current_col+1], dims = 1)[1] == 1
            # @info "Clear Majority"
            idx = findfirst(>=(majority_from), calculation[!, current_col+1])
            write_result!(calculation, calculation_text, sum_of_eval, idx, current_place, current_col, current_col, max_cols)
            current_place += 1
            current_col += 1
        else
            # @info "Multiple Majorities"
            idx = findall(>=(majority_from), calculation[!, current_col+1])
            tmp_col = copy(current_col)
            while !isempty(idx)
                if count(==(maximum(calculation[idx, tmp_col+1])), calculation[idx, tmp_col+1]) == 1
                    # @info "Single maximal majority"
                    id = idx[findfirst(==(maximum(calculation[idx, tmp_col+1])), calculation[idx, tmp_col+1])]
                    write_result!(calculation, calculation_text, sum_of_eval, id, current_place, current_col, tmp_col, max_cols; append_sum = append_sum)
                    current_place += 1
                    append_sum = false
                    remove!(idx, id)
                else
                    # equal majority
                    # look at sum of evaluations up to current column
                    if length(findall(==(maximum(sum_of_eval[idx, tmp_col+1])), sum_of_eval[idx, tmp_col+1])) == 1
                        # @info "Single sum minority"
                        id = findfirst(==(minimum(sum_of_eval[idx, tmp_col+1])), sum_of_eval[idx, tmp_col+1])
                        write_result!(calculation, calculation_text, sum_of_eval, idx[id], current_place, current_col, tmp_col, max_cols; append_sum = true)
                        current_place += 1
                        append_sum = true
                        remove!(idx, idx[id])
                    else
                        # @info "Multiple equal sums"
                        calculation_text[idx, (tmp_col+1)] = string.(calculation[idx, (tmp_col+1)]) .* "*" .* "(" .* string.(sum_of_eval[idx, (tmp_col+1)]) .* ")"
                        tmp_col += 1
                        if tmp_col > max_cols
                            # @info "tmp_cols > max_cols"
                            places = range(current_place, length = length(idx))
                            place = mean(places)
                            calculation[idx, :Place] .= place
                            calculation_text[idx, :Place] .= string(place)
                            current_place = maximum(places) + 1
                            calculation[idx, (current_col+1):(max_cols+1)] .= 0
                            idx = []
                            break
                        end
                    end

                end
            end
            current_col += 1
        end
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
    return ceil(Int, (size(results, 2) - 2) / 2 + 1)
end

"""
    write_result!(calculation, calculation_text, sum_of_eval, id, current_place, current_col, tmp_col, max_cols; append_sum = false)

Write the result of the skating procedure to the DataFrames containing placement and summary
information. Remove the parts that are not needed anymore.
"""
function write_result!(calculation, calculation_text, sum_of_eval, index, current_place, current_col, tmp_col, max_cols;
    append_sum = false)
    calculation[index, :Place] = current_place
    calculation_text[index, :Place] = string(current_place)
    str = string(calculation[index, (tmp_col+1)]) * "*"
    if append_sum
        str = str * "(" * string(sum_of_eval[index, (tmp_col+1)]) * ")"
    end
    calculation_text[index, (tmp_col+1)] = str
    calculation_text[index, (tmp_col+2):(max_cols+1)] .= "-"
    calculation[index, (current_col+1):(max_cols+1)] .= 0
end