using Pkg
Pkg.add("CSV")
using CSV

println("Communities Purity test")

vertices = CSV.read("data/vertices stanfordberkeley.csv", datarow = 1, delim=';')
vertices_type = Dict()
nrows, ncols = size(vertices)
for row in 1:nrows

    type = "S";
    if(occursin(".B.",vertices[row,2]))
        type = "B"
    end
    vertices_type[vertices[row,1]]  = type
end

vertices_type

communities = CSV.read("data/communities stanfordberkeley.csv", datarow = 2, delim=';')

result = Dict()
SVertice = 0
BVertice = 0
nrows, ncols = size(communities)
for row in 1:nrows
    for col in 1:ncols
        if(!ismissing(communities[row,col]) && haskey(vertices_type,string(communities[row,col])) )
            print(vertices_type[string(communities[row,col])], ", ")
            if(vertices_type[string(communities[row,col])] == "B")
                BVertice++
            else
                SVertice++
            end
        end
    end
    if(SVertice > BVertice)
        result[communities[row,0]] = SVertice / (SVertice + BVertice)
    else
        result[communities[row,0]] = BVertice / (SVertice + BVertice)
    end
    SVertice = 0
    BVertice = 0
end
