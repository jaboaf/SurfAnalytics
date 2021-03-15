LoadPackage( "ctbllib" );
n=7
Sn = SymmetricGroup(n);

# what do we think the order is?
# 7! is a good guess
Factorial(7);

# Lets check. Order
Order(s7);

# Number of Conjugacy Classes
NrConjugacyClasses(tbl);

# How big is each conjugacy class?
SizesConjugacyClasses(tbl);

#
NthRootsInGroup