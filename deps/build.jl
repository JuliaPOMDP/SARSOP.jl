using POMDPs

POMDPs.add("POMDPXFiles")
POMDPs.add("POMDPToolbox")
POMDPs.add("POMDPModels")


if ispath("appl-0.96")
    rm("appl-0.96", recursive=true)
end

if is_windows()
    if ispath("appl-0.96win")
        rm("appl-0.96win", recursive=true)
    end
    download("https://github.com/personalrobotics/appl/archive/0.96.zip", "appl-0.96win.zip")
    run(`unzip appl-0.96win.zip`)
    cd("appl-0.96/src")
    download("http://web.stanford.edu/group/sisl/resources/appl-0.96-win-x64.zip", "appl-0.96-win-x64.zip")
    run(`unzip appl-0.96-win-x64.zip`)
    cd(Pkg.dir("SARSOP", "deps"))
    run(`cmd /c move appl-0.96 appl`)
end

if is_unix()
    if ispath("appl")
        rm("appl", recursive=true)
    end
    # note: v0.96 of appl does not seem to compile properly on some OSX versions
    run(`git clone https://github.com/personalrobotics/appl/`)
    cd("appl")
    run(`git reset --hard e433ee63e542551a7c6d35ec2d71192fd5a06d62`)
    cd("src")
    run(`make`)
end
