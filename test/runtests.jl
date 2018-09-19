using SARSOP
using POMDPs
using POMDPModels
using Test

# Test SARSOP internals
pomdp_file = POMDPFile(joinpath(dirname(pathof(SARSOP)),"..", "deps", "appl", "examples", "POMDPX", "Tiger.pomdpx"))
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

to_pomdpx(POMDPFile(joinpath(dirname(pathof(SARSOP)), "..", "deps", "appl", "examples", "POMDP", "Tiger.pomdp")))

up = updater(policy)
d = initialstate_distribution(pomdp)
b = initialize_belief(up, d)
a = action(policy, b)

mdp = GridWorld()
@test_throws ErrorException create_policy(solver, mdp)
@test_throws ErrorException solve(solver, mdp, create_policy(solver, pomdp))
@test_throws ErrorException solve(solver, mdp)
