using JSON
using LinearAlgebra
using Plots
using StatsBase
gr()


#### Note the following
function (P::Dict)(D0::Dict)
    map!(x->P[x], values(D0))
    println(keys(D0))
    println(values(D0))
end

id = Dict( [1=>1, 2=>2, 3=>3, 4=>4, 5=>5] )
E = Dict( [1=>3, 2=>4, 3=>5, 4=>2, 5=>1] )
# then run this 6 times
E(id)


(d::Dict)() = d( Dict([i=>i for i in 1:5]) )

d = Dict([1=>2,2=>3,3=>4,4=>5,5=>1])
Dict{Int64,Int64} with 2 entries:
  2 => 1
  1 => 2

julia> d([2,1])
2-element Array{Int64,1}:
 1
 2

julia> d()
2-element Array{Int64,1}:
 2
 1


# I love this helper: https://github.com/JuliaLang/julia/issues/24741
function subtypetree(t, level=1, indent=4)
    level == 1 && println(t)
    for s in subtypes(t)
        println(join(fill(" ", level * indent)) * string(s))
        subtypetree(s, level+1, indent)
    end
end


# CC countries
isoDict = Dict([  "Australia" => :AUS,
                "Basque Country" => :ESP,
                "Brazil" => :BRA,
                "Fiji" => :FJI,
                "France" => :FRA,
                "Hawaii" => :USA,
                "Indonesia" => :IDN,
                "Italy" => :ITA,
                "Japan" => :JPN,
                "New Zealand" => :NZL,
                "Portugal" => :PRT,
                "South Africa" => :ZAF,
                "Spain" => :ESP,
                "United States" => :USA ])

data = Dict()
# File Path for Data
open("Data/CombinedCountries/CleanAllDataCC.txt", "r") do f
    global data
    data = JSON.parse(f)  # parse and transform data
end

waves = []
for wid in keys(data)
    if data[wid]["nJudOrigs"] == 5 & data[wid]["nSubScos"] == 5
        origs = unique(data[wid]["subScoOrig"])
        matchIndicator = (data[wid]["athOrig"] in origs)
        labeledScos = Dict([isoDict[origin] => Float16[] for origin in origs])
        origScoPairs = collect(zip(data[wid]["subScoOrig"],data[wid]["subSco"]))

        labeledScosBinary = Dict([:Match => Float16[], :NoMatch => Float16[] ])

        for p in origScoPairs
            # push!( array of judge scores from country p[1], score=p[2] )
            push!(labeledScos[ isoDict[p[1]] ], p[2])
            if p[1] == data[wid]["athOrig"]
                push!(labeledScosBinary[:Match], p[2])
            else
                push!(labeledScosBinary[:NoMatch], p[2])
            end
        end

        x = (   id=wid,
                evtYear=data[wid]["evtYear"],
                evtOrig=isoDict[data[wid]["evtOrig"]],
                evtName=data[wid]["evtName"],
                evtId=data[wid]["evtId"],
                rnd=data[wid]["rnd"],
                rndId=data[wid]["rndId"],
                heat=data[wid]["heat"],
                heatId=data[wid]["heatId"],
                athName=data[wid]["athName"],
                athId=data[wid]["athId"],
                athOrig=isoDict[data[wid]["athOrig"]],
                currentPoints=data[wid]["currentPoints"],
                endingPoints=data[wid]["endingPoints"],
                panel=labeledScos,
                panelBinary=labeledScosBinary,
                subScos=data[wid]["subSco"],
                subScoOrigs=map(x->isoDict[x], data[wid]["subScoOrig"]),
                panelOrigs=Set(map(x->isoDict[x], data[wid]["subScoOrig"])),
                match=matchIndicator )

        push!(waves, x)
    end
end

function permGroup(A::Union{Set,Array})
    unique!(A)
    P = Array{eltype(A),1}[]
    function continuePerm(head,tail)
        if length(tail) > 0
            for t in tail
                newHead = union(head, [t])
                newTail = setdiff(tail, [t])
                continuePerm(newHead, newTail)                end
        else
            push!(P, head)
        end
    end
    continuePerm(eltype(A)[], A)
    return P
end

sort(collect(values(isoDict)))

function permInv(A::Union{Set,Array})

# want to implement with arbitrary symbol
function strictOrder(S)
    for i in 1:(length(S)-1)
        if !(S[i] < S[i+1])
            return false
        end
    end
    return true
end

#=
ord = [:USA,:BRA,:AUS]
w = first(waves)
S = Iterators.product([w.panel[c] for c in ord]...)
=#

allPanelCompositions = unique( map(x->x.panelOrigs, waves))
allPerms = union(permGroup.(collect.(allPanelCompositions))...)
# Check sum()
sum( factorial.(length.(allPanelCompositions))) == length(allPerms)
probOnAllPerms = Dict([p=>0.0 for p in allPerms])

for panelComp in allPanelCompositions
    for w in filter(x -> x.panelOrigs == panelComp, waves)
        for ord in permGroup(collect(panelComp))
            S = Iterators.product([w.panel[c] for c in ord]...)
            v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S) / length(S)
            probOnAllPerms[ord] += v
        end
    end
end

function getPairs(A::Array)
    unique!(A)
    p = Array[]
    for i in 1:length(A)
        for j in (i+1):length(A)
            push!(p, [A[i],A[j]])
        end
    end
    return p
end
function getPairs(A::Set)
    A = sort(collect(A))
    p = Array[]
    for i in 1:length(A)
        for j in (i+1):length(A)
            push!(p, [A[i],A[j]])
        end
    end
    return p
end


probOnAllPairs = Dict([p=>0.0 for p in getPairs( sort(collect(values(isoDict))) )])
for w in waves
    for p in getPairs( w.panelOrigs )
        S = Iterators.product([ w.panel[ p[1] ], w.panel[ p[2] ] ])
        v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S) / length(S)
        probOnAllPairs[p] += v
    end
end

for Country in values(isoDict)
    probOnAllPermsBinary = Dict([p=>0.0 for p in everyPerm([:Match,:NoMatch])])
    for w in filter(x -> x.match & (x.athOrig == Country), waves)
        for ord in everyPerm([:Match,:NoMatch])
            S = Iterators.product([w.panelBinary[c] for c in ord]...)
            v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S) / length(S)
            #v /= min(length(w.panelBinary[:Match]), length(w.panelBinary[:NoMatch]))
            probOnAllPermsBinary[ord] += v
        end
    end
    println(Country)
    println("->", probOnAllPermsBiånary)
end
