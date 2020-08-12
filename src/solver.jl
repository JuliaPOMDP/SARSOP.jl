"""
    SARSOPSolver

Base solver type for SARSOP. Contains an options dictionary with the following entries:

* 'fast': use fast (but very picky) alternate parser for .pomdp files
* 'randomization': turn on randomization for the sampling algorithm
* 'precision': run ends when target precision is reached
* 'timeout':  [sec] If running time exceeds the specified value, pomdpsol writes out a policy and terminates
* 'memory': [MB] If memory usage exceeds the specified value, pomdpsol writes out a policy and terminates
* 'trial-improvement-factor': terminates when the gap between bounds reaches this value
* 'policy-interval':  the time interval between two consecutive write-out of policy files
* `verbose`: [true/false] whether to print output from the solver. Default: true
"""
@with_kw mutable struct SARSOPSolver <: Solver
    fast::Bool = false 
    randomization::Bool = false 
    precision::Float64 = 1e-3
    timeout::Union{Nothing, Float64} = nothing
    memory::Union{Nothing, Float64} = nothing
    trial_improvement_factor::Float64 = 0.5
    policy_interval::Union{Nothing, Float64} = nothing
    verbose::Bool = true
    policy_filename::String = "policy.out"
    pomdp_filename::String = "model.pomdpx"
end

function get_solver_options(solver::SARSOPSolver)
    options_list = AbstractString[]
    if solver.fast 
        push!(options_list, "--fast")
    end
    if solver.randomization
        push!(options_list, "--randomization")
    end
    push!(options_list, "--precision")
    push!(options_list, string(solver.precision))
    if solver.timeout != nothing
        push!(options_list, "--timeout")
        push!(options_list, string(solver.timeout))
    end
    if solver.memory != nothing
        push!(options_list, "--memory")
        push!(options_list, string(solver.memory))
    end
    push!(options_list, "--trial-improvement-factor")
    push!(options_list, string(solver.trial_improvement_factor))
    if solver.policy_interval != nothing
        push!(options_list, "--policy-interval")
        push!(options_list, string(solver.policy_interval))
    end
    return options_list
end

"""
    solve(solver, pomdp, policy)

Runs pomdpsol using the options in 'solver' on 'pomdp',
and writes out a .policy xml file specified by 'policy'.
"""
function POMDPs.solve(solver::SARSOPSolver, pomdp::POMDP; kwargs...)
    if !isempty(kwargs)
        @warn("Keyword args for solve(::SARSOPSolver, ::POMDP) are no longer supported. Use the options in the SARSOPSolver")
    end
    pomdp_file = POMDPFile(pomdp, solver.pomdp_filename, verbose=solver.verbose)
    options = get_solver_options(solver)
    pomdpsol() do pomdpsol_path
        if solver.verbose 
            run(`$pomdpsol_path $(pomdp_file.filename) --output $(solver.policy_filename) $options`)
        else
            success(`$pomdpsol_path $(pomdp_file.filename) --output $(solver.policy_filename) $options`)
        end
    end
    alphas = POMDPAlphas(solver.policy_filename)
    action_map = broadcast(x -> getindex(ordered_actions(pomdp), x), alphas.alpha_actions .+ 1)
    return AlphaVectorPolicy(pomdp, alphas.alpha_vectors, action_map)
end

POMDPs.solve(solver::SARSOPSolver, mdp::MDP) = mdp_error()

# utilities 

"""
    load_policy(pomdp::POMDP, file_name::AbstractString)

Load a policy from an xml file output by SARSOP.
"""
function load_policy(pomdp::POMDP, file_name::AbstractString)
    alphas = nothing
    if isfile(file_name)
        alphas = POMDPAlphas(file_name)
    else
        error("Policy file ", file_name, " does not exist")
    end
    action_map = broadcast(x -> getindex(ordered_actions(pomdp), x), alphas.alpha_actions .+ 1)
    return AlphaVectorPolicy(pomdp, alphas.alpha_vectors, action_map)
end

"""
    to_pomdpx(pomdp::POMDPFile)

Convert a .pomdp file to a .pomdpx file.
"""
function to_pomdpx(pomdp::POMDPFile)
    @assert(splitext(pomdp.filename)[2] == ".pomdp")
    pomdpconvert() do pomdpconvert_path
        run(`$pomdpconvert_path $(pomdp.filename)`)
    end
end

mdp_error() = error("SARSOP is designed to solve POMDPs and is not set up to solve MDPs; consider using DiscreteValueIteration.jl to solve MDPs.")

POMDPLinter.@POMDP_require solve(solver::SARSOPSolver, pomdp::POMDP) begin
    P = typeof(pomdp)
    S = statetype(P)
    A = actiontype(P)
    O = obstype(P)
    @req discount(::P)
    @subreq ordered_states(pomdp)
    @subreq ordered_actions(pomdp)
    @subreq ordered_observations(pomdp)
    @req transition(::P,::S,::A)
    @req reward(::P,::S,::A)
    @req stateindex(::P,::S)
    @req obsindex(::P,::O)
    @req observations(::P)
    @req observation(::P,::A,::S)
    @req actionindex(::P, ::A)
    @req actions(::P, ::S)
    as = actions(pomdp)
    ss = states(pomdp)
    a = first(as)
    s = first(ss)
    dist = transition(pomdp, s, a)
    D = typeof(dist)
    @req support(::D)
    @req pdf(::D,::S)
end
