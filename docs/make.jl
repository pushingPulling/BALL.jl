using BALL
using Documenter

DocMeta.setdocmeta!(BALL, :DocTestSetup, :(using BALL); recursive=true)

makedocs(;
    modules=[BALL],
    authors="Daniel Klima <dklima@students.uni-mainz.de>",
    repo="https://github.com/pushingPulling/BALL.jl/blob/{commit}{path}#{line}",
    sitename="BALL.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://pushingPulling.github.io/BALL.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pushingPulling/BALL.jl",
)
