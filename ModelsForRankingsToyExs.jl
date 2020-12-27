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

S₃ = permGroup([1,2,3])

function I(x,y, list)
    looking = true
    for elem in list
        if elem == x return 1
        end
        if elem == y return 0
        end
    end
end

function C(m::Array{T,2} where T <: Real)
    k = size(m)[1]
    Sk = permGroup(collect(1:k))
    sum = 0
    for perm in Sk
        prod = 1
        for i in 1:k
            for j in (i+1):k
                prod *= (m[i,j] ^ I(i,j, perm) )
            end
        end
        sum += prod
    end
    return sum
end

# Function implements (2) in On the Babington Smith Class of Models for Rankings
# P(π) = ∏_{i<j} ( Θ_{ij} )^{I}
function P(perm::Array, m::Array{T,2} where T <: Real)
    k = length(perm)
    if k != size(m)[1] && k != size(m)[2] error("The following is false: k != size(m)[1] && k != size(m)[2]") end

    prod = 1
    for i in 1:k
        for j in (i+1):k
            prod *= (m[i,j] ^ I(i,j, perm))
        end
    end
    return prod / C(m)
end


Θ = [   0   1   1   0;
        0   0   1   1;
        0   0   0   1;
        1   0   0   0   ]
for i in 0:4
    println("-------- Shift by  $i ---------------")
    A = circshift(Θ, (i,i))
    notA = (A .+ 1) .% 2
    println("C(Θ) = $C(Θ) and C(notA)= $(C(notA))")
    for p in permGroup(collect(1:4))
        println("π=$p and P(π|A) = $(P(p, A)) and P(π|notA) = $(P(p, notA)) ")
        #println("P($p |notΘ) = $(P(p, notΘ))")
        #println("$(P(p, notΘ)) ")
    end
end


function Propto(perm::Array, m::Array{T,2} where T <: Real)
    k = length(perm)
    if k != size(m)[1] && k != size(m)[2] error("The following is false: k != size(m)[1] && k != size(m)[2]") end

    prod = 1
    for i in 1:k
        for j in (i+1):k
            prod *= ( m[i,j]^I(i,j, perm) * (1 - m[i,j])^(1-I(i,j, perm)) )
        end
    end
    return prod
end


Θ = [   0   1   1   0;
        0   0   1   1;
        0   0   0   1;
        1   0   0   0   ]
for i in 0:4
    println("-------- Shift by  $i ---------------")
    A = circshift(Θ, (i,i))
    notA = (A .+ 1) .% 2
    for p in permGroup(collect(1:4))
        println("π=$p and Propto(π|A) = $(Propto(p, A)) and Propto(π|notA) = $(Propto(p, notA)) ")
    end
    println("-------------------")
end
