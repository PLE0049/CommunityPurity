using Pkg
Pkg.add("CSV")
using CSV

begin
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

    communities = CSV.read("data/communities stanfordberkeley.csv", datarow = 1, delim=';')

    result = Dict()
    let SVertice, BVertice
        SVertice = 0
        BVertice = 0
        nrows, ncols = size(communities)
        for row in 1:nrows
            for col in 1:ncols
                if(!ismissing(communities[row,col]) && haskey(vertices_type,string(communities[row,col])) )
                    print(vertices_type[string(communities[row,col])], ", ")
                    if (vertices_type[string(communities[row,col])] == "S")
                        SVertice = SVertice + 1
                    else
                        BVertice = BVertice + 1
                    end
                end
            end
            if(SVertice > BVertice)
                result[row] = [SVertice ,BVertice , SVertice / (SVertice + BVertice)]
            else
                result[row] = [BVertice ,SVertice ,BVertice / (SVertice + BVertice)]
            end
            SVertice = 0
            BVertice = 0
        end
    end

    open("communities_purity.csv", "w") do file
        write(file,"ID,STANFORD,BERKELEY,PURITY,\n")
        for k in keys(result)
            write(file,,string(k)*","*string(Int32(result[k][1]))*","*string(Int32(result[k][2]))*","*string(result[k][3])*","*"\n")
        end
    end
end
