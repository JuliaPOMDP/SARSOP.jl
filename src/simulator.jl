"""
    SARSOPSimulator

simulate a sarsop policy from the xml files 
* `sim_len`  number of steps to use in simulation (default 10)
* `sim_num` number of simulations
* `fast` use fast (but very picky) alternate parser for .pomdp files
* `srand` set the random seed for the simulation
* `output_file` where to write the results
* `policy_filename` policy file location
* `pomdp_filename` pomdpx file location
"""
@with_kw struct SARSOPSimulator
    sim_len::Int = 10
    sim_num::Int = 10
    fast::Bool = false 
    srand::Union{Int64, Nothing} = nothing 
    output_file::AbstractString = ""
    policy_filename::AbstractString = "policy.out"
    pomdp_filename::AbstractString = "model.pomdpx"
end

function get_simulator_options(sim::SARSOPSimulator)
    options = String[]
    push!(options, "--simLen")
    push!(options, string(sim.sim_len))
    push!(options, "--simNum")
    push!(options, string(sim.sim_num))
    if sim.fast 
        push!(options, "--fast")
    end
    if sim.srand != nothing 
        push!(options, "--srand")
        push!(options, string(sim.srand))
    end
    push!(options, "--output-file")
    push!(options, sim.output_file)
    return options 
end

"""
    POMDPs.simulate(sim::SARSOPSimulator)

Simulate a SARSOP policy according to the config specified by `sim::SARSOPSimulator`
"""
function POMDPs.simulate(sim::SARSOPSimulator)
    options_list = get_simulator_options(sim)
    run(`$EXEC_POMDP_SIM $(sim.pomdp_filename) --policy-file $(sim.policy_filename) $options_list`)
end

"""
    SARSOPEvaluator

simulate a sarsop policy from the xml files 
* `sim_len`  number of steps to use in simulation (default 10)
* `sim_num` number of simulations
* `fast` use fast (but very picky) alternate parser for .pomdp files
* `srand` set the random seed for the simulation
* `memory` [MB] No memory limit by default. If memory usage exceeds the specified value, the evaluator will switch back 
to a more conservative (and slow) methods.
* `output_file` where to write the results
* `policy_filename` policy file location
* `pomdp_filename` pomdpx file location
"""
@with_kw struct SARSOPEvaluator
    sim_len::Int = 10
    sim_num::Int = 10 
    fast::Bool = false 
    srand::Union{Int64, Nothing} = nothing
    memory::Union{Float64, Nothing} = nothing 
    output_file::AbstractString = ""
    policy_filename::AbstractString = "policy.out"
    pomdp_filename::AbstractString = "model.pomdpx"
end

function get_evaluator_options(ev::SARSOPEvaluator)
    options = String[]
    push!(options, "--simLen")
    push!(options, string(ev.sim_len))
    push!(options, "--simNum")
    push!(options, string(ev.sim_num))
    if ev.fast 
        push!(options, "--fast")
    end
    if ev.srand != nothing 
        push!(options, "--srand")
        push!(options, string(ev.srand))
    end
    if ev.memory != nothing 
        push!(options, "--memory")
        push!(options, string(ev.memory))
    end
    push!(options, "--output-file")
    push!(options, ev.output_file)
    return options 
end

"""
    evaluate(ev::SARSOPEvaluator)

simulate a SARSOP policy according to the configuration specified by `ev::SARSOPEvaluator`
"""
function evaluate(ev::SARSOPEvaluator)
    options_list = get_evaluator_options(ev)
    run(`$EXEC_POMDP_EVAL $(ev.pomdp_filename) --policy-file $(ev.policy_filename) $options_list`)
end
