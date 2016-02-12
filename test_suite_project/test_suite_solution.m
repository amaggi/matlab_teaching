% Test code for various functions

% Tests each function 
% and submits a report
%
clear all
format long

% vectors to keep names and results of tests
tests = [];

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_length2area';

% set up the test case
len_true = rand(1)*4;
height = len_true*sin(60*pi/180);
area = len_true*height/2;
% use the function
len = area2length(area);
% do the comparison
test.ok = (abs(len - len_true) < 1e-6);

tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
% Add other tests here...
%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'genPublicKey';

p = 503;
q = 563;
e_true = 565;
n_true = 283189;

[e,n] = genPublicKey(p,q);
test.ok = (e == e_true & n == n_true);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('FranceTable.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'dijkstra_Paris_Strasbourg';
dist_true = 185+522;
[dist,steps,n_it] = dijkstra(franceTable,8,10);
test.ok = (dist == dist_true);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'dijkstra_Bordeaux_Marseille';
dist_true = 237+557+171;
[dist,steps,n_it] = dijkstra(franceTable,2,5);
test.ok = (dist == dist_true);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'expectedValue_poisson';
lambda = 5;
k = [0:20];
p = poisson(lambda, k);
eval = expectedValue(k,p);
test.ok = (abs(eval - lambda) < 0.001);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_trapz';
x=[1:100];
y=zeros(size(x));
a=20;
b=50;
y(a:b)=1;
area=trapz(x,y);
test.ok = (area == (b-a)+1);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_polyfit';
m = floor(rand(1,3)*9)+1;
x = [0:0.01:10];
y = m(1)*x.^2 + m(2)*x + m(3);
coef = polyfit(x,y,2);
test.ok = all(abs(m-coef) < 1e-6);
tests = [tests; test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test.name = 'test_polyfit_bruit';
y = y + (rand(size(y))-0.5)*0.1;
coef = polyfit(x,y,2)
test.ok = all(abs(m-coef) < 1e-2);
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