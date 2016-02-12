%clear all
close all

% read the data file
[latvec, lonvec, mvector] = readSihexData('SIHEXV2-catalogue-final.txt');
[log10N,bins] = GR(mvector);
N = 10.^log10N;
semilogy(bins,N,'*')
xlabel('Ml','FontSize',18)
ylabel('N (magnitude > M)','FontSize',18)
title('Gutenberg-Richter (France) 1962-2009','FontSize',24)
print -dpng GR_france.png
