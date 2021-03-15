function Sym(A::Union{Set,Array})
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

function Sym(n::Integer)
    A = collect(1:n)
    P = Array{Int,1}[]
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
    continuePerm(Int[], A)
    return P
end

function P(τ::Array; inSnWithn=nothing)
    if inSnWithn==nothing
        M = zeros(Int16, length(τ),length(τ))
    else
        M = zeros(Int16, inSnWithn,inSnWithn)
    end
    for i in 1:length(τ)
        M[ i , τ[i] ] = 1
    end
    return M
end
