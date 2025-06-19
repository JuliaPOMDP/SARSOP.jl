using SARSOP
using POMDPs
using POMDPLinter
using POMDPModels
using POMDPTools
using MOMDPs
using QuickPOMDPs

using RockSample
using LinearAlgebra
using StaticArrays: SVector, MVector

using Test

using SARSOP: evaluate # to avoid ambiguity

include("rocksample_momdp.jl")

@testset "POMDPFile" begin
    pomdp_file = POMDPFile(joinpath(@__DIR__, "tiger.pomdpx"))
    @test isfile(pomdp_file.filename)
    tiger_file = POMDPFile(TigerPOMDP())
    @test isfile(tiger_file.filename)
end

@testset "Basic interface" begin
    solver = SARSOPSolver(precision=0.01, timeout=10.0, memory=100.0, fast=true, 
        randomization=true, trial_improvement_factor=1e-3)
    
    pomdp = TigerPOMDP()
    policy = solve(solver, pomdp)
    
    mdp = SimpleGridWorld()
    @test_throws ErrorException solve(solver, mdp)
    
    POMDPLinter.@show_requirements solve(solver, pomdp)
    sim = RolloutSimulator(max_steps=100)
    r = simulate(sim, pomdp, policy, DiscreteUpdater(pomdp))
    
    rocksample_pomdp = RockSamplePOMDP()
    rocksample_pomdp = RockSample.RockSamplePOMDP(
        map_size=(1, 3),
        rocks_positions=[(1, 1)],
        init_pos=(1, 2),
        sensor_efficiency=0.5
    )
    rocksample_momdp = RockSampleMOMDP(rocksample_pomdp)
    pomdp_policy = solve(solver, rocksample_pomdp)
    momdp_policy = solve(solver, rocksample_momdp)
end

@testset "Simulator" begin 
    simulator = SARSOPSimulator(sim_len=5, sim_num=5, fast=true, srand = 1)
    simulate(simulator)
    evaluator = SARSOPEvaluator(sim_len=5, sim_num=5, fast=true, srand = 1, memory=200.0)
    evaluate(evaluator)
end

@testset "Policy Graph" begin 
    graph_generator = PolicyGraphGenerator(graph_filename="tiger.dot",
                                           pomdp_filename="model.pomdpx",
                                           fast = true)
    generate_graph(graph_generator)
    @test isfile(graph_generator.graph_filename)
end

@testset "Load policy" begin 
    pomdp = TigerPOMDP()
    policy = solve(SARSOPSolver(verbose=false), pomdp)
    policy2 = load_policy(pomdp, "policy.out")
    @test policy.alphas == policy2.alphas
    @test_throws ErrorException load_policy(pomdp, "dum.out")
end

@testset "Issue #39" begin
    solve(SARSOPSolver(), BabyPOMDP())
end

@testset "Issue #40" begin
    include("cancer.jl")
end
