function [E] = expectedValue(x,prob)
f = x.*prob;
E = trapz(x,f);
end