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
