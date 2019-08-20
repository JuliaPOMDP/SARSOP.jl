"""
    POMDPFile

Writes a pomdpx file from a pomdp defined using the explicit interface of POMDPs.jl

# Constructors
- `POMDPFile(filename)` just stores the file name if the file exists
- `POMDPFile(pomdp::POMDP, filename="model.pomdpx"; verbose=true)` writes a .pomdpx file from the pomdp definition
"""
struct POMDPFile
    filename::AbstractString

    function POMDPFile(filename)
        @assert isfile(filename) "Pomdpx file $(filename) does not exist"
        return new(filename)
    end
end

function POMDPFile(pomdp::POMDP, filename="model.pomdpx"; verbose=true)
    pomdpx = POMDPXFile(filename)
    if verbose
        println("Generating a pomdpx file: $(filename)")
    end
    write(pomdp, pomdpx)
    return POMDPFile(filename)
end
