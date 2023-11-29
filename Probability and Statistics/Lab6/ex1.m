% T -> hyp testing
% T unknown
% post / previous experiment => ideea about T
% future / possible new assumptions on T
% H_0 -> null hyp.
% H_1 - > research hyp / alternative hyp
% Hyp testing -> H_0: T = T_0
%             -> H_1 (one of the following): T < T_0 (left-tailed test) ; T > T_0(right-tailed test); ; T /= T_0(two-tailed test) where T_0 given value
% Important terminology:
%   answer to a statictical test: reject H_0 or do not reject H_0 (past)
%   alfa in (0, 1): significance level (in practice alfa in {0.05, 0.01, 0.001})
%   TS = test statistic (pivot in confidence interval CI) -> random var.
%   TS_0 = observed value the TS = TS_0(TS for T = T_0) -> number
%   RR = rejection region
%   P-value = minimun threshold of rejection (smallest alfa for which we still reject H_0)
% How to reject/don't reject H_0
%   Hyp testing:
%     if : TS_0 in RR, reject H_0
%     else : do not reject H_0
%   Significance testing:
%     if alfa >= P, reject H_0
%     else: do not reject H_0
% IMPORTANT: TS_0, RR, P

% 1a
% mean needs estimation (on average)
% H_0 : miu = 9 (always with equal; min value)
% H_1 : miu < 9
% left-tailed test for the mean when sigma known (a and 1 a)
% alfa (significance level) = ?
% x = ?

alfa = 0.05;
x = [7, 7, 4, 5, 9, 9, 4, 12, 8, 1, 8, 7, 3, 13, 2, 1, 17, 7, 12, 5, 6, 2, 1, 13, 14, 10, 2, 4, 9, 11, 3, 5, 12, 6, 10, 7];
n = length(x);
% the null hyp is H_0 = 9
% the alt hyp is h_1: miu < 9
% left-tailed test for mie when sigma known
printf("This is a left-tailed test for miu when sigma known")
sigma = 5;
miu_0 = 9; %this is given in h_0
% [H, P, CI, Z, Z-CRIT] = ztest(X, M, SIGMA, NAME, VALUE)
% H - > (0 -> don't reject or 1-> reject)
% P -> P-value
% CT -> dont care in this case
% Z -> TS_0
% Z-CRIT -> dont care in this case
% X -> x
% M -> miu
% SIGMA -> sigma
% NAME -> in {"alfa", "tail"}
% VALUE -> depends on NAME
% RR -> from cheat sheet
[h, p, ci, z, zpcrit] = ztest(x, miu_0, sigma, "alpha", alfa, "tail", "left");
% h_alfa = quantile of order alfa for some law
z2 = norminv(alfa);
RR = [-inf, z2];
printf("the value of h is %d", h);
if (h == 1)
    printf("the null hyp is rejected");
    printf("the data sugests that the standard is not met");
else
    printf("the null hyp is not rejected");
    printf("the data sugests that the standard is met");
endif

printf("\nthe rej. region is (%4.4f, %4.4f)", RR);
printf("\nthe observed value of the test statistic is %4.4f", z);
printf("\nthe P-value of the test is %4.4f", p);

% 1b
% the null hyp is H_0 = 5.5
% the alt hyp is h_1: miu > 5.5
% right-tailed test for mie when sigma known
% T - student, T(n-1) -> lenght data
miu_0_2 = 5.5;
[h, p, ci, stats] = ttest(x, miu_0_2, "alpha", alfa, "tail", "right");
% H- > (0 -> don't reject or 1-> reject)
% P -> P-value
% CT -> dont care in this case
% STATS -> structure; STATS.tstat to get the value of it
% X -> x
% M -> miu
% NAME -> in {"alfa", "tail"}
% VALUE -> depends on NAME
% RR -> from cheat sheet computet manually
t2 = tinv(1 - alfa, n - 1); %specify the degrees of freedom
RR = [t2, inf];
printf("\nthe rej. region is (%4.4f, %4.4f)", RR);
printf("\nthe observed value of the test statistic is %4.4f", stats.tstat);
printf("\nthe P-value of the test is %4.4f", p);

%Remarks:
% T = sigma^2, vartest function use
% T = sigma_1^2 / sigma_2^2, vartest
% T = miu_1 - miu_2, ztest/ttest
%cascade style exercises: in order to solve b you need to sove a

