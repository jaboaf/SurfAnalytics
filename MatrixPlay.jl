using LinearAlgebra
using Plots
gr()
b = Complex[1,2,3,4,5,6,7,8,9]
one = ones(Complex,9)
D = (b) * one'
D + D'

# Construct a believable W
W = ones(Complex, 9,9)
for i in 1:9
    for j in 1:9
        if i != j   W[i,j] = round(b[i]/ (b[i] + b[j]) * 19)
        else        W[i,j] = 0
        end
    end
end

# MM Algos for BT Models
sum(W .* (log.(D) .- log.(D + D')))

betaInCols = exp(D)
betaInRows = exp(D')
gamma = Complex[1 2 3 4 5 6 7 8 9]
beta = log.(gamma) .- log(gamma[1])

diagm(1 => ones(8)) * gamma'


* beta'

function lambda(β, W)
    for i
