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

function disGivDeg(deg::Array{Int,1}, rowOrient=true)
    A = collect(1:length(deg))
    P = Pair{Array{Int},Float64}[]
    function continuePerm(head,tail,p)
        if length(tail) > 0
            i = head[end]
            for t in tail
                newHead = union(head, [t])
                newTail = setdiff(tail, [t])
                newP = p * deg[i] * deg[t]
                continuePerm(newHead, newTail, newP)
            end
        else
            push!(P, head => p)
        end
    end
    for n in A
        continuePerm([n], setdiff(A,n), 1.0)
    end
    sort!(P)
    if rowOrient = true
        return P
    else
        perms = map(x->x[1], P)
        vals = map(x->x[2], P)
        D =
        return

    return P
end

#Bunch-Kaufman???
#getproperty
#setindex
#getindex



function allPartitions(n::Int,k::Int)
    if n < k error(" n < k , there is no way to partition n into a sum of k elements") end
    A = [ n-k+1, ones(k-1)... ]
    for i in 1:floor( (n-k+1)/2 )
        continue
    function continuePart(A)
        if length(A)
    end
    return continuePart(n,k,n)
end


remK = k - length(head)
if remK > 0
    maxBucket = 1+remN-remK
    minBucket =
    for i in minBucket:maxBucket
        newHead = vcat(head, [i])
        newRemN = remN - i
        continuePart(newHead, newRemN)
    end
else
    push!(P, head)
end
end
continuePart(Int[], n)
return P


k = 5
for c in 1:k
distrib1 = sort!(disGivDeg([1,1,1,1,1]))
histogram(map(x->x[2],distrib1), bar_width = 0.05)
# 1 unique
#---
distrib2 = disGivDeg([2,1,1,1,1])
histogram(map(x->x[2] / 2,distrib2), bar_width = 0.5, normalize=:pdf)
# 2 unique
distrib2 = disGivDeg([2,2,1,1,1]
histogram!(map(x->x[2],distrib2), bar_width = 0.25,normalize=:pdf)
# 3 unique
distrib2 = disGivDeg([2,2,2,1,1])
histogram!(map(x->x[2],distrib2), bar_width=0.125)
# 3 unique
distrib2 = disGivDeg([2,2,2,2,1])
histogram!(map(x->x[2],distrib2), bar_width=0.065)
# 2 unique
#---
d31 = [3,2,1,1,1]
d32 = [3,2,2,2,1]
d33 = [3,3,3,2,1]
distrib3 = disGivDeg(d31)
vals = map(x->x[2],distrib3)
histogram(vals ./ maximum(vals), bar_width=0.05)
# 4 unique
distrib3 = disGivDeg(d32)
vals = map(x->x[2],distrib3)
histogram!( vals / maximum(vals), bar_width=0.05)
#4 unique
distrib3 = disGivDeg(d33)
vals = map(x->x[2],distrib3)
histogram!( vals / maximum(vals), bar_width=0.1)
#-
d34 = [3,2,2,1,1]
d35 = [3,3,2,1,1]
d36 = [3,3,2,2,1]
distrib3 = disGivDeg(d34)
vals = map(x->x[2],distrib3)
histogram!(vals / maximum(vals), bar_width=0.05)

distrib3 = disGivDeg(d35)
vals = map(x->x[2],distrib3)
histogram!(vals / maximum(vals), bar_width=0.05)

distrib3 = disGivDeg(d36)
vals = map(x->x[2],distrib3)
histogram!(vals / maximum(vals), bar_width=0.05)
# 5 uniqe
#-

#---
d41 = [4,3,2,1,1]
d42 = [4,3,2,2,1]
d43 = [4,3,3,2,1]
d44 = [4,4,3,2,1]
distrib4 = disGivDeg(d41)
sort!(distrib4)
vals = map(x->x[2],distrib4)
histogram(vals / maximum(vals), bar_width=0.05)
distrib4 = disGivDeg(d42)
vals = map(x->x[2],distrib4)
histogram!(vals / maximum(vals), bar_width=0.05)
distrib4 = disGivDeg(d43)
vals = map(x->x[2],distrib4)
histogram!(vals / maximum(vals), bar_width=0.05)
distrib4 = disGivDeg(d44)
vals = map(x->x[2],distrib4)
histogram!(vals / maximum(vals), bar_width=0.05)

#---
distrib5 = disGivDeg([5,4,3,2,1])


histogram!( vals1 , bins = 10, width= 1, normalize=:probability)
