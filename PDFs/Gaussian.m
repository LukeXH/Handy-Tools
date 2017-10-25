classdef Gaussian < handle
    %This class produces a few different types of Gaussians, 1D & nD.
    %Normal, clipped, and folded
    
%   An Gaussian object can be created by passing the constructor the following:
%   Gaussian: assumed 1D, normal distribution, mean = 0, std = 1
%   Gaussian(u, s): A 1D normal distribution, mean = u, std = s
%   Gaussian(u, s, x): A 1D normal distribution, mean = u, std = s,
%       returns the value for the evaluation at x
%   Gaussian(u = nx1, s = nx1): A nD normal dist, mean = u, std = s
%   Gaussian(u = nx1, s = nx1, x = mx1): A nD normal dist, returns the
%       value for the evaluation for all the elements in vector x
%   Gaussian([], [], [], option): option is a string, defaulted to 'Normal'
%       that selects if the Gaussian is 'Normal', 'Clipped', or 'Folded'


    
    properties
        dim %Gaussian dimension
        u   %Gaussian mean
        s   %Gaussian standard deviation or covariance matrix
    end
    
    methods
        function this = Gaussian(varargin)
            switch nargin
                case 0
                    this.dim = 1;
                    this.u = 0;
                    this.s = 1;
                case 2  % No immediate evaluation
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
                case 3  % Immediate evaluation
                    u = varargin{1};
                    s = varargin{2};
                    x = varargin{3};
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
            %GAUSSIAN Construct an instance of this class
            %   Detailed explanation goes here
                otherwise
                    class(varargin)
                    size(varargin)
                    error('Unknown argument to Gaussian constructor of type and size listed above')
            end
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

