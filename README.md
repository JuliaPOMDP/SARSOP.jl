# SARSOP

This Julia package wraps the [SARSOP](http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/) software for offline POMDP planning.

At the moment, only linux is supported.

## Installation
```julia
Pkg.clone("https://github.com/sisl/SARSOP.jl")
```

## Usage
```julia
using SARSOP

policy = PolicyFile("mypolicy.policy")
pomdp = POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDPX", "Tiger.pomdpx"))
solver = SARSOPSolver(fast=true)
solve!(policy, solver, pomdp)

simulator = SARSOPSimulator(5, 5)
simulate(simulator, policy, pomdp)

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, policy, pomdp)

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, policy, pomdp)

to_pomdpx(POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDP", "Tiger.pomdp")))
```
