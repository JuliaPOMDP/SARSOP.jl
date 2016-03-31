"""
    SARSOPSolver

Base solver type for SARSOP. Contains an options dictionary with the following entries:

* 'fast': use fast (but very picky) alternate parser for .pomdp files
* 'randomization': turn on randomization for the sampling algorithm
* 'precision': run ends when target precision is reached
* 'timeout':  [sec] If running time exceeds the specified value, pomdpsol writes out a policy and terminates
* 'memory': [MB] If memory usage exceeds the specified value, pomdpsol writes out a policy and terminates
* 'trial-improvement-factor': temrinates when the gap between bounds reaches this value
* 'policy-interval':  the time interval between two consecutive write-out of policy files
"""
type SARSOPSolver <: Solver

    options::Dict{AbstractString,Any}

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

        options = Dict{AbstractString,Any}()
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

"""
    solve(solver, pomdp, policy)

Runs pomdpsol using the options in 'solver' on 'pomdp', 
and writes out a .policy xml file specified by 'policy'.
"""
function solve(solver::SARSOPSolver, pomdp::SARSOPFile, policy::POMDPPolicy)
    if isempty(solver.options)
        run(`$EXEC_POMDP_SOL $(pomdp.filename) --output $(policy.filename)`)
    else
        options_list = _get_options_list(solver.options)
        run(`$EXEC_POMDP_SOL $(pomdp.filename) --output $(policy.filename) $options_list`)
    end
    policy.alphas = POMDPAlphas(policy.filename)
end

# generates a momdp policy file
function solve(solver::SARSOPSolver, pomdp::SARSOPFile, policy::MOMDPPolicy)
    if isempty(solver.options)
        run(`$EXEC_POMDP_SOL $(pomdp.filename) --output $(policy.filename)`)
    else
        options_list = _get_options_list(solver.options)
        run(`$EXEC_POMDP_SOL $(pomdp.filename) --output $(policy.filename) $options_list`)
    end
    policy.alphas = MOMDPAlphas(policy.filename)
end

