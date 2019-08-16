# Package Guide 

## Installation

The package can be installed by either cloning the code and running build or by using the `add` function from
[POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl)

Installation with POMDPs.jl:
```julia
using POMDPs
using Pkg
POMDPs.add_registry()
Pkg.add("SARSOP")
```

## Usage

SARSOP.jl makes it easy to interface with the APPL SARSOP solver. Once you have a model defined according to POMDPs.jl,
you can generate policies by running the following:

```julia
using POMDPs
using SARSOP
using POMDPModels # this contains the TigerPOMDP model

pomdp = TigerPOMDP() # this comes from POMDPModels, you will want this to be your concrete POMDP type

solver = SARSOPSolver()
policy = solve(solver, pomdp)

# the policy will be saved to a file and can be loaded in an other julia session as follows:
policy = load_policy(pomdp, "policy.out")
```

We can simulate, evaluate and create policy graphs:

```julia
using POMDPModelTools
# Policy can be used to map belief to actions
b = uniform_belief(pomdp) # from POMDPModelTools
a = action(policy, b) 

# simulate the SARSOP policy
simulator = SARSOPSimulator(sim_num = 5, sim_len = 5, 
                            policy_filename = "policy.out",
                            pomdp_filename = "model.pomdpx")
simulate(simulator) 

# evaluate the SARSOP policy
evaluator = SARSOPEvaluator(sim_num = 5, sim_len = 5, 
                            policy_filename = "policy.out",
                            pomdp_filename = "model.pomdpx")
evaluate(evaluator)

# generates a policy graph
graphgen = PolicyGraphGenerator(graph_filename = "Tiger.dot",
                                policy_filename = "policy.out",
                                pomdp_filename = "model.pomdpx")
generate_graph(graphgen)
```
