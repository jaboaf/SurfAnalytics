#include("SymGrpAndReps.jl")
#using GRUtils

struct SymGrp
	N::Int
end

struct Perm
	N::Int
	A::Array
end

struct Tensor

S = Array{Int}

#=
We have a coordinate free approach:
P_tau = (\tau(i) = j ? delta_i,j = 1 : 0 )

Data,
D = (P_{tau_n})_{n=1}^N
=#


#=
What do we need to implement tensor algebra?

~ E = (e_1, ... e_n) of ind. variables

~ PermGroup on multiset (multisets are just arrays)

~ Exterior product ( monomialX , monomialY )
if ( monomialX cap monomial Y) == emptyset then:
	tau = invperm(cat(monomialX, monomialY))
	
	return sgn(tau) cat(monomialX, monomialY)

else
	return 1

=#
