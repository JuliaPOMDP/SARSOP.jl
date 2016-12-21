using SARSOP
using POMDPModels
using Base.Test

# Test SARSOP internals
pomdp_file = POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDPX", "Tiger.pomdpx"))
solver = SARSOPSolver()

# Test simple interface
pomdp = TigerPOMDP()
policy = solve(solver, pomdp)

simulator = SARSOPSimulator(5, 5)
simulate(simulator, pomdp_file, policy)

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, pomdp_file, policy)

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, pomdp_file, policy)

to_pomdpx(POMDPFile(Pkg.dir("SARSOP", "deps", "appl-0.96", "examples", "POMDP", "Tiger.pomdp")))

up = updater(policy)
d = initial_state_distribution(pomdp)
b = initialize_belief(up, d)
a = action(policy, b)

mdp = GridWorld()
@test_throws ErrorException create_policy(solver, mdp)
@test_throws ErrorException solve(solver, mdp, create_policy(solver, pomdp))
@test_throws ErrorException solve(solver, mdp)
