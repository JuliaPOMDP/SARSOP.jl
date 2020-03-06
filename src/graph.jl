"""
    PolicyGraphGenerator

* `fast = false` use fast (but very picky) alternate parser for .pomdp files
* `graph_max_depth` maximum horizon of the generated policy graph. There is no limit by default.
* `graph_max_branch` maximum number of branches of the generated policy graph. Shown will be top in probability. There is no limit by default.
* `graph_min_prob` minimum probability threshold for a branch to be shown in the policy graph defaults to zero
* `graph_filename` output name for the DOT file to be generated
* `pomdp_filename` pomdp file input 
* `policy_filename` policy file input
"""
@with_kw struct PolicyGraphGenerator 
    fast::Bool = false 
    graph_max_depth::Union{Int,Nothing}=nothing 
    graph_max_branch::Union{Int,Nothing}=nothing 
    graph_min_prob::Union{Float64,Nothing}=nothing 
    graph_filename::AbstractString = "policy_graph.dot" 
    pomdp_filename::AbstractString = "model.pomdpx"
    policy_filename::AbstractString = "policy.out"
end

function get_graph_generator_options(graphgen::PolicyGraphGenerator)
    options = AbstractString[]
    push!(options, "--policy-graph")
    push!(options, string(graphgen.graph_filename))
    if graphgen.fast 
        push!(options, "--fast")
    end
    if graphgen.graph_max_depth != nothing
        push!(options, "--graph-max-depth")
        push!(options, string(graphgen.graph_max_depth))
    end
    if graphgen.graph_max_branch != nothing 
        push!(options, "graph-max-branch")
        push!(options, string(graphgen.graph_max_branch))
    end
    if graphgen.graph_min_prob != nothing 
        push!(options, "graph-min-prob")
        push!(options, string(graphgen.graph_min_prob))
    end
    return options 
end

"""
    generate_graph(graphgen::PolicyGraphGenerator)
    
Generate a policy graph, see PolicyGraphGenerator to see the available options.
"""
function generate_graph(graphgen::PolicyGraphGenerator)
    options_list = get_graph_generator_options(graphgen)
    polgraph() do polgraph_path 
        run(`$polgraph_path $(graphgen.pomdp_filename) --policy-file $(graphgen.policy_filename) $options_list`)
    end
end
