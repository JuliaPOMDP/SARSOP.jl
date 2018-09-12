mutable struct SARSOPSimulator <: Simulator
    options::Dict{AbstractString,Any}

    function SARSOPSimulator(
        sim_len::Int, # number of steps to use in simulation
        sim_num::Int; # number of simulations to run
        fast::Bool=false, # use fast (but very picky) alternate parser for .pomdp files
        srand::Union{Int64,Nothing}=nothing, # set the rand seed for the simulation
        output_file::AbstractString=""
        )

        options = Dict{AbstractString,Any}()

        options["simLen"] = sim_len
        options["simNum"] = sim_num
        if fast
            options["fast"] = ""
        end
        if isa(srand, Int)
            options["srand"] = srand
        end
        if !isempty(output_file)
            options["output-file"] = output_file
        end

        new(options)
    end
end
mutable struct SARSOPEvaluator

    options::Dict{AbstractString,Any}

    function SARSOPEvaluator(
        sim_len::Int, # number of steps to use in simulation
        sim_num::Int; # number of simulations to run
        fast::Bool=false, # use fast (but very picky) alternate parser for .pomdp files
        srand::Union{Int64,Nothing}=nothing, # set the rand seed for the simulation
        memory::Float64=NaN, # [MD] No memory limit by default.
                             # If memory usage exceeds the specified value,
                             # the evaluator will switch back to a more
                             # memory conservative (and slow) method.
        output_file::AbstractString=""
        )

        options = Dict{AbstractString,Any}()

        options["simLen"] = sim_len
        options["simNum"] = sim_num
        if fast
            options["fast"] = ""
        end
        if isa(srand, Int)
            options["srand"] = srand
        end
        if !isnan(memory)
            options["memory"] = memory
        end
        if !isempty(output_file)
            options["output-file"] = output_file
        end

        new(options)
    end
end

function simulate(simulator::SARSOPSimulator, pomdp::SARSOPFile, policy::SARSOPPolicy)
    options_list = _get_options_list(simulator.options)
    run(`$EXEC_POMDP_SIM $(pomdp.filename) --policy-file $(policy.filename) $options_list`)
end

function evaluate(evaluator::SARSOPEvaluator, pomdp::SARSOPFile, policy::SARSOPPolicy)
    options_list = _get_options_list(evaluator.options)
    run(`$EXEC_POMDP_EVAL $(pomdp.filename) --policy-file $(policy.filename) $options_list`)
end
