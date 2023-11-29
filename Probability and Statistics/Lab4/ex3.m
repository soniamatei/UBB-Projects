p = input("prop=")
N = input("simulations=")
n = input("trials=")

for i = 1:N
  for j = 1:n
    X(j) = 0;

    while rand >= p
      X(j) = X(j) + 1;

    endwhile

  endfor
  Y(i) = sum(X); %Y~Nbin

endfor

U_X = unique(Y);
n_X = hist(Y, length(U_X));
rel_freq = n_X / N;

k = 0:190;

plot(U_X, rel_freq, '*', k, nbinpdf(k, n, p), 'r*')
