using Documenter, SARSOP

makedocs(
    # options
    modules = [SARSOP]    
)

deploydocs(
    repo = "github.com/JuliaPOMDP/SARSOP.jl.git",
    julia = "release",
    osname = "linux"
)
