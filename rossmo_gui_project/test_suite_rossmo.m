% Test code for various functions

% Tests each function 
% and submits a report
%
clear all
close all
addpath './rossmo'

% vectors to keep names and results of tests
tests = [];

tic

distEuclid = @(x1,x2,y1,y2) sqrt((x1-x2)^2 + (y1-y2)^2);
distManhat = @(x1,x2,y1,y2) abs(x1-x2) + abs(y1-y2);


load rossmoTestData.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_rossmo_dijkstra_Testdata';
[Pscaled] = rossmoDijkstra(icrimes,f,g,B,distanceTable);
test.ok = (all(abs(Pscaled-PscaledD) < 1e-3));
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_rossmo_irreg_Testdata_E';
[Pscaled] = rossmoIrreg(x,y,icrimes,f,g,B,distEuclid);
test.ok = (all(abs(Pscaled-PscaledE) < 1e-3));
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_rossmo_irreg_Testdata_M';
[Pscaled] = rossmoIrreg(x,y,icrimes,f,g,B,distManhat);
test.ok = (all(abs(Pscaled-PscaledM) < 1e-3));
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_genDelaunayCity_sizes';
npts = 25;
x_km = 10;
y_km = 10;
[x,y,distanceTable,TRI] = genDelaunayCity(x_km, y_km, npts);
test.ok = (length(x) == npts & ...
           length(y) == npts & ...
           size(distanceTable,1) == npts);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_rossmo_euclid_sizes';
icrimes = floor(rand(3,1)*(npts-1))+1;
f = 1;
g = 1;
B = 3;
[Pscaled] = rossmoIrreg(x,y,icrimes,f,g,B,distEuclid);
test.ok = (length(Pscaled) == npts & ...
           abs(min(Pscaled)-0) < 1e-6 & ...
           abs(max(Pscaled)-1) < 1e-6);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_rossmo_dijkstra_sizes';
[Pscaled] = rossmoDijkstra(icrimes,f,g,B,distanceTable);
test.ok = (length(Pscaled) == npts & ...
           abs(min(Pscaled)-0) < 1e-6 & ...
           abs(max(Pscaled)-1) < 1e-6);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_rossmo_dijkstra_one_crime';
icrimes=floor(rand(1)*(npts-1))+1;
[Pscaled] = rossmoDijkstra(icrimes,f,g,B,distanceTable);
test.ok = (Pscaled(icrimes) < 0.8);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


run_time = toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO OUTPUT PRINTING         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntests = length(tests);

disp(['Ran ', num2str(ntests), ' tests in ', num2str(run_time), ' seconds : '])

for i = 1:ntests
  test = tests(i);
  if test.ok
    X = [test.name, ' : OK'];
  else
    X = [test.name, ' : Fail'];
  end
  disp(X)
end
