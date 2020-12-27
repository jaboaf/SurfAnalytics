using Permutations
using LinearAlgebra

A = I(5)

for i in 1:10
    A *= Matrix(RandomPermutation(5))
end


eigvals(A)
