include("SymGrpAndReps.jl")

diagSum = []
offDiagSum = []
excessDiagSum = []
flatSum = []

for k in 1:10
	Pk = P(k)
	G = sum(exp.(Pk))
	push!( diagSum, sum(diag(G)) )
	push!( offDiagSum, sum(G)-sum(diag(G)) )
	push!( excessDiagSum, sum(diag(G)) - minimum(G)*k )
	push!( flatSum, minimum(G)*k^2)
end