function [Pscaled] = rossmoIrreg(X,Y,icrimes,f,g,B,dist_fn)
% calculates scaled probability density
% for profiling using a general distance function
% X, Y : coordinates of the irregular points that define
% the city intersections
% icrimes : indexes of X and Y at which crimes have occurred
% f, g, B : scalar values of profiling parameters
% dist_fn : handle of distance function to use 

% output has same size as X and Y
P = zeros(size(X));

% loop over crimes
for i = 1:length(icrimes)
  % loop over points in city
  ic = icrimes(i);
  for j = 1:length(X)
    d = dist_fn(X(ic),X(j),Y(ic),Y(j));
    if d > B
      P(j) = P(j) + 1/(d^f);
    else
      P(j) = P(j) + B^(g-f)/(2*B-d)^g;
    end
  end
end

% scale to 0-1
pmax = max(P);
pmin = min(P);
Pscaled = (P - pmin)/(pmax-pmin);

end