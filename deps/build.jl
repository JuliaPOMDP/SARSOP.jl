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
run(`make`)