[![Build Status](https://travis-ci.org/JuliaPOMDP/SARSOP.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/SARSOP.jl)
[![Coverage Status](https://coveralls.io/repos/JuliaPOMDP/SARSOP.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaPOMDP/SARSOP.jl?branch=master)

# SARSOP


This Julia package wraps the [SARSOP](http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/) software for offline POMDP planning. 
It works with the [POMDPS.jl](https://github.com/sisl/POMDPs.jl) interface.
A module for writing POMDPX files is provided through the [POMDPXFile.jl](https://github.com/sisl/POMDPXFile.jl) package, and is a dependancy for SARSOP.jl. 

At the moment, only linux and OSX are supported.

## Installation
To install the wraper and SARSOP run the following command:

```julia
Pkg.clone("https://github.com/sisl/SARSOP.jl")
```

If you do not have the APPL toolkit installed (this is the SARSOP backened), then run:

```julia
Pkg.build("SARSOP")
```

This will download the SARSOP.jl wrapper, and build the SARSOP backend software. If you are having problems with the
software try building SARSOP from source on your own. 

If you did not run the build command, you will also need to donwload the POMDPXFile.jl module. This module handles writing and reading the .pomdpx files required to interface with the SARSOP back-end solver. To do that, simply run the following command:

```julia
Pkg.clone("https://github.com/sisl/POMDPXFile.jl")
```

## Usage
### POMDPs
The following functions must be defined in order to use the SARSOP solver:

```julia
discount(pomdp::POMDP) # returns the discount factor
n_states(pomdp::POMDP) # returns the size of the state space
n_actions(pomdp::POMDP) # returns the size of the action space
n_observations(pomdp::POMDP) # returns the size of the observation space
states(pomdp::POMDP) # returns the problem state space
iterator(state_space::AbstractSpace) # returns an iterator over the state space
actions(pomdp::POMDP) # returns the problem action space
iterator(action_space::AbstractSpace) # returns an iterator over the action space
observations(pomdp::POMDP) # returns the problem observation space
domain(observation_space::AbstractSpace) # returns an iterator over the observation space
transition(pomdp::POMDP, s::State, a::Action, d::AbstractDistribution) # distribution of states from the (s,a) pair
pdf(d::AbstractDistribution, s::State) # the probability of state s in distribution d
observation(pomdp::POMDP, s::State, a::Action, d::AbstractDistribution) # distribution over observation from the (s,a) pair
create_transition_distribution(pomdp::POMDP) # returns an initial instance of the transition distribution
create_observation_distribution(pomdp::POMDP) # returns an initial instance of the observation distribution
```
```julia
using SARSOP
# run Pkg.clone("https://github.com/sisl/POMDPModels.jl.git") and Pkg.build("POMDPModels") to get this module
using POMDPModels # this contains the TigerPOMDP

# If the policy file already exists, it will be loaded by default
policy = POMDPPolicy("tiger.policy")

# If the .pomdpx file exists call: pomdpfile = POMDPFile("\path\to\file") 
pomdp = TigerPOMDP() # this comes from POMDPModels, you will want this to be your concrete POMDP type
pomdpfile = POMDPFile(pomdp, "tiger.pomdpx") # second arg is the file to which .pomdpx will be writeten

solver = SARSOPSolver()
solve(solver, pomdpfile, policy) # no need to use solve if "mypolicy.policy" already exists

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

### MODMPs
To use with mixed observability Markov decision processes (MOMDPs) make sure to clone [MOMDPs.jl](https://github.com/sisl/MOMDPs.jl). The syntax takes the following form:

```julia
using SARSOP

# If the policy file already exists, it will be loaded by default
policy = MOMDPPolicy("mypolicy.policy")

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
