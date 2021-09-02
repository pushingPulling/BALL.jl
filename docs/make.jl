push!(LOAD_PATH, "G:\\Python Programme\\BALL.jl\\src\\" )
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
        "BALL Documentation" => "index.md",
        "Manual" =>
            [
                "Getting Started" => "start.md",
                "Interfaces" => "interfaces.md",
                "Iteration" => "iteration.md",
                "Advanced Usage" => "advanced_usage.md"
            ],
        "Submodules" =>
            [
                "Concept" => "concept_page.md",
                "Kernel" => "kernel_page.md",
                "Fileformats" => "fileformats_page.md",
                "Molmec" => "molmec_page.md",
                "Structure" => "structure_page.md",
                "QSAR" => "qsar_page.md",
                "Miscellaneous" => "misc.md"
            ],
        "DevDocs" => "devdocs.md"
    ],
)

deploydocs(;
    repo="github.com/pushingPulling/BALL.jl",
)
