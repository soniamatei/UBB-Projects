% X - carac of the pop with pdf f_X(x, t)
% t -> the stat depends on it; unknown
% Objective: estimate t
% - we make a selection / sample of volume n, that is, you get X_1..X_n rv independent and identically distributed with
% =>they have the same pdf as X

% Methods:
% 1. use a selection function t(bara sus) = t(bs)(X_1..N_n) that estimates your t
% 2. find t_2(bs),t_4(bs) such that: P(t_2<t<t_4) = 1 -alfa, alfa in [0,1]
% Terminology:
% (t_2,t_4) - 100(1-alfa) % CI for t
% (1-alfa) - confidence level / coeff
% alfa - significance level
% ceatsheet : cond_int.pdf

%remarks:
% x-vector of data
% miu = population mean(theoretical mean)
% x(b) = sample mean(help mean)
% sigma^2 = population variance (trace var)
% s^2 = sample variance(var(x))
% sigma = population standard deviation
% s = sample st. dev.(std(x))
% z_alfa = the quantile of order alfa of the N(0,1) law
% n = sample size

%!quantiles -> ___inv(...)

%1Ba
%t - confidence interval
%you estimate miu and know sigma

X = [7, 7, 4, 5, 9, 9, 4, 12, 8, 1, 8, 7, 3, 13, 2, 1, 17, 7, 12, 5, 6, 2, 1, 13, 14, 10, 2, 4, 9, 11, 3, 5, 12, 6, 10, 7]
n = length(X);
onealpha = input("min alpha")%0.95 X
alpha = 1 - onealpha;
xbar = mean(X);
%sigma = 5;
%orders a - alfa/2, alfa/2
%m_1 = xbar - sigma/sqrt(n)*norminv(1-alpha/2);
%m_2 = xbar + sigma/sqrt(n)*norminv(1-alpha/2);
%printf("The coef int for pop mean when sigma is known is (%4.3f, %4.3f)", m_1, m_2);

%b)
%standard_dev = std(X);
%m_1 = xbar - standard_dev/sqrt(n)*tinv(1-alpha/2, n-1);
%m_2 = xbar + standard_dev/sqrt(n)*tinv(1-alpha/2, n-1);
%printf("The coef int for pop mean when sigma is unknown is (%4.3f, %4.3f)", m_1, m_2);

%c)
%chi2inv() chi^2
pop_var_1 = ((n-1)* var(X))/chi2inv(1-alpha/2, n-1)
pop_var_2 = ((n-1)* var(X))/chi2inv(alpha/2, n-1)
printf("Variance:(%4.3f, %4.3f)", pop_var_1, pop_var_2);
printf("standard deviation(%4.3f, %4.3f)", sqrt(pop_var_1), sqrt(pop_var_2));

%2
% vector for premium and regular separately
% ! x = [ 1 * ones(1, 3),...


