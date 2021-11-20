using BallroomSkatingSystem
using Documenter

DocMeta.setdocmeta!(BallroomSkatingSystem, :DocTestSetup, :(using BallroomSkatingSystem); recursive=true)

makedocs(;
    modules=[BallroomSkatingSystem],
    authors="Sören Dobberschütz <sdobberschuetz@gmx.net> and contributors",
    repo="https://github.com/sdobber/BallroomSkatingSystem.jl/blob/{commit}{path}#{line}",
    sitename="BallroomSkatingSystem.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://sdobber.github.io/BallroomSkatingSystem.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/sdobber/BallroomSkatingSystem.jl",
)
