abstract SARSOPFile <: POMDP

type POMDPFile <: SARSOPFile
    filename::String
end
function POMDPFile(pomdp::POMDP, filename="model.pomdpx")
    pomdpx = POMDPX(filename)
    if !isfile(filename)
        write(pomdp, pomdpx)
    end
    return POMDPFile(filename)
end

type MOMDPFile <: SARSOPFile
    filename::String
end
function MOMDPFile(pomdp::POMDP, filename="model.pomdpx")
    pomdpx = MOMDPX(filename)
    if !isfile(filename)
        write(pomdp, pomdpx)
    end
    return MOMDPFile(filename)
end
