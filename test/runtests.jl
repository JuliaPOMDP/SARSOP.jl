using SARSOP
using POMDPModels
using Base.Test

# Test SARSOP internals
pomdp = POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDPX", "Tiger.pomdpx"))
solver = SARSOPSolver()
policy1 = solve(solver, pomdp)

simulator = SARSOPSimulator(5, 5)
simulate(simulator, pomdp, policy1)

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, pomdp, policy1)

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, pomdp, policy1)

to_pomdpx(POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDP", "Tiger.pomdp")))

# Test simple interface
pomdp = TigerPOMDP()
policy2 = solve(solver, pomdp)

@test policy1.alphas.alpha_vectors == policy2.alphas.alpha_vectors
println("SARSOP tests passed")
