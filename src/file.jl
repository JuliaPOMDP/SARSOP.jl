abstract SARSOPFile <: POMDP


type POMDPFile <: SARSOPFile
    filename::AbstractString

    function POMDPFile(filename)
        @assert isfile(filename) "Pomdpx file $(filename) does not exist"
        return new(filename)
    end
    function POMDPFile(pomdp::POMDP, filename="model.pomdpx")
        pomdpx = POMDPX(filename)
        println("Generating a pomdpx file: $(filename)")
        write(pomdp, pomdpx)
        return new(filename)
    end
end


type MOMDPFile <: SARSOPFile
    filename::AbstractString

    function POMDPFile(filename)
        @assert isfile(filename) "Pomdpx file $(filename) does not exist"
        return new(filename)
    end
    function MOMDPFile(pomdp::POMDP, filename="model.pomdpx")
        pomdpx = MOMDPX(filename)
        if !isfile(filename)
            println("Generating a pomdpx file: $(filename)")
            write(pomdp, pomdpx)
        end
        return new(filename)
    end
end
