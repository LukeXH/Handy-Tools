classdef Gaussian < handle
    %This class produces a few different types of Gaussians, 1D & nD.
    %Normal, clipped, and folded
    
%   An Gaussian object can be created by passing the constructor the following:
%   Gaussian: assumed 1D, normal distribution, mean = 0, std = 1
%   Gaussian(u, s): A 1D normal distribution, mean = u, std = s
%   Gaussian(u = nx1, s = nx1): A nD normal dist, mean = u, std = s
%   Gaussian([], [], option): option is a string, defaulted to 'Normal'
%       that selects if the Gaussian is 'Normal', 'Clipped', or 'Folded'

%    Gaussian(u, s, x): A 1D normal distribution, mean = u, std = s,
%       returns the value for the evaluation at x
%   Gaussian(u = nx1, s = nx1, x = mx1): A nD normal dist, returns the
%       value for the evaluation for all the elements in vector x
    
    properties (Access = protected) %Constants
        allowed_types = {'Normal', 'Clipped', 'Folded'}
        s_clipped
    end
    properties
        dim %Gaussian dimension
        u   %Gaussian mean
        s   %Gaussian standard deviation or covariance matrix
        distribution_type % What type of distribution
    end
    
    methods
        function this = Gaussian(varargin)
            if nargin == 0 % Default
                this.dim = 1;
                this.u = 0;
                this.s = 1;
                this.distribution_type = 'Normal';
            elseif nargin >=2
                u = varargin{1};
                s = varargin{2};
                if max(size(u)) == 1 && max(size(s)) == 1 % 1D case
                   this.dim = 1;
                   this.u = u;
                   this.s = s;
                elseif size(u,1) > 1 && size(s,1) > 1 && size(u,1) == size(s,1) && size(s,1) == size(s,2)
                    this.dim = size(u,1);
                    this.u = u;
                    this.s = s;
                elseif size(u,2) > 1 && size(s,1) > 1 && size(u,2) == size(s,1) && size(s,1) == size(s,2)
                    this.dim = size(u,2);
                    this.u = u.';    % Flip vertical
                    this.s = s.';    % Flip vertical
                else
                    error('Dimension mismatch on inputs')
                end
                
                % Set distribution type
                if nargin == 3
                    tmp = zeros(1,3) == 1;
                    for i=1:size(this.allowed_types,2)
                        tmp(i) = strcmp(varargin{3}, this.allowed_types{i});
                    end
                    if ~any(tmp)
                       error('Incorrect distribution type.  Options are Normal, Clipped, Folded.') 
                    end
                    this.distribution_type = varargin{3};
                else
                    this.distribution_type = 'Normal';
                end
                
            else % Error Case
                class(varargin)
                size(varargin)
                error('Unknown argument to Gaussian constructor of type and size listed above')
            end% End if 
        end
        
        function p = analytical_eval_normal(this, x)
           % Analytical evaluation of the equation
           if this.dim == 1
               p = 1/sqrt(2*pi*this.s) * exp(-(x-this.u).^2./(2*this.s)^2);
           elseif this.dim >= 1
               err = (x-this.u);
               p = 1/((2*pi)^this.dim/2*sqrt(det(this.s))) * exp(-.5*err.'*this.s*err);
           end
        end
        
        function calculate_s_clipped
            
        end
        
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

