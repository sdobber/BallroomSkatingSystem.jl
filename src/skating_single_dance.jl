## Helper functions

function remove!(a, item)
    deleteat!(a, findfirst(==(item), a))
end


## Majority system for individual dances
function skating_single_dance(results::DataFrame, majority_from::Int; initial_place::Int = 1, initial_column::Int = 1)
    calculation = DataFrame(Number = results[!, :Number])
    sum_of_eval = DataFrame(Number = results[!, :Number])
    for i = 1:size(calculation, 1)
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
    max_cols = size(calculation, 1)
    current_col = initial_column
    tmp_col = initial_column
    steps = 0
    append_sum = false
    while current_place <= size(results, 1) && steps <= 10
        @info steps
        # clear majority
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
                        # TO DO
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

function skating_single_dance(results::DataFrame; initial_place = 1, initial_column = 1)
    return skating_single_dance(results::DataFrame, calc_majority(results); initial_place = 1, initial_column = 1)
end

function calc_majority(results)
    return Int((size(results, 2) - 2) / 2 + 1)
end