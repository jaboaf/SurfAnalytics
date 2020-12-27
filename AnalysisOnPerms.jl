using JSON
using LinearAlgebra
using Plots
using StatsBase
gr()


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

# some notes
#data :: Dict{String, Any}
#data[somekey] :: Dict{String, Any}

waves = NamedTuple[]
for wid in keys(data)
    if data[wid]["nJudOrigs"] == 5 & data[wid]["nSubScos"] == 5
        origs = unique(data[wid]["subScoOrig"])
        matchIndicator = (data[wid]["athOrig"] in origs)
        labeledScos = Dict([isoDict[origin] => Float16[] for origin in origs])
        origScoPairs = collect(zip(data[wid]["subScoOrig"],data[wid]["subSco"]))

        labeledScosBinary = Dict([:Match => Float16[], :NoMatch => Float16[] ])

        #=
        Surfer country is :A
        [(:A,1), (:A, 1.1), (:B,1), (:C, 1.5), (:D,1.3)]
        Dict([  :A => [1, 1.1]
                :B => [1]
                :C => [1.5]
                :D => [1.4]
        ])

        Surfer country is :A
        [(:A,1), (:A, 1.1), (:B,1), (:C, 1.5), (:D,1.3)]
        Dict([  :Match => [1, 1.1]
                :NoMatch => [1, 1.5, 1.4]
        ])
        =#



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

function everyPerm(C::Union{Set,Array})
    A = unique(C)
    P = Array{eltype(A),1}[]
    function continuePerm(head,tail)
        if length(tail) > 0
            for t in tail
                newHead = union(head, [t])
                newTail = setdiff(tail, [t])
                continuePerm(newHead, newTail)
            end
        else
            push!(P, head)
        end
    end
    continuePerm(eltype(A)[], A)
    return P
end

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
allPerms = union( (everyPerm.(allPanelCompositions))... )
# Check sum()
sum( factorial.(length.(allPanelCompositions))) == length(allPerms)
probOnAllPerms = Dict([p=>0.0 for p in allPerms])
probOnAllPermsPrime = Dict([p=>0.0 for p in allPerms])
panelCompCount = Dict([c=>0 for c in allPanelCompositions])
hit = []
notHit = []
for panelComp in allPanelCompositions
    for w in filter(x -> x.panelOrigs == panelComp, waves)
        ordersHit = false
        k = minimum(length.(values(w.panel)))
        for ord in everyPerm(panelComp)
            S = Iterators.product([w.panel[c] for c in ord]...)
            v = mapreduce(s-> strictOrder(s) ? 1 : 0, +, S) / length(S)
            vprime = any(strictOrder.(S)) ? 1 : 0
            probOnAllPerms[ord] += v*k
            probOnAllPermsPrime[ord] += vprime
            if v > 0
                ordersHit = true
            end
        end
        if ordersHit == true
            push!(hit, w)
        else
            push!(notHit, w)
        end
    end
end


####
### WANT: write a function X: panel --> set of all perms

diffsFromUnif = deepcopy(probOnAllPerms)
diffsFromUnifPrime = deepcopy(probOnAllPermsPrime)

for comp in allPanelCompositions
    permsForComp = filter(x-> Set(x[1])==comp, diffsFromUnif)
    permsForCompPrime = filter(x-> Set(x[1])==comp, diffsFromUnifPrime)
    mass = sum(values(permsForComp))
    massPrime = sum(values(permsForCompPrime))
    n = length(permsForComp)
    for p in keys(permsForComp)
        diffsFromUnif[p] /= mass
        diffsFromUnifPrime[p] /= massPrime
        diffsFromUnif[p] -= 1/n
        diffsFromUnifPrime[p] -= 1/n
    end
end

kl = collect(values(diffsFromUnif))
klprime = collect(values(diffsFromUnifPrime))

histogram(kl)
histogram!(klprime)

mean(kl)
mean(klprime)
minimum(kl)

stdev(kl)
minimum(klprime)



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
