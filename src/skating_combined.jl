## Skating system for final placement

function skating_combined(dances, results_single_dances, places, reports)
    rule10_counts = DataFrame(Number = places[!, :Number])
    rule10_sums = DataFrame(Number = places[!, :Number])
    # num_of_places = DataFrame(Number = results[!, :Number])

    # code similar to above - reuse!
    for i = 1:size(rule10_counts, 1)
        insertcols!(rule10_counts, Symbol("1-$(i)") => vec(count(<=(i), places[!, Not(:Number)] |> Array, dims = 2)))
        if i == 1
            insertcols!(rule10_sums, Symbol("1-$(i)") => rule10_counts[:, i+1])
        else
            insertcols!(rule10_sums, Symbol("1-$(i)") => i .* (rule10_counts[:, i+1] - rule10_counts[:, i]) + rule10_sums[:, i])
        end
    end
    places[!, :Sum] = sum(eachcol(places[!, Not(:Number)]))
    places[!, :Place] .= 0.0
    places_text = string.(copy(places))
    rule10_text = string.(copy(rule10_counts))
    rule10_text[!, Not(:Number)] .= "-"
    rule10_text[!, :Place] .= "-"

    rule11_table = get_rule11_table(results_single_dances)
    rule11_text = copy(rule10_text)

    current_place = 1
    steps = 1
    while current_place <= size(places, 1) && steps <= 10
        @info steps
        idx = findall(==(minimum(places[!, :Sum])), places[!, :Sum])
        @show idx
        if length(idx) == 1
            @info "Minimum sum"
            places[idx[1], :Place] = current_place
            places[idx[1], :Sum] = 1000 + current_place
            places_text[idx[1], :Place] = string(current_place)
            current_place += 1
        else
            # Rule 10
            id = findall(==(maximum(rule10_counts[idx, current_place+1])), rule10_counts[idx, current_place+1])
            @show id
            if length(id) == 1
                @info "Minimum better places"
                places[idx[id[1]], :Place] = current_place
                places[idx[id[1]], :Sum] = 1000 + current_place
                places_text[idx[id[1]], :Place] = string(current_place)
                rule10_text[idx, current_place+1] .= string.(rule10_counts[idx, current_place+1])
                rule10_text[idx[id[1]], :Place] = string(current_place)
                current_place += 1
            else
                @info "Minimum better summed places"
                i = findall(==(minimum(rule10_sums[idx[id], current_place+1])), rule10_sums[idx[id], current_place+1])
                @show i
                if length(i) == 1
                    places[idx[id[i[1]]], :Place] = current_place
                    places[idx[id[i[1]]], :Sum] = 1000 + current_place
                    places_text[idx[id[i[1]]], :Place] = string(current_place)
                    rule10_text[idx[id], current_place+1] .= string.(rule10_counts[idx[id], current_place+1]) .* "*" .* "(" .* string.(rule10_sums[idx[id], (current_place+1)]) .* ")"
                    rule10_text[idx[id[i[1]]], :Place] = string(current_place)
                    current_place += 1
                else
                    # Rule 11
                    @info "Rule 11"
                    @show idx[id[i]]
                    @show current_place
                    skating_text, skating_result = skating_single_dance(rule11_table[idx[id[i]], :];
                        initial_place = current_place, initial_column = current_place, depth = size(places, 1))
                    @show skating_text
                    if length(i) == 2
                        places[idx[id[i]], :Place] .= skating_result[!, :Place]
                        places[idx[id[i]], :Sum] .= 1000 + current_place
                        places_text[idx[id[i]], :Place] .= skating_text[!, :Place]
                        rule11_text[idx[id[i]], (current_place+1):end] .= skating_text[!, (current_place+1):end]
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
                            ### shared place?
                        end
                    end

                end
            end
        end

        steps += 1
    end
    return places_text, rule10_text, rule11_text, places[!, [:Number, :Place]]
end

function skating_combined(dances, results_single_dances)
    return skating_combined(dances, results_single_dances, get_places(dances, results_single_dances)...)
end

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

function get_rule11_table(results_single_dances)
    numbers = DataFrame(Number = results_single_dances[1][!, :Number])
    df_cat = hcat([df[!, Not(:Number)] for df in results_single_dances]..., makeunique = true)
    return hcat(numbers, df_cat)
end