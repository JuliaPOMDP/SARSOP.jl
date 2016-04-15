if !isdir(Pkg.dir("POMDPXFiles"))
    Pkg.clone("https://github.com/JuliaPOMDP/POMDPXFiles.jl")
end

if ispath("appl-0.96")
    rm("appl-0.96", recursive=true)
end

@windows_only begin
    if ispath("appl-0.96win")
        rm("appl-0.96win", recursive=true)
    end
    download("http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/uploads/Main/appl-0.96win.zip", "appl-0.96win.zip")
    run(`unzip appl-0.96win.zip`)
    mv("appl-0.96win", "appl-0.96")
    cd("appl-0.96/src")
    download("http://web.stanford.edu/group/sisl/resources/appl-0.96-win-x64.zip", "appl-0.96-win-x64.zip")
    run(`unzip appl-0.96-win-x64.zip`)
end

@unix_only begin
    download("http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/uploads/Main/appl-0.96.tar.gz", "appl-0.96.tar.gz")
    run(`gunzip appl-0.96.tar.gz`)
    run(`tar -xvf appl-0.96.tar`)
    rm("appl-0.96.tar")
    if isfile("appl-0.96.tar")
        rm("appl-0.96.tar")
    end
    cd("appl-0.96/src")

    function replaceLine(filename::AbstractString, linenum::Int, textofline::AbstractString)
        outfile = open("temp.txt", "w")
        infile = open(filename)
        i = 1
        for line in eachline(infile)
            if i == linenum
                write(outfile, textofline)
                i += 1
            else
                write(outfile, line)
                i += 1
            end
        end
        close(outfile)
        close(infile)
        rm(filename)
        mv("temp.txt", filename)
    end

    @osx_only begin
        cd("MathLib")
        replaceLine("SparseMatrix.h", 24, "            inline SparseCol() {}\n")
        replaceLine("SparseVector.cpp", 491, "        //printf(\"Iter: %X\\n\", iter);\n")
        cd("../")
    end
    run(`make`)
end
