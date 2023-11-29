%solving exercise one for the normal distribution

m = input("mean=")
v = input("deviation")

%1.a

%P( X<=0 )
normcdf(0, m, v)

%P(X >= 0) = 1 - P(X <= 0) a continuous low doesn't distinguish between greater or equal and greater
1 - normcdf(0, m, v)

%1.b

%P(-1 <= X <= 1) = F(1) - F(-1)
normcdf(1, m, v) - normcdf(-1, m, v)

%P(X <= -1) or P(X >= 1)
1 - (normcdf(1, m, v) - normcdf(-1, m, v))

%1.c

a = input("alfa=")
norminv(a, m, v)

%1.d

b = input("beta=")
norminv(1 - b, m, v)
