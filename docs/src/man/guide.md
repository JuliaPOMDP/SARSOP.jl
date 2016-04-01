# Package Guide 

## Installation

The package can be installed by either cloning the code and running build or by using the `add` function from
[POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl)

Installation with POMDPs.jl:
```julia
using POMDPs
POMDPs.add("SARSOP")
```

## Usage

SARSOP.jl makes it easy to interface with the APPL SARSOP solver. Once you have a model defined according to POMDPs.jl,
you can generate policies by running the following:

```julia
using SARSOP
using POMDPModels # this contains the TigerPOMDP model

# If the policy file already exists, it will be loaded by default
policy = POMDPPolicy("tiger.policy")

# If the .pomdpx file exists call: pomdpfile = POMDPFile("\path\to\file") 
pomdp = TigerPOMDP() # this comes from POMDPModels, you will want this to be your concrete POMDP type
pomdpfile = POMDPFile(pomdp, "tiger.pomdpx") # second arg is the file to which .pomdpx will be writeten

solver = SARSOPSolver()
solve(solver, pomdpfile, policy) # no need to use solve if "mypolicy.policy" already exists
```

We can simulate, evalaute and create policy graphs:

```julia
# Policy can be used to map belief to actions
ns = n_states(pomdp) # implemented by user
b = initial_belief(pomdp) # implemented by user
a = action(policy, b) 

# simulate the SARSOP policy
simulator = SARSOPSimulator(5, 5)
simulate(simulator, policy, pomdpfile)

# evaluate the SARSOP policy
evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, policy, pomdpfile)

# generates a policy graph
graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, policy, pomdp)
```
