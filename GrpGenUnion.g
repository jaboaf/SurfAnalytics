# C:\Users\joabo\Documents\GitHub\SurfAnalytics
# Read("C:\Users\joabo\Documents\GitHub\SurfAnalytics\GrpGenUnion.g");

for k in [3 .. 5] do
	f := 0;
	g := 0;
	Sk := SymmetricGroup(k);
	for a in Sk do
		for b in Sk do
			G := GroupWithGenerators( [a, b] );
			if IsomorphismGroups(Sk,G)=fail then
				f:= f+1;
			else
				g:= g+1;
			fi;
		od;
	od;
	Print("k=", k, " f=", f, " g=", g, "\n");
od;

	