import JSON
using LinearAlgebra
using Plots
using StatsBase
gr()

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
open("Data/CombinedCountries/CleanAllDataCC.txt", "r") do f
    global data
    data = JSON.parse(f)  # parse and transform data
end

# some notes
#data :: Dict{String, Any}
#data[somekey] :: Dict{String, Any}

waves = []
for wid in keys(data)
    if data[wid]["nJudOrigs"] == 5 & data[wid]["nSubScos"] == 5
        origs = unique(data[wid]["subScoOrig"])
        labeledScos = Dict([isoDict[origin] => Float16[] for origin in origs])
        origScoPairs = collect(zip(data[wid]["subScoOrig"],data[wid]["subSco"]))
        for p in origScoPairs
            # push!( array of judge scores from country p[1], score=p[2] )
            push!(labeledScos[ isoDict[p[1]] ], p[2])
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
                subScos=data[wid]["subSco"],
                subScoOrigs=map(x->isoDict[x], data[wid]["subScoOrig"]),
                panelOrigs=Set(map(x->isoDict[x], data[wid]["subScoOrig"])) )

        push!(waves, x)
    end
end

function everyPerm(A::Array)
    print("everyPerm(Unique(A))")
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

function strictOrder(S)
    for i in 1:(length(S)-1)
        if !(S[i] < S[i+1])
            return false
        end
    end
    return true
end

ord = [:USA,:BRA,:AUS]

w = first(waves)
Iterators.product([w.panel[c] for c in ord]...)
Iterators.product(map(c -> w.panel[c], ord)...)

mapreduce(length, *, values(w.panel))

allPanelCompositions = unique( map(x->x.panelOrigs, waves))
allPerms = union(everyPerm.(collect.(allPanelCompositions))...)
# Check sum()
sum( factorial.(length.(allPanelCompositions))) == length(allPerms)
probOnAllPerms = Dict([p=>0.0 for p in allPerms])

for panelComp in allPanelCompositions
    for w in filter(x -> x.panelOrigs == panelComp, waves)
        for ord in everyPerm(collect(panelComp))
            S = Iterators.product([w.panel[c] for c in ord]...)
            v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S) / length(S)
            probOnAllPerms[ord] += v
        end
    end
end







panelType = [:AUS, :BRA, :FRA, :USA]
probOnPerm = Dict( [p=>0.0 for p in everyPerm(panelType)] )
for w in filter(x-> x.panelOrigs == Set([:AUS, :BRA, :FRA, :USA]), waves)
    for ord in everyPerm([:AUS, :BRA, :FRA, :USA])
        S = Iterators.product([w.panel[c] for c in ord]...)
        v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S)
        probOnPerm[ord] += v
    end
end



for w in waves
    for ord in everyPerm(w.panelOrigs)
        S = Iterators.product([w.panel[c] for c in ord]...)
        v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S) / length(S)


    prob = mapreduce(x-> 1
    legnth(S)

origs = map( x -> x["subScoOrig"], values(data) )
origs = map( x -> x["subScoOrig"], values(data) )
filter!( x -> !("-1" in x), origs)

setOfOrigs =  map( x -> length(unique(x)), origs)
filter(origs)
plot(countmap(setOfOrigs))

vars = collect(keys(data["1282538"]))
tups = map( x -> collect(zip()), values(data) )
filter!( x -> !("-1" in [first(y) for y in x]), pairs)

for p in pair
    if

origs = map( x -> x["subScoOrig"], values(data) )
filter!( x -> !("-1" in x), origs)
