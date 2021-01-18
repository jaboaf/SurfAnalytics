import JSON
using LinearAlgebra
using Plots
using StatsBase
gr()

data = Dict()
open("Data/CombinedCountries/CleanAllDataCC.txt", "r") do f
    global data
    data = JSON.parse(f)  # parse and transform data
end

# some notes
data :: Dict{String, Any}
#data[somekey] :: Dict{String, Any}


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

pairs = map( x -> collect(zip(x["subScoOrig"],  x["subSco"])), filter(x -> !("-1" in x["subScoOrig"]), values(data)) )
len()


struct ω

# for working with categorical Data: https://stackoverflow.com/questions/39529284/how-to-work-with-categorical-data-in-julia

#look at this: https://github.com/andyferris/Indexing.jl
#=
What we want to do is define a struct or named tuple
struct ω
=#


# see https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple
# generally,
@NamedTuple begin
    Pair{String,Any}("1282538", Dict{String,Any}(
    matchMean::Int8 # "matchMean" => -1
    subScoDefect::Bool # "subScoDefect" => false
    rnd::String # "rnd" => "4"
    evtOrig:: # "evtOrig" => "Indonesia"
    evtId::String # "evtId" => "2912"
    athName::String # "athName" => "Jeremy Flores"
    subSco::Array{Float16} # Could also be NTuple{Float16, 5} "subSco" => Any[4.0, 4.5, 4.0, 3.5, 4.0]
    endingPoints::Int16 # "endingPoints" => 32515
    nSubScos::Int8#"nSubScos" => 5
    "noMatchVar" => 0.1
    "athId" => "562"
    "actualScoVar" => 0.0
    "heatId" => "77139"
    "noMatchMean" => 4.0
    "subScoMean" => 4.0
    "subScoVar" => 0.1
    "matchSubScos" => Any[]
    "actualScoLevel" => "good"
    "evtName" => "Bali Pro"
    "atHome" => false
    "subScoOrigDefect" => false
    "noMatches" => 5
    "actualSco" => 4.0
    "subScoOrig" => Any["Brazil", "Australia", "United States", "Australia", "Brazil"]
    "matches" => 0
    "heat" => "3"
    "currentPoints" => 4650
    "athOrig" => "France"
    "nJudOrigs" => 5
    "evtYear" => "2019"
    "rndId" => "12867"
    "matchVar" => -1
    "validSubScos" => Any[4.0, 4.5, 4.0, 3.5, 4.0]
    "noMatchSubScos" => Any[4.0, 4.5, 4.0, 3.5, 4.0])
    a::Float64
    b::String
end
