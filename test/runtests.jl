using SARSOP
using POMDPs
using POMDPModels
using BeliefUpdaters
using POMDPSimulators
using Test

@testset "POMDPFile" begin
    pomdp_file = POMDPFile(joinpath(dirname(pathof(SARSOP)),"..", "deps", "appl", "examples", "POMDPX", "Tiger.pomdpx"))
    @test isfile(pomdp_file.filename)
    tiger_file = POMDPFile(TigerPOMDP())
    @test isfile(tiger_file.filename)
end

@testset "Basic interface" begin
    solver = SARSOPSolver()
    pomdp = TigerPOMDP()
    policy = solve(solver, pomdp)
    mdp = SimpleGridWorld()
    @test_throws ErrorException solve(solver, mdp)
    @requirements_info solver pomdp
    sim = RolloutSimulator(max_steps=100)
    r = simulate(sim, pomdp, policy, DiscreteUpdater(pomdp))
    @test r > 0.
end

@testset "Simulator" begin 
    simulator = SARSOPSimulator(sim_len=5, sim_num=5)
    simulate(simulator)
    evaluator = SARSOPEvaluator(sim_len=5, sim_num=5)
    evaluate(evaluator)
end

@testset "Policy Graph" begin 
    graph_generator = PolicyGraphGenerator(graph_filename="tiger.dot", pomdp_filename="model.pomdpx")
    generate_graph(graph_generator)
    @test isfile(graph_generator.graph_filename)
end

@testset "Load policy" begin 
    pomdp = TigerPOMDP()
    policy = solve(SARSOPSolver(verbose=false), pomdp)
    policy2 = load_policy(pomdp, "policy.out")
    @test policy.alphas == policy2.alphas
end
