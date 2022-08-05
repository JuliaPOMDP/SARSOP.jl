using Documenter, SARSOP

makedocs(
    modules = [SARSOP],
    format = Documenter.HTML(),
    sitename = "SARSOP.jl"
)

deploydocs(
    repo = "github.com/JuliaPOMDP/SARSOP.jl.git",
    versions = ["stable" => "v^", "v#.#"],
)
