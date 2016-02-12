function [log10N,bins] = GR(mvector)
  mag_min = min(mvector);
  mag_max = max(mvector);
  mags = [mag_min:0.1:mag_max];
  [N,bins] = hist(mvector,mags);
  log10N = zeros(size(bins));
  nbins = length(bins);
  for i = 1:nbins
    log10N(i)=log10(sum(N(i:nbins)));
  end
end