const REQUIRED_FUNCTIONS = [n_states,
                            n_actions,
                            n_observations,                            
                            states,
                            actions,
                            observations,
                            iterator,
                            create_observation_distribution,
                            create_transition_distribution,
                            transition,
                            reward,
                            pdf,
                            discount,
                            state_index]

function required_methods()
    POMDPs.get_methods(REQUIRED_FUNCTIONS)
end
