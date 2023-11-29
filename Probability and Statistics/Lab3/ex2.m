%2.b

% two random var follow the same law of their pdf coincide

%n = input("n=")
%p = input("p=")
%l = n * p
%x = 0:n

%plot(x, binopdf(x, n, p))
%hold on
%plot(x, poisspdf(x, l))

%2.a

p = input("p=") %probability

for n = 1:5:1000

  x = 0:n %number of successes
  plot(x, binopdf(x, n, p)) %plot should only look like normal form
  pause(0.5)

endfor

U_X = unique(X)
n_X = hist(X, length(U_X))
rel_freq = n_X / N

k = 0:n;
plot(U_X, rel_freq, "*",k, binopdf(k,n,p), "r*")
