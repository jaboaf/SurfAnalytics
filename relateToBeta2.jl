using Plots
gr()
using Distributions
using LinearAlgebra

# Distribution on permutations given a degree sequence
function permGroup(A::Union{Set,Array})
    unique!(A)
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

# Beta given "friendliness" params
# β = [ ... ] means "friendliness" of node i = β[i]

function ProbGivenβ(β::Array)
    b = length(β)
    Sb = permGroup( collect( 1:b ))
    function wtOfPerm(τ::Array, D::Array)
        p = 1
        for i in 1:b
            p += D[i]*D[τ[i]]
        end
        return p
    end
    βresult = map(x->wtOfPerm(x,β), Sb)
    βresult /= sum(βresult)
    return βresult
end

β = [rand(Normal(4,1),5)... ,6]
b = length(β)
U = mean(β)*ones(b) + 1*rand(b)
Sb = permGroup( collect( 1:b ))
function wtOfPerm(τ::Array, D::Array)
    p = 1
    for i in 1:b
        p += D[i]*D[τ[i]]
    end
    return p
end
Uresult = map(x->wtOfPerm(x,U), Sb)
Uresult /= sum(Uresult)
βresult = map(x->wtOfPerm(x,β), Sb)
βresult /= sum(βresult)

histogram(βresult, bins=50)
histogram!(Uresult)
Sb[findall(x-> x>maximum(Uresult), βresult)]

dadsSample = []
for i in 1:1000
    push!(dadsSample, sum(sample(βresult, 100, replace=false)) )
end
histogram(dadsSample)
β

s = rand(1000)
(s .- mean( s )) / std(s)
histogram(s)

dist0 = ProbGivenβ(rand(Normal(0,1),6))
histogram(dist0)

dist10 = ProbGivenβ(rand(Normal(10,1),6))
histogram!(dist10)

distNeg10 = ProbGivenβ(rand(Normal(-10,1),6))
histogram!(distNeg10)







graphplot([0 1 0; 0 0 1; 1 0 0])
allFours = ProbGivenβ( 4*ones(6) .+ rand(6) )
histogram(allFours)
