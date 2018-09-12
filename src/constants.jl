const APPL_LOC = joinpath(dirname(pathof(SARSOP)), "..", "deps", "appl", "src")
const EXEC_POMDP_SOL = joinpath(APPL_LOC, "pomdpsol")
const EXEC_POMDP_SIM = joinpath(APPL_LOC, "pomdpsim")
const EXEC_POMDP_EVAL = joinpath(APPL_LOC, "pomdpeval")
const EXEC_POLICY_GRAPH_GENERATOR = joinpath(APPL_LOC, "polgraph")
const EXEC_POMDP_CONVERT = joinpath(APPL_LOC, "pomdpconvert")

const DEFAULT_PRECISION = 1e-3
const DEFAULT_TRIAL_IMPROVEMENT_FACTOR = 0.5
