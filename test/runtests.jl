using BallroomSkatingSystem
using Test

# fixture for tests
function BallroomSkatingSystem.get_rule11_table(::Nothing)
    return nothing
end

@testset "Individual Dances" begin
    results1 = DataFrame(Number=[11, 12, 13, 14, 15],
        JudgeA=[1, 2, 3, 4, 5],
        JudgeB=[1, 3, 2, 4, 5],
        JudgeC=[1, 3, 2, 5, 4],
        JudgeD=[5, 1, 2, 3, 4],
        JudgeE=[2, 1, 5, 3, 4])

    results2 = DataFrame(Number=[11, 12, 13],
        JudgeA=[1, 2, 3],
        JudgeB=[1, 2, 3],
        JudgeC=[2, 1, 3],
        JudgeD=[2, 1, 3],
        JudgeE=[3, 2, 1])

    results3 = DataFrame(Number=[11, 12, 13],
        JudgeA=[1, 2, 3],
        JudgeB=[1, 2, 3],
        JudgeC=[2, 1, 3],
        JudgeD=[1, 3, 2],
        JudgeE=[2, 1, 3])

    results4 = DataFrame(Number=[11, 12, 13, 14],
        JudgeA=[1, 2, 3, 4],
        JudgeB=[1, 2, 3, 4],
        JudgeC=[3, 2, 4, 1],
        JudgeD=[3, 2, 1, 4],
        JudgeE=[4, 2, 1, 3])

    results5 = DataFrame(Number=[11, 12, 13, 14, 15],
        JudgeA=[1, 2, 5, 3, 4],
        JudgeB=[1, 4, 2, 3, 5],
        JudgeC=[1, 5, 2, 3, 4],
        JudgeD=[2, 1, 5, 3, 4],
        JudgeE=[5, 2, 1, 3, 4])

    # Multiple majorities
    skating1_text, skating1 = skating_single_dance(results1)
    @test skating1[!, :Number] == [11, 12, 13, 14, 15]
    @test skating1[!, :Place] == [1, 2, 3, 4, 5]

    # Clear majorities
    skating2_text, skating2 = skating_single_dance(results2)
    @test skating2[!, :Number] == [11, 12, 13]
    @test skating2[!, :Place] == [2, 1, 3]

    # No majority
    skating3_text, skating3 = skating_single_dance(results3)
    @test skating3[!, :Number] == [11, 12, 13]
    @test skating3[!, :Place] == [1, 2, 3]

    # Shared places and wins with 2nd place
    skating4_text, skating4 = skating_single_dance(results4)
    @test skating4[!, :Number] == [11, 12, 13, 14]
    @test skating4[!, :Place] == [2.5, 1, 2.5, 4]

    # Only evaluate a specific set of competitors
    skating5_text, skating5 = skating_single_dance(results5)
    @test skating5[!, :Number] == [11, 12, 13, 14, 15]
    @test skating5[!, :Place] == [1, 2, 3, 4, 5]
end

@testset "Multiple Dances w/o Rule 11" begin
    dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

    places1 = DataFrame(Number=[20, 30, 40, 50, 60, 70],
        Waltz=[2, 1, 6, 4, 5, 3],
        Tango=[1, 2, 6, 4, 3, 5],
        Viennese=[5, 2, 1, 4, 3, 6],
        Slowfox=[3, 6, 1, 4, 2, 5],
        Quickstep=[2, 6, 3, 1, 4, 5])

    places2 = DataFrame(Number=[19, 29, 39, 49, 59, 69],
        Waltz=[1, 3, 2, 6, 5, 4],
        Tango=[1, 4, 2, 3, 5, 6],
        Viennese=[2, 1, 3, 4, 5, 6],
        Slowfox=[3, 2, 1, 5, 4, 6],
        Quickstep=[2, 1, 3, 5, 4, 6])

    places3 = DataFrame(Number=[18, 28, 38, 48, 58, 68],
        Waltz=[3, 2, 1, 4, 5, 6],
        Tango=[1, 2, 4, 5, 3, 6],
        Viennese=[1, 3, 2, 6, 5, 4],
        Slowfox=[1, 2, 5, 4, 3, 6],
        Quickstep=[1, 6, 3, 2, 5, 4])

    places4 = DataFrame(Number=[17, 27, 37, 47, 57, 67],
        Waltz=[1, 3, 2, 4, 6, 5],
        Tango=[1, 3, 5, 2, 6, 4],
        Slowfox=[2, 1, 4, 3, 5, 6],
        Quickstep=[5, 2, 4, 6, 1, 3])

    places5 = DataFrame(Number=[16, 26, 36, 46, 56, 66],
        Waltz=[1, 3, 2, 4, 5, 6],
        Tango=[2, 1, 3, 4, 5, 6],
        Viennese=[1, 2, 3, 4, 5, 6],
        Slowfox=[2, 1, 3, 4, 5, 6],
        Quickstep=[2, 4, 3, 1, 6, 5])

    # Rule 10c
    places_text, rule10_text, rule11_text, pl1 = skating_combined(dances, nothing, places1, [0, 0, 0, 0, 0])
    @test pl1[!, :Number] == places1[!, :Number]
    @test pl1[!, :Place] == [1, 2, 3, 4, 5, 6]

    # Rule 10b (second part) and 10d
    places_text, rule10_text, rule11_text, pl2 = skating_combined(dances, nothing, places2, [0, 0, 0, 0, 0])
    @test pl2[!, :Number] == places2[!, :Number]
    @test pl2[!, :Place] == [1, 2, 3, 4, 5, 6]

    # Rule 10b (first part) and 10d
    places_text, rule10_text, rule11_text, pl3 = skating_combined(dances, nothing, places3, [0, 0, 0, 0, 0])
    @test pl3[!, :Number] == places3[!, :Number]
    @test pl3[!, :Place] == [1, 2, 3, 4, 5, 6]

    # Rule 10a and 10b
    places_text, rule10_text, rule11_text, pl4 = skating_combined(dances, nothing, places4, [0, 0, 0, 0, 0])
    @test pl4[!, :Number] == places4[!, :Number]
    @test pl4[!, :Place] == [1, 2, 4, 3, 6, 5]

    # Rule 9
    places_text, rule10_text, rule11_text, pl5 = skating_combined(dances, nothing, places5, [0, 0, 0, 0, 0])
    @test pl5[!, :Number] == places5[!, :Number]
    @test pl5[!, :Place] == [1, 2, 3, 4, 5, 6]
end

@testset "Rule 11a, 11b, 11c" begin
    dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

    resultsW = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[1, 2, 4, 3, 6, 5],
        JudgeB=[1, 2, 5, 3, 6, 4],
        JudgeC=[2, 5, 3, 6, 1, 4],
        JudgeD=[5, 2, 1, 3, 4, 6],
        JudgeE=[3, 5, 1, 6, 4, 2])

    resultsT = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[1, 5, 3, 4, 2, 6],
        JudgeB=[2, 3, 1, 4, 5, 6],
        JudgeC=[2, 1, 3, 4, 5, 6],
        JudgeD=[3, 2, 1, 4, 5, 6],
        JudgeE=[4, 2, 3, 1, 5, 6])

    resultsV = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[1, 3, 5, 2, 4, 6],
        JudgeB=[1, 2, 3, 6, 4, 5],
        JudgeC=[2, 1, 3, 6, 5, 4],
        JudgeD=[2, 1, 6, 3, 5, 4],
        JudgeE=[3, 2, 1, 4, 6, 5])

    resultsS = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[2, 1, 5, 3, 6, 4],
        JudgeB=[2, 1, 6, 3, 4, 5],
        JudgeC=[5, 2, 3, 1, 6, 4],
        JudgeD=[1, 5, 2, 3, 6, 4],
        JudgeE=[5, 2, 3, 6, 4, 1])

    resultsQ = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[2, 1, 3, 5, 4, 6],
        JudgeB=[6, 5, 2, 1, 4, 3],
        JudgeC=[2, 1, 4, 5, 6, 3],
        JudgeD=[6, 5, 2, 1, 3, 4],
        JudgeE=[1, 2, 4, 3, 6, 5])

    results = [resultsW, resultsT, resultsV, resultsS, resultsQ]

    places_text, rule10_text, rule11_text, pl = skating_combined(dances, results)
    @test pl[!, :Number] == resultsW[!, :Number]
    @test pl[!, :Place] == [2, 1, 3, 4, 6, 5]
end

@testset "Rule 11b" begin
    dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

    resultsW = DataFrame(Number=[26, 36, 46, 56, 66, 76],
        JudgeA=[1, 2, 3, 4, 6, 5],
        JudgeB=[1, 2, 3, 5, 6, 4],
        JudgeC=[2, 5, 6, 3, 1, 4],
        JudgeD=[5, 2, 3, 1, 4, 6],
        JudgeE=[3, 5, 6, 1, 4, 2])

    resultsT = DataFrame(Number=[26, 36, 46, 56, 66, 76],
        JudgeA=[1, 5, 4, 3, 2, 6],
        JudgeB=[2, 3, 4, 1, 5, 6],
        JudgeC=[2, 1, 4, 3, 5, 6],
        JudgeD=[3, 2, 4, 1, 5, 6],
        JudgeE=[4, 2, 1, 3, 5, 6])

    resultsV = DataFrame(Number=[26, 36, 46, 56, 66, 76],
        JudgeA=[1, 2, 3, 4, 5, 6],
        JudgeB=[1, 3, 4, 5, 2, 6],
        JudgeC=[1, 4, 5, 6, 2, 3],
        JudgeD=[1, 5, 6, 2, 3, 4],
        JudgeE=[1, 6, 2, 3, 4, 5])

    resultsS = DataFrame(Number=[26, 36, 46, 56, 66, 76],
        JudgeA=[1, 5, 2, 3, 4, 6],
        JudgeB=[1, 6, 2, 3, 5, 4],
        JudgeC=[2, 3, 5, 1, 4, 6],
        JudgeD=[5, 2, 1, 3, 4, 6],
        JudgeE=[2, 3, 5, 6, 1, 4])

    resultsQ = DataFrame(Number=[26, 36, 46, 56, 66, 76],
        JudgeA=[1, 3, 2, 5, 6, 4],
        JudgeB=[5, 2, 6, 1, 3, 4],
        JudgeC=[1, 4, 2, 5, 3, 6],
        JudgeD=[5, 2, 6, 1, 4, 3],
        JudgeE=[2, 4, 1, 3, 5, 6])

    results = [resultsW, resultsT, resultsV, resultsS, resultsQ]

    places_text, rule10_text, rule11_text, pl = skating_combined(dances, results)
    @test pl[!, :Number] == resultsW[!, :Number]
    @test pl[!, :Place] == [1, 2, 3, 4, 5, 6]
end

@testset "Rule 11d" begin
    dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

    resultsW = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[1, 2, 4, 3, 6, 5],
        JudgeB=[1, 2, 5, 3, 6, 4],
        JudgeC=[2, 5, 3, 6, 1, 4],
        JudgeD=[5, 2, 1, 3, 4, 6],
        JudgeE=[3, 5, 1, 6, 4, 2])

    resultsT = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[1, 5, 3, 4, 2, 6],
        JudgeB=[2, 3, 1, 4, 5, 6],
        JudgeC=[2, 1, 3, 4, 5, 6],
        JudgeD=[3, 2, 1, 4, 5, 6],
        JudgeE=[4, 2, 3, 1, 5, 6])

    resultsV = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[1, 3, 5, 2, 4, 6],
        JudgeB=[1, 2, 3, 6, 4, 5],
        JudgeC=[2, 1, 3, 6, 5, 4],
        JudgeD=[2, 1, 6, 3, 5, 4],
        JudgeE=[3, 2, 1, 4, 6, 5])

    resultsS = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[2, 1, 5, 3, 6, 4],
        JudgeB=[2, 1, 6, 3, 4, 5],
        JudgeC=[5, 2, 3, 1, 6, 4],
        JudgeD=[1, 5, 2, 3, 6, 4],
        JudgeE=[5, 2, 3, 6, 4, 1])

    resultsQ = DataFrame(Number=[25, 35, 45, 55, 65, 75],
        JudgeA=[2, 1, 3, 5, 4, 6],
        JudgeB=[6, 5, 2, 1, 4, 3],
        JudgeC=[2, 1, 4, 5, 6, 3],
        JudgeD=[6, 5, 2, 1, 3, 4],
        JudgeE=[1, 2, 4, 3, 6, 5])

    results = [resultsW, resultsT, resultsV, resultsS, resultsQ]

    places_text, rule10_text, rule11_text, pl = skating_combined(dances, results)
    @test pl[!, :Number] == resultsW[!, :Number]
    @test pl[!, :Place] == [2, 1, 3, 4, 6, 5]
end

@testset "Rule 11b" begin
    dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

    resultsW = DataFrame(Number=[27, 37, 47, 57, 67, 77],
        JudgeA=[2, 3, 4, 1, 6, 5],
        JudgeB=[2, 3, 5, 1, 6, 4],
        JudgeC=[5, 6, 3, 2, 1, 4],
        JudgeD=[2, 3, 1, 5, 4, 6],
        JudgeE=[5, 6, 1, 3, 4, 2])

    resultsT = DataFrame(Number=[27, 37, 47, 57, 67, 77],
        JudgeA=[1, 3, 2, 4, 6, 5],
        JudgeB=[2, 1, 5, 4, 6, 3],
        JudgeC=[2, 3, 5, 4, 6, 1],
        JudgeD=[3, 1, 5, 4, 6, 2],
        JudgeE=[4, 3, 5, 1, 6, 2])

    resultsV = DataFrame(Number=[27, 37, 47, 57, 67, 77],
        JudgeA=[1, 2, 3, 4, 5, 6],
        JudgeB=[1, 3, 4, 5, 2, 6],
        JudgeC=[1, 4, 5, 6, 2, 3],
        JudgeD=[1, 5, 6, 2, 3, 4],
        JudgeE=[1, 6, 2, 3, 4, 5])

    resultsS = DataFrame(Number=[27, 37, 47, 57, 67, 77],
        JudgeA=[3, 1, 4, 5, 2, 6],
        JudgeB=[3, 1, 5, 6, 2, 4],
        JudgeC=[1, 2, 4, 3, 5, 6],
        JudgeD=[3, 5, 4, 2, 1, 6],
        JudgeE=[6, 2, 1, 3, 5, 4])

    resultsQ = DataFrame(Number=[27, 37, 47, 57, 67, 77],
        JudgeA=[2, 4, 1, 6, 5, 3],
        JudgeB=[6, 4, 5, 3, 1, 2],
        JudgeC=[2, 6, 1, 3, 5, 4],
        JudgeD=[6, 3, 5, 4, 1, 2],
        JudgeE=[1, 6, 2, 5, 4, 3])

    results = [resultsW, resultsT, resultsV, resultsS, resultsQ]

    places_text, rule10_text, rule11_text, pl = skating_combined(dances, results)
    @test pl[!, :Number] == resultsW[!, :Number]
    @test pl[!, :Place] == [1, 2, 3, 4, 5, 6]
end

@testset "Tie with Rule 11" begin
    # Artificial example to hit code
    dances = ["Waltz", "Tango", "Viennese Waltz"]

    resultsW = DataFrame(Number=[10, 20, 30],
        JudgeA=[1, 1, 1],
        JudgeB=[1, 1, 1],
        JudgeC=[1, 1, 1],
        JudgeD=[1, 1, 1],
        JudgeE=[1, 1, 1])

    resultsT = DataFrame(Number=[10, 20, 30],
        JudgeA=[1, 1, 1],
        JudgeB=[1, 1, 1],
        JudgeC=[1, 1, 1],
        JudgeD=[1, 1, 1],
        JudgeE=[1, 1, 1])

    resultsV = DataFrame(Number=[10, 20, 30],
        JudgeA=[1, 1, 1],
        JudgeB=[1, 1, 1],
        JudgeC=[1, 1, 1],
        JudgeD=[1, 1, 1],
        JudgeE=[1, 1, 1])

    results = [resultsW, resultsT, resultsV]

    places_text, rule10_text, rule11_text, pl = skating_combined(dances, results)
    @test pl[!, :Number] == resultsW[!, :Number]
    @test pl[!, :Place] == [2, 2, 2]
end

@testset "Error in sum calculation" begin
    results = DataFrame(Number=[11, 12, 13, 14, 15, 16],
        JudgeA=[2, 5, 4, 5, 6, 1],
        JudgeB=[1, 5, 5, 3, 6, 1],
        JudgeC=[2, 3, 5, 4, 6, 1],
        JudgeD=[1, 4, 3, 5, 6, 1],
        JudgeE=[2, 3, 4, 4, 6, 1])
    calculation, places = skating_single_dance(results)
    @test places[:, :Place] == [2.0, 3.0, 4.5, 4.5, 6.0, 1.0]
end
