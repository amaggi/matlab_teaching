function [Pscaled] = rossmoDijkstra(icrimes,f,g,B,distanceTable)
% calculates scaled probability density
% for profiling using a general distance function
% icrimes : intersection indexes at which crimes have occurred
% f, g, B : scalar values of profiling parameters
% distanceTable : matrix of distances between connected intersection 

npts = size(distanceTable,1);

% output has same size as X and Y
P = zeros(npts,1);

% loop over crimes
for i = 1:length(icrimes)
  % loop over points in city
  ic = icrimes(i);
  for j = 1:npts
    d = dijkstra(distanceTable,ic,j);
    if d > B
      P(j) = P(j) + 1/(d^f);
    else
      P(j) = P(j) + (B^(g-f))/((2*B-d)^g);
    end
  end
end

% scale to 0-1
pmax = max(P);
pmin = min(P);
Pscaled = (P - pmin)/(pmax-pmin);

end