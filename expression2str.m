function str = expression2str( p, flag )
% converts large coefficient fractions to reasonable decimals as string

switch(flag)
    case 1 %linear with intercept
        str = sprintf('%.4g*X + %.4g', p);
    case 2 %linear no intercept
        str = sprintf('%.4g*X', p);
    case 3 % polynomial
        str =[];
            for n=1:length(p)
                str = sprintf('%s %+.4g X^%d', str, p(n),length(p)-n);
            end
    case 4 %exponential
        str = sprintf('%.4g*exp(%.4g*X)', p(1), p(2));
    case 5 %power
        str = sprintf('%.4g*X^%.4g', p(1), p(2));
    case 6 %trig
         str = sprintf('%.4g %+.4g*cos(X)',p(2), p(1));
    case 7 % log
        str = sprintf('%.4g*log(X) + %.4g', p(1), p(2));
    case 8 % reciprocal
        str = sprintf('1/(%.4g*X + %.4g)', p(1), p(2));
end

