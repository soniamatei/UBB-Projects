%U in U(0,1)
%F_U(x) = {0 if x<0; x if 0<=x<1; 1 if x>=1}

%p ->prob of success

%end result:
%X(o 1 \\ 1-p p)

%X={1 if U<p; 0 if U>=p}

%P(X=1) = P(U<p) - P(U<=p) = F_U(p) = p

p = input("prop=")
N = input("simulations=")

U=rand(1,N)
X = (U<p)

U_X = unique(X)
n_X = hist(X, length(U_X))
rel_freq = n_X / N
