using SARSOP
using Base.Test

policy = POMDPPolicy("mypolicy.policy")
pomdp = POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDPX", "Tiger.pomdpx"))
solver = SARSOPSolver()
solve(solver, pomdp, policy)

simulator = SARSOPSimulator(5, 5)
simulate(simulator, pomdp, policy)

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, pomdp, policy)

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, pomdp, policy)

to_pomdpx(POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDP", "Tiger.pomdp")))
