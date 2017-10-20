function [res, D, K] = diffNoisyData(indep_var, dep_var, stdev)
% THIS FUNCTION TAKES DATA WITH AN AMOUNT OF NOISE AND RETURNS AN
% APPROXIMATION OF ITS DERIVATIVE
% This is done by following the gradient of a cost function.  That cost
% function is:
% F( u(x) ) = a*intgrl( (du/dx).^2,dx) + 1/2 * intgrl( ( (intgrl(u,dx) - f)/intgrl(abs(f),dx) ).^2, dx)
%
% where u is the estimate of the first deriv of f with respect to x, and f
% is the data that you're trying to estimate the derivitive of.  Note: the
% first part of the function seeks to minimize the derivitive of u,
% (minimal acceleration of f, should keep it smooth), weighted by "a".  The
% second part of the cost function seeks to minimize the error between the
% integral of u and the actual data, f.  This quantity it normalized by the
% integral of the absolute value of the data.

% Format the data, turn into column vectors
if min(size(indep_var)) ~= 1 & min(size(dep_var)) ~= 1
    error('indep_var and dep_var are expected to be 1-D vectors')
    return
end

if size(indep_var, 1) < size(indep_var, 2)
    x  = indep_var'; % Flip it
else
    x = indep_var;
end

if size(dep_var, 1) < size(dep_var, 2)
    f  = dep_var'; % Flip it
else
    f = dep_var;
end

% Extract relevant data elements
n = max(size(indep_var));
dx = mean( diff(x) );%/(x(end)-x(1));

% Parameters
alpha = .000001;

% Set up differentiation and integration matricies
% Differentiation for our purposes
D = diag(2*ones(n,1)) + diag(-1*ones(n-2,1), -2) + diag(-1*ones(n-2,1), 2);
D(2,2) = D(2,2)/2;
D(end-1, end-1) = D(end-1, end-1)/2;
D = alpha/dx * D;
D(1,:) = zeros(size(D(1,:)));
D(end,:) = zeros(size(D(end,:)));
% Temporal Integration
K = tril(2*ones(n)) - diag(ones(n,1)) - [ones(n,1), zeros(n,n-1)];
K = dx/2 * K;
% Normalization contant for the position error
pn = 1/sum(dx*abs(f));% Normalize the position error

% Generate gradient
% D*u is the accel minimization portion, the rest is the integrand of
% u (a velocity) which is compared to the orginal data.  Note, the
% data is shifted so that first entry is zero.  It makes it easier to
% compare.
if false
    % Slow method
    f_grad = @(u) -D*u - .5*(2*K.'*K*u - 2*K.'*(f-f(1)) );
    % For use in:
    % u_new = f_grad(u_old) + u_old)
else
    % Pre-calculate the matricies for an in
    f_prime = pn^2 * K.'*(f-f(1));
    K_prime = eye(n) - D - pn^2*K.'*K;
%     f_grad = @(u) -K_prime*u + f_prime;
    % for use in:
    % u_new = K_prime * u_old + f_prime;
end

% Set up initial conditions
un = zeros(n,1);
progressbar % Create figure and set starting time
iter = 20000;
% figure(1000001)
% clf
% subplot(5,1,4)
% plot(f_prime)
for i=1:iter
%     subplot(5,1,1)
%     plot(un)
%     hold on
%     old_un = un;
%     subplot(5,1,2)
%     plot(-D*un)
%     hold on
%     subplot(5,1,3)
%     plot(-K.'*K*un)
%     hold on
%     subplot(5,1,5)
%     plot(K_prime * un + f_prime)
%     hold on
% 	un = f_grad(un) + un;
    un = K_prime * un + f_prime;
    progressbar(i/iter)
%     if any(isnan(un))
%        1; 
%     end
end

% return un
res = un;

end