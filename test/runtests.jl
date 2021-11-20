using BallroomSkatingSystem
using Test

@testset "Individual Dances" begin
    results1 = DataFrame(Number = [11, 12, 13, 14, 15],
        JudgeA = [1, 2, 3, 4, 5],
        JudgeB = [1, 3, 2, 4, 5],
        JudgeC = [1, 3, 2, 5, 4],
        JudgeD = [5, 1, 2, 3, 4],
        JudgeE = [2, 1, 5, 3, 4])

    results2 = DataFrame(Number = [11, 12, 13],
        JudgeA = [1, 2, 3],
        JudgeB = [1, 2, 3],
        JudgeC = [2, 1, 3],
        JudgeD = [2, 1, 3],
        JudgeE = [3, 2, 1])

    results3 = DataFrame(Number = [11, 12, 13],
        JudgeA = [1, 2, 3],
        JudgeB = [1, 2, 3],
        JudgeC = [2, 1, 3],
        JudgeD = [1, 3, 2],
        JudgeE = [2, 1, 3])

    results4 = DataFrame(Number = [11, 12, 13, 14],
        JudgeA = [1, 2, 3, 4],
        JudgeB = [1, 2, 3, 4],
        JudgeC = [3, 2, 4, 1],
        JudgeD = [3, 2, 1, 4],
        JudgeE = [4, 2, 1, 3])

    results5 = DataFrame(Number = [11, 12, 13, 14, 15],
        JudgeA = [1, 2, 5, 3, 4],
        JudgeB = [1, 4, 2, 3, 5],
        JudgeC = [1, 5, 2, 3, 4],
        JudgeD = [2, 1, 5, 3, 4],
        JudgeE = [5, 2, 1, 3, 4])

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

@testset "Multiple Dances" begin

end
