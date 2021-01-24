include("SymGrp.jl")
using LinearAlgebra

S = Sym(7)

function permanent(M::Array{T,2}) where T <: Number
    if size(M)[1] != size(M)[2] error("M is not square")
    else n = size(M)[1]
    end
    tot = 0
    for τ in Sym(n)
        p = 1
        for i in 1:n
            p *= M[i,τ[i]]
        end
        tot += abs(p)
    end
    return tot
end

s = rand(S)

a = rand(S)
Ma = MatRep(a)
b = rand(S)
Mb = MatRep(b)
a != b

exp(Ma) - diagm(ones(7))
M = zeros(7,7)
for n in 1:100
    M += Ma^

t = rand(7)
t/=sum(t)
sum(t)
sum(t * t')
