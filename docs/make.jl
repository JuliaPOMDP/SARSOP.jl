using Documenter, SARSOP

makedocs(
    modules = [SARSOP],
    format = :html,
    sitename = "SARSOP.jl"
)

deploydocs(
    repo = "github.com/JuliaPOMDP/SARSOP.jl.git",
    julia = "1.1",
    osname = "linux",
    target = "build",
    deps = nothing,
    make = nothing
)