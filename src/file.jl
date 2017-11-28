abstract type SARSOPFile end


mutable struct POMDPFile <: SARSOPFile
    filename::AbstractString

    function POMDPFile(filename)
        @assert isfile(filename) "Pomdpx file $(filename) does not exist"
        return new(filename)
    end
    function POMDPFile(pomdp::POMDP, filename="model.pomdpx"; silent=false)
        pomdpx = POMDPXFile(filename)
        if silent == false
            println("Generating a pomdpx file: $(filename)")
        end
        write(pomdp, pomdpx)
        return new(filename)
    end
end
