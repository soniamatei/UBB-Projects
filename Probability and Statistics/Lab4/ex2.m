##p = input("prop=")
##N = input("simulations=")
##n = input("trials=")
##
##for i=1:N
##  U = rand(n, 1);
##  X(i) =sum(U<p)
##
##endfor
##k = 0:n;
##
##U_X = unique(X)
##n_X = hist(X, length(U_X))
##rel_freq = n_X / N
##
##plot(U_X, rel_freq, '*', k, binopdf(k, n, p), 'r*')

p = input("prop=")
N = input("simulations=")

for i=1:N
  x(i) = 0;
  while rand >= p
    X(i) = X(i) + 1;

  endwhile

endfor
k = 0:40;

U_X = unique(X);
n_X = hist(X, length(U_X));
rel_freq = n_X / N

plot(U_X, rel_freq, '*', k, geopdf(k, p), 'r*')
