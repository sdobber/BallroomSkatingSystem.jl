## Skating system for final placement

"""
    skating_combined(dances, results_single_dances)

Calculates the final placement of competitors in a dancing competition based on the skating
rules. `dances` is a vector of strings, containing the names of the dances. 
`results_single_dances` is a vector of DataFrames, containing the results for the individual
dances. See [`skating_single_dance`](@ref) for the correct input format.

Outputs a DataFrame with the accumulated skating tableau as strings, a vector containing 
tableaus containing the application of Rule 10 and Rule 11, the skating results for the
individual dances as well as a DataFrame with the starter numbers and final places.
"""
function skating_combined(dances, results_single_dances, places, reports)
    rule10_counts, rule10_sums = prepare_sums(places, size(places, 1))

    places[!, :Sum] = sum(eachcol(places[!, Not(:Number)]))
    places[!, :Place] .= 0.0
    places_text = string.(copy(places))
    rule10_text = string.(copy(rule10_counts))
    rule10_text[!, Not(:Number)] .= "-"
    rule10_text[!, :Place] .= "-"

    rule11_table = get_rule11_table(results_single_dances)
    rule11_text = copy(rule10_text)

    current_place = 1
    while current_place <= size(places, 1)
        idx = findall(==(minimum(places[!, :Sum])), places[!, :Sum])
        if length(idx) == 1
            # @info "Minimum sum"
            index = idx[1]
            places[index, :Place] = current_place
            places[index, :Sum] = 1000 + current_place
            places_text[index, :Place] = string(current_place)
            current_place += 1
        else
            # Rule 10
            id = findall(==(maximum(rule10_counts[idx, current_place+1])), rule10_counts[idx, current_place+1])
            if length(id) == 1
                # @info "Minimum better places"
                index = idx[id[1]]
                places[index, :Place] = current_place
                places[index, :Sum] = 1000 + current_place
                places_text[index, :Place] = string(current_place)
                rule10_text[idx, current_place+1] .= string.(rule10_counts[idx, current_place+1])
                rule10_text[index, :Place] = string(current_place)
                current_place += 1
            else
                # @info "Minimum better summed places"
                i = findall(==(minimum(rule10_sums[idx[id], current_place+1])), rule10_sums[idx[id], current_place+1])
                if length(i) == 1
                    index = idx[id[i[1]]]
                    places[index, :Place] = current_place
                    places[index, :Sum] = 1000 + current_place
                    places_text[index, :Place] = string(current_place)
                    rule10_text[idx[id], current_place+1] .= string.(rule10_counts[idx[id], current_place+1]) .* "*" .* "(" .* string.(rule10_sums[idx[id], (current_place+1)]) .* ")"
                    rule10_text[index, :Place] = string(current_place)
                    current_place += 1
                else
                    # Rule 11
                    # @info "Rule 11"
                    skating_text, skating_result = skating_single_dance(rule11_table[idx[id[i]], :];
                        initial_place = current_place, initial_column = current_place, depth = size(places, 1))
                    if length(i) == 2
                        index = idx[id[i]]
                        places[index, :Place] .= skating_result[!, :Place]
                        places[index, :Sum] .= 1000 + current_place
                        places_text[index, :Place] .= skating_text[!, :Place]
                        rule11_text[index, (current_place+1):end] .= skating_text[!, (current_place+1):end]
                        current_place += 2
                    else
                        j = findall(==(minimum(skating_result[!, :Place])), skating_result[!, :Place])
                        if length(j) == 1
                            index = idx[id[i[j[1]]]]
                            places[index, :Place] = skating_result[j[1], :Place]
                            places[index, :Sum] = 1000 + current_place
                            places_text[index, :Place] = skating_text[j[1], :Place]
                            rule11_text[idx[id[i]], (current_place+1):(end-1)] .= skating_text[!, (current_place+1):(end-1)]
                            rule11_text[index, :Place] = skating_text[j[1], :Place]
                            current_place += 1
                        else
                            # @info "Rule 11 Tie"
                            # shared place
                            # code can probably be joined with the above part
                            index = idx[id[i[j]]]
                            place_list = range(current_place, length = length(j))
                            place = mean(place_list)
                            places[index, :Place] .= place
                            places[index, :Sum] .= 1000 + current_place
                            places_text[index, :Place] .= string(place)
                            rule11_text[index, (current_place+1):(end-1)] .= skating_text[!, (current_place+1):(end-1)]
                            rule11_text[index, :Place] .= string(place)
                            current_place = maximum(place_list) + 1
                        end
                    end
                end
            end
        end
    end
    return places_text, (; rule10 = rule10_text, rule11 = rule11_text), (; zip(Symbol.(dances), reports)...), places[!, [:Number, :Place]]
end

function skating_combined(dances, results_single_dances)
    return skating_combined(dances, results_single_dances, get_places(dances, results_single_dances)...)
end

"""
    get_places(dances, results_single_dances)

Collects the skating results for a vector of dances and result DataFrames.
"""
function get_places(dances, results_single_dances)
    places = DataFrame(Number = results_single_dances[1][!, :Number])
    reports = []
    for (i, df) in enumerate(results_single_dances)
        report, pl = skating_single_dance(df)
        push!(reports, report)
        insertcols!(places, Symbol(dances[i]) => pl[!, :Place])
    end
    return places, reports
end

"""
    get_rule11_table(results_single_dances)

Prepares a DataFrame with all judgements concatenated into a single table for use when 
applying Rule 11.
"""
function get_rule11_table(results_single_dances)
    numbers = DataFrame(Number = results_single_dances[1][!, :Number])
    df_cat = hcat([df[!, Not(:Number)] for df in results_single_dances]..., makeunique = true)
    return hcat(numbers, df_cat)
end