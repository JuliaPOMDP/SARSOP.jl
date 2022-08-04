[![Build Status](https://github.com/JuliaPOMDP/SARSOP.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaPOMDP/SARSOP.jl/actions/workflows/CI.yml/)
[![Dev-Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaPOMDP.github.io/SARSOP.jl/dev)
[![Stable-Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaPOMDP.github.io/SARSOP.jl/stable)

<!-- [![Coverage Status](https://coveralls.io/repos/github/JuliaPOMDP/SARSOP.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaPOMDP/SARSOP.jl?branch=master) -->

# SARSOP


This Julia package wraps the [SARSOP](http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/) software for offline POMDP planning. 
It works with the [POMDPS.jl](https://github.com/JuliaPOMDP/POMDPs.jl) interface.
A module for writing POMDPX files is provided through the [POMDPXFile.jl](https://github.com/JuliaPOMDP/POMDPXFile.jl) package, and is a dependency for SARSOP.jl. 

## Installation

It is recommended that you have [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) installed. To install SARSOP and its Julia wrapper run the following command:

```julia
] add SARSOP
```

## Example Usage
```julia
using POMDPs
using SARSOP
using POMDPModels

pomdp = TigerPOMDP()
solver = SARSOPSolver()
policy = solve(solver, pomdp)
```

## Documentation
Detailed documentation can be found [here](http://juliapomdp.github.io/SARSOP.jl/stable).

## SARSOP_jll
The supporting [``SARSOP_jll``](https://github.com/JuliaBinaryWrappers/SARSOP_jll.jl) package was created using [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl). The [`build_tarballs.jl`](https://github.com/JuliaPackaging/Yggdrasil/blob/a1b3930059b5ef818154fc7553c220829ff31066/S/SARSOP/build_tarballs.jl) script can be found on [`Yggdrasil`](https://github.com/JuliaPackaging/Yggdrasil/), the community build tree. To update and build new binaries:
 - Modify the JuliaPOMDP fork of [SARSOP](https://github.com/JuliaPOMDP/sarsop) (https://github.com/JuliaPOMDP/sarsop)
  - Fork and update the Yggdrasil ``SARSOP_jll`` [`build_tarballs.jl`](https://github.com/JuliaPackaging/Yggdrasil/blob/a1b3930059b5ef818154fc7553c220829ff31066/S/SARSOP/build_tarballs.jl) script 
  - Create a pull request on [JuliaPackaging/Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)
  - Update this README with the correct links


## License

SARSOP.jl uses the APPL library.

APPL is released under GNU GPL v2.0 and uses the following external libraries, which have their own licenses:

- ZMDP Which uses the Apache 2.0 license.
- tinyxml Which uses the zlib license.
