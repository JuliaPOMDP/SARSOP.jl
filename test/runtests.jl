using SARSOP
using Base.Test

policy = POMDPPolicy("mypolicy.policy")
pomdpfile = POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDPX", "Tiger.pomdpx"))
solver = SARSOPSolver()
solve(solver, pomdpfile, policy)

simulator = SARSOPSimulator(5, 5)
simulate(simulator, policy, pomdp)

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, policy, pomdp)

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, policy, pomdp)

to_pomdpx(POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDP", "Tiger.pomdp")))
