using Documenter, SARSOP

makedocs(
    modules=[SARSOP],
    checkdocs=:exports,
    format=Documenter.HTML(),
    sitename="SARSOP.jl"
)

deploydocs(
    repo = "github.com/JuliaPOMDP/SARSOP.jl.git",
    versions = ["stable" => "v^", "v#.#"],
)
