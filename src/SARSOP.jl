module SARSOP

import POMDPs: POMDP, Solver, Policy

export 
    SARSOPSolver,
    SARSOPSimulator,
    SARSOPEvaluator,
    PolicyGraphGenerator,
    POMDPFile,
    PolicyFile,

    solve!,
    simulate,
    evaluate,
    polgraph,
    to_pomdpx,

    SARSOP_EXAMPLES_DIR

const EXEC_POMDP_SOL = Pkg.dir("SARSOP", "deps", "appl-0.96", "src", "pomdpsol")
const EXEC_POMDP_SIM = Pkg.dir("SARSOP", "deps", "appl-0.96", "src", "pomdpsim")
const EXEC_POMDP_EVAL = Pkg.dir("SARSOP", "deps", "appl-0.96", "src", "pomdpeval")
const EXEC_POLICY_GRAPH_GENERATOR = Pkg.dir("SARSOP", "deps", "appl-0.96", "src", "polgraph")
const EXEC_POMDP_CONVERT = Pkg.dir("SARSOP", "deps", "appl-0.96", "src", "pomdpconvert")
const SARSOP_EXAMPLES_DIR = Pkg.dir("SARSOP", "deps", "appl-0.96", "examples")

const DEFAULT_PRECISION = 1e-3
const DEFAULT_TRIAL_IMPROVEMENT_FACTOR = 0.5

type SARSOPSolver <: Solver

    options::Dict{String,Any}

    function SARSOPSolver(;
        fast::Bool=false, # Use fast (but very picky) alternate parser for .pomdp files
        randomization::Bool=false, # run ends when target precision is reached
        precison::Float64=DEFAULT_PRECISION, # Turn on randomization for the sampling algorithm.
        timeout::Float64=NaN, # [sec] If running time exceeds the specified value, pomdpsol writes out a policy and terminates
        memory::Float64=NaN, # [MB] If memory usage exceeds the specified value, pomdpsol writes out a policy and terminates
        trial_improvement_factor::Float64=DEFAULT_TRIAL_IMPROVEMENT_FACTOR, 
                    # a trial terminates at a belief when the gap between its upper and lower bound is within 
                    # `improvement_constant` of the current precision at the initial belief
        policy_interval::Float64=NaN # the time interval between two consecutive write-out of policy files; defaults to only exporting at end
        )

        options = Dict{String,Any}()
        if fast
            options["fast"] = ""
        end
        if randomization
            options["randomization"] = ""
        end
        if !isapprox(precison, DEFAULT_PRECISION)
            options["precision"] = precison 
        end
        if !isnan(timeout)
            options["timeout"] = timeout
        end
        if !isnan(memory)
            options["memory"] = memory
        end
        if !isapprox(trial_improvement_factor, DEFAULT_TRIAL_IMPROVEMENT_FACTOR)
           options["trial-improvement-factor"] = trial_improvement_factor 
        end
        if !isnan(policy_interval)
            options["policy-interval"] = policy_interval
        end

        new(options)
    end
end
type SARSOPSimulator
    options::Dict{String,Any}

    function SARSOPSimulator(
        sim_len::Int, # number of steps to use in simulation
        sim_num::Int; # number of simulations to run
        fast::Bool=false, # use fast (but very picky) alternate parser for .pomdp files
        srand::Union(Int64,Nothing)=nothing, # set the rand seed for the simulation
        output_file::String=""
        )

        options = Dict{String,Any}()

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
type SARSOPEvaluator

    options::Dict{String,Any}

    function SARSOPEvaluator(
        sim_len::Int, # number of steps to use in simulation
        sim_num::Int; # number of simulations to run
        fast::Bool=false, # use fast (but very picky) alternate parser for .pomdp files
        srand::Union(Int64,Nothing)=nothing, # set the rand seed for the simulation
        memory::Float64=NaN, # [MD] No memory limit by default. 
                             # If memory usage exceeds the specified value,
                             # the evaluator will switch back to a more
                             # memory conservative (and slow) method.        
        output_file::String=""
        )

        options = Dict{String,Any}()

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
type PolicyGraphGenerator

    options::Dict{String,Any}

    function PolicyGraphGenerator(
        filename::String; # output name for the DOT file to be generated
        fast::Bool=false, # use fast (but very picky) alternate parser for .pomdp files
        graph_max_depth::Union(Int,Nothing)=nothing, # maximum horizon of the generated policy graph.
                                                     # There is no limit by default.
        graph_max_branch::Union(Int,Nothing)=nothing, # maximum number of branches 
                                                      # of the generated policy graph.
                                                      # Shown will be top in probability.
                                                      # There is no limit by default.
        graph_min_prob::Union(Float64,Nothing)=nothing, # minimum probability threshold for a branch
                                                    # to be shown in the policy graph
                                                    # defaults to zero
        )

        options = Dict{String,Any}()
        options["policy-graph"] = filename
        if fast
            options["fast"] = ""
        end
        if isa(graph_max_depth, Int)
            options["graph-max-depth"] = graph_max_depth
        end
        if isa(graph_max_branch, Int)
            options["graph-max-branch"] = graph_max_branch
        end
        if isa(graph_min_prob, Float64)
            options["graph-min-prob"] = graph_min_prob
        end

        new(options)
    end
end

type POMDPFile <: POMDP
    filename::String
end

type PolicyFile <: Policy
    filename::String
    PolicyFile(filename="out.policy") = new(filename)
end

function _get_options_list(options::Dict{String,Any})
    options_list = Array(String, 2*length(options))
    count = 0
    for (k,v) in options
        options_list[count+=1] = "--" * k
        if !isempty(v)
            options_list[count+=1] = string(v)
        end
    end
    options_list[1:count]
end

function solve!(policy::PolicyFile, solver::SARSOPSolver, pomdp::POMDPFile)
    if isempty(solver.options)
        run(`$EXEC_POMDP_SOL $(pomdp.filename) --output $(policy.filename)`)
    else
        options_list = _get_options_list(solver.options)
        run(`$EXEC_POMDP_SOL $(pomdp.filename) --output $(policy.filename) $options_list`)
    end
end

function simulate(simulator::SARSOPSimulator, policy::PolicyFile, pomdp::POMDPFile)
    options_list = _get_options_list(simulator.options)
    run(`$EXEC_POMDP_SIM $(pomdp.filename) --policy-file $(policy.filename) $options_list`)
end

function evaluate(evaluator::SARSOPEvaluator, policy::PolicyFile, pomdp::POMDPFile)
    options_list = _get_options_list(evaluator.options)
    run(`$EXEC_POMDP_EVAL $(pomdp.filename) --policy-file $(policy.filename) $options_list`)
end

function polgraph(graphgen::PolicyGraphGenerator, policy::PolicyFile, pomdp::POMDPFile)
    options_list = _get_options_list(graphgen.options)
    run(`$EXEC_POLICY_GRAPH_GENERATOR $(pomdp.filename) --policy-file $(policy.filename) $options_list`)
end

function to_pomdpx(pomdp::POMDPFile)
    @assert(splitext(pomdp.filename)[2] == ".pomdp")
    run(`$EXEC_POMDP_CONVERT $(pomdp.filename)`)
end

end # module
