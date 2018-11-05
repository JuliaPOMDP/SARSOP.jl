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
using SARSOP
using POMDPModels # this contains the TigerPOMDP model

pomdp = TigerPOMDP() # this comes from POMDPModels, you will want this to be your concrete POMDP type

# If the policy file already exists, it will be loaded by default
policy = load_policy("tiger.policy")

solver = SARSOPSolver()
solve(solver, pomdp) # no need to use solve if "mypolicy.policy" already exists
```

We can simulate, evaluate and create policy graphs:

```julia
# Policy can be used to map belief to actions
ns = n_states(pomdp) # implemented by user
b = initial_belief(pomdp) # implemented by user
a = action(policy, b) 

# simulate the SARSOP policy
simulator = SARSOPSimulator(num_sim = 5, sim_len = 5, 
                            policy_filename = "policy.out",
                            pomdp_filename = "model.pomdpx")
simulate(simulator) 

# evaluate the SARSOP policy
evaluator = SARSOPEvaluator(num_sim = 5, sim_len = 5, 
                            policy_filename = "policy.out",
                            pomdp_filename = "model.pomdpx")
evaluate(evaluator)

# generates a policy graph
graphgen = PolicyGraphGenerator(graph_filename = "Tiger.dot",
                                policy_filename = "policy.out",
                                pomdp_filename = "model.pomdpx")
polgraph(graphgen)
```
