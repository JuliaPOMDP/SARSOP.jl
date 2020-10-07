[![Build Status](https://travis-ci.org/JuliaPOMDP/SARSOP.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/SARSOP.jl)
[![Coverage Status](https://coveralls.io/repos/github/JuliaPOMDP/SARSOP.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaPOMDP/SARSOP.jl?branch=master)
[![Dev-Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaPOMDP.github.io/SARSOP.jl/dev)
[![Stable-Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaPOMDP.github.io/SARSOP.jl/stable)


# SARSOP


This Julia package wraps the [SARSOP](http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/) software for offline POMDP planning. 
It works with the [POMDPS.jl](https://github.com/JuliaPOMDP/POMDPs.jl) interface.
A module for writing POMDPX files is provided through the [POMDPXFile.jl](https://github.com/JuliaPOMDP/POMDPXFile.jl) package, and is a dependancy for SARSOP.jl. 

## Installation

You must have [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) installed. To install SARSOP and its Julia wrapper run the following command:

```julia
using POMDPs
using Pkg
POMDPs.add_registry()
Pkg.add("SARSOP")
```

## Documentation
Detailed documentation can be found [here](http://juliapomdp.github.io/SARSOP.jl/stable).


## License

SARSOP.jl uses the APPL library.

APPL is released under GNU GPL v2.0 and uses the following external libraries, which have their own licenses:

- ZMDP Which uses the Apache 2.0 license.
- tinyxml Which uses the zlib license.
