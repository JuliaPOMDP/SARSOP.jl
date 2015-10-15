# SARSOP

This Julia package wraps the [SARSOP](http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/) software for offline POMDP planning.

At the moment, only linux and OSX are supported.

## Installation
```julia
Pkg.clone("https://github.com/sisl/SARSOP.jl")
```

## Usage
### POMDPs
```julia
using SARSOP

# If the policy file already exists, it will be loaded by default
policy = PolicyFile("mypolicy.policy")

# If the .pomdpx file exists call: pomdpfile = POMDPFile("\path\to\file") 
pomdp = MyPOMDP() # initialize your pomdp model
pomdpfile = POMDPFile(pomdp, "\path\to\write\to") # second arg is the file to which .pomdpx will be writeten

solver = SARSOPSolver()
solve(solver, pomdpfile, policy) # no need to use solve if "mypolicy.policy" already exists

# Policy can be used to map belief to actions
ns = n_states(pomdp) # implemented by user
b = initial_belief(pomdp) # implemented by user
a = action(policy, b) 

simulator = SARSOPSimulator(5, 5)
simulate(simulator, policy, pomdp)

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, policy, pomdp)

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, policy, pomdp)

to_pomdpx(POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDP", "Tiger.pomdp")))
```

### MODMPs
To use with mixed observability Markov decision processes (MOMDPs) make sure to clone [MOMDPs.jl](https://github.com/sisl/MOMDPs.jl). The syntax takes the following form:

```julia
using SARSOP

# If the policy file already exists, it will be loaded by default
policy = PolicyFile("mypolicy.policy")

momdp = MyMOMDP() # initialize your pomdp model
pomdpfile = MOMDPFile(momdp, "\path\to\write\to") # second arg is the file to which .pomdpx will be writeten

solver = SARSOPSolver()
solve(solver, pomdpfile, policy) # no need to use solve if "mypolicy.policy" already exists

# Policy can be used to map belief to actions
ns = n_states(momdp) # implemented by user
b = initial_belief(momdp) # implemented by user
x = fully_obs_var(momdp, create_state(momdp)) # returns the fully observable varaible (implemented by user)
a = action(policy, b, x) 
```
