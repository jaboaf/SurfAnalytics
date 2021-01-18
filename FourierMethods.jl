using LinearAlgebra

# Fourier Methods
function fourierMatrix(n::Integer)
    ω = ℯ^(2*pi*im/n)
    F = 1/sqrt(n) * ones(Complex, (n,n))
    for j in 1:n
        for k in 1:n
            F[j,k] = ω^((j-1)*(k-1))
        end
    end
    return F
end

ℱ = fourierMatrix(7)
