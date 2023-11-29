n = input("n = ");
p = input("p = ");
x = 1:n;
y = binopdf(x, n, p); % P(X = x)
plot(x, y,"*");
hold on
xx = 0:0.01:n;
yy = binocdf(xx, n, p); % P(X <= x)
plot(xx, yy);

% x(xi, pi);; matrix;; xi -> values ; pi -> probabilities x-> dicrete random variable
% x(nr of successes, prob of obt. successes) -> Bino(n, p)
