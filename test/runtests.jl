using SARSOP
using POMDPs
using POMDPModels
using BeliefUpdaters
using Test

# Test SARSOP internals
pomdp_file = POMDPFile(joinpath(dirname(pathof(SARSOP)),"..", "deps", "appl", "examples", "POMDPX", "Tiger.pomdpx"))
solver = SARSOPSolver()

# Test simple interface
pomdp = TigerPOMDP()
policy = solve(solver, pomdp)

simulator = SARSOPSimulator(5, 5)
simulate(simulator, pomdp_file, "policy.out")

evaluator = SARSOPEvaluator(5, 5)
evaluate(evaluator, pomdp_file, "policy.out")

graphgen = PolicyGraphGenerator("Tiger.dot")
polgraph(graphgen, pomdp_file, "policy.out")

to_pomdpx(POMDPFile(joinpath(dirname(pathof(SARSOP)), "..", "deps", "appl", "examples", "POMDP", "Tiger.pomdp")))

up = DiscreteUpdater(pomdp)
d = initialstate_distribution(pomdp)
b = initialize_belief(up, d)
a = action(policy, b)

mdp = GridWorld()
# @test_throws ErrorException create_policy(solver, mdp)
# @test_throws ErrorException solve(solver, mdp, create_policy(solver, pomdp))
@test_throws ErrorException solve(solver, mdp)
