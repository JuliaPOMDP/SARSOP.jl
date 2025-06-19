# Here for testing until RockSample.jl is updated
mutable struct RockSampleMOMDP{K} <: MOMDP{RSPos,SVector{K,Bool},Int,Int}
    map_size::Tuple{Int,Int}
    rocks_positions::SVector{K,RSPos}
    init_pos::RSPos
    sensor_efficiency::Float64
    bad_rock_penalty::Float64
    good_rock_reward::Float64
    step_penalty::Float64
    sensor_use_penalty::Float64
    exit_reward::Float64
    terminal_state::RSPos
    discount_factor::Float64
end

"""
    RockSampleMOMDP(rocksample_pomdp::RockSamplePOMDP)

Create a RockSampleMOMDP using the same parameters in a RockSamplePOMDP.
"""
function RockSampleMOMDP(rocksample_pomdp::RockSamplePOMDP)
    return RockSampleMOMDP(
        rocksample_pomdp.map_size,
        rocksample_pomdp.rocks_positions,
        rocksample_pomdp.init_pos,
        rocksample_pomdp.sensor_efficiency,
        rocksample_pomdp.bad_rock_penalty,
        rocksample_pomdp.good_rock_reward,
        rocksample_pomdp.step_penalty,
        rocksample_pomdp.sensor_use_penalty,
        rocksample_pomdp.exit_reward,
        rocksample_pomdp.terminal_state.pos,
        rocksample_pomdp.discount_factor
    )
end

MOMDPs.is_y_prime_dependent_on_x_prime(::RockSampleMOMDP) = false
MOMDPs.is_x_prime_dependent_on_y(::RockSampleMOMDP) = false
MOMDPs.is_initial_distribution_independent(::RockSampleMOMDP) = true

function MOMDPs.states_x(problem::RockSampleMOMDP)
    map_states = vec([SVector{2,Int}((i, j)) for i in 1:problem.map_size[1], j in 1:problem.map_size[2]])
    # Add terminal state
    push!(map_states, problem.terminal_state)
    return map_states
end

# Hidden states: All possible K-length vector of booleans, where K is the number of rocks
function MOMDPs.states_y(problem::RockSampleMOMDP{K}) where {K}
    bool_options = [[true, false] for _ in 1:K]
    vec_bool_options = vec(collect(Iterators.product(bool_options...)))
    s_vec_bool_options = [SVector{K,Bool}(bool_vec) for bool_vec in vec_bool_options]
    return s_vec_bool_options
end

function MOMDPs.stateindex_x(problem::RockSampleMOMDP, s::Tuple{RSPos, SVector{K,Bool}}) where {K}
    return stateindex_x(problem, s[1])
end
function MOMDPs.stateindex_x(problem::RockSampleMOMDP, x::RSPos)
    if isterminal(problem, (x, first(states_y(problem))))
        return length(states_x(problem))
    end
    return LinearIndices(problem.map_size)[x[1], x[2]]
end

function MOMDPs.stateindex_y(problem::RockSampleMOMDP, s::Tuple{RSPos, SVector{K,Bool}}) where {K}
    return stateindex_y(problem, s[2])
end
function MOMDPs.stateindex_y(problem::RockSampleMOMDP, y::SVector{K,Bool}) where {K}
    return findfirst(==(y), states_y(problem))
end


function MOMDPs.initialstate_x(problem::RockSampleMOMDP)
    return Deterministic(problem.init_pos)
end

function MOMDPs.initialstate_y(::RockSampleMOMDP{K}, x::RSPos) where K
    probs = normalize!(ones(2^K), 1)
    states = Vector{SVector{K,Bool}}(undef, 2^K)
    for (i,rocks) in enumerate(Iterators.product(ntuple(x->[false, true], K)...))
        states[i] = SVector(rocks)
    end
    return SparseCat(states, probs)
end

function MOMDPs.transition_x(problem::RockSampleMOMDP, s::Tuple{RSPos,SVector{K,Bool}}, a::Int) where {K}
    x = s[1]
    if isterminal(problem, s)
        return Deterministic(problem.terminal_state)
    end
    new_pos = next_position(x, a)
    if new_pos[1] > problem.map_size[1]
        new_pos = problem.terminal_state
    else
        new_pos = RSPos(clamp(new_pos[1], 1, problem.map_size[1]),
            clamp(new_pos[2], 1, problem.map_size[2]))
    end
    return Deterministic(new_pos)
end

function MOMDPs.transition_y(problem::RockSampleMOMDP, s::Tuple{RSPos,SVector{K,Bool}}, a::Int, x_prime::RSPos) where {K}
    if isterminal(problem, s)
        return Deterministic(s[2])
    end

    if a == RockSample.BASIC_ACTIONS_DICT[:sample] && in(s[1], problem.rocks_positions)
        rock_ind = findfirst(isequal(s[1]), problem.rocks_positions)
        new_rocks = MVector{K,Bool}(undef)
        for r = 1:K
            new_rocks[r] = r == rock_ind ? false : s[2][r]
        end
        new_rocks = SVector(new_rocks)
        
    else # We didn't sample, so states of rocks remain unchanged
        new_rocks = s[2]
    end
    
    return Deterministic(new_rocks)
end

function next_position(s::RSPos, a::Int)
    if a > RockSample.N_BASIC_ACTIONS || a == 1
        # robot check rocks or samples
        return s
    elseif a <= RockSample.N_BASIC_ACTIONS
        # the robot moves 
        return s + RockSample.ACTION_DIRS[a]
    end
end

POMDPs.discount(problem::RockSampleMOMDP) = problem.discount_factor

function POMDPs.isterminal(problem::RockSampleMOMDP, s::Tuple{RSPos,SVector{K,Bool}}) where {K}
    return s[1] == problem.terminal_state
end

POMDPs.actions(::RockSampleMOMDP{K}) where {K} = 1:RockSample.N_BASIC_ACTIONS+K
POMDPs.actionindex(::RockSampleMOMDP, a::Int) = a

function POMDPs.actions(pomdp::RockSampleMOMDP{K}, s::Tuple{RSPos,SVector{K,Bool}}) where {K}
    x = s[1]
    if in(x, pomdp.rocks_positions)
        return actions(pomdp)
    else
        # sample not available
        return 2:RockSample.N_BASIC_ACTIONS+K
    end
end

POMDPs.observations(::RockSampleMOMDP) = 1:3
POMDPs.obsindex(::RockSampleMOMDP, o::Int) = o

function POMDPs.observation(problem::RockSampleMOMDP, a::Int, s::Tuple{RSPos,SVector{K,Bool}}) where {K}
    if a <= RockSample.N_BASIC_ACTIONS
        # no obs
        return SparseCat((1, 2, 3), (0.0, 0.0, 1.0))
    else
        rock_ind = a - RockSample.N_BASIC_ACTIONS
        rock_pos = problem.rocks_positions[rock_ind]
        dist = norm(rock_pos - s[1])
        efficiency = 0.5 * (1.0 + exp(-dist * log(2) / problem.sensor_efficiency))
        rock_state = s[2][rock_ind]
        if rock_state
            return SparseCat((1, 2, 3), (efficiency, 1.0 - efficiency, 0.0))
        else
            return SparseCat((1, 2, 3), (1.0 - efficiency, efficiency, 0.0))
        end
    end
end

function POMDPs.reward(problem::RockSampleMOMDP, s::Tuple{RSPos,SVector{K,Bool}}, a::Int) where {K}
    r = problem.step_penalty
    if next_position(s[1], a)[1] > problem.map_size[1]
        r += problem.exit_reward
        return r
    end

    if a == RockSample.BASIC_ACTIONS_DICT[:sample] && in(s[1], problem.rocks_positions) # sample 
        rock_ind = findfirst(isequal(s[1]), problem.rocks_positions) # slow ?
        r += s[2][rock_ind] ? problem.good_rock_reward : problem.bad_rock_penalty
    elseif a > RockSample.N_BASIC_ACTIONS # using senssor
        r += problem.sensor_use_penalty
    end
    return r
end
