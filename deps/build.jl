@windows_only error("SARSOP.jl does not support Windows at this time.")

if !isdir(Pkg.dir("POMDPXFile"))
    Pkg.clone("https://github.com/sisl/POMDPXFile.jl")
end

if ispath("appl-0.96")
    rm("appl-0.96", recursive=true)
end

download("http://bigbird.comp.nus.edu.sg/pmwiki/farm/appl/uploads/Main/appl-0.96.tar.gz", "appl-0.96.tar.gz")
run(`gunzip appl-0.96.tar.gz`)
run(`tar -xvf appl-0.96.tar`)
rm("appl-0.96.tar")

if isfile("appl-0.96.tar")
    rm("appl-0.96.tar")
end


cd("appl-0.96/src")

function replaceLine(filename::String, linenum::Int, textofline::String)
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
    mv("temp.txt", filename)
end

@osx_only begin
    cd("MathLib")
    replaceLine("SparseMatrix.h", 24, "            inline SparseCol() {}\n")
    replaceLine("SparseVector.cpp", 491, "        //printf(\"Iter: %X\\n\", iter);\n")
    cd("../")
end
run(`make`)
