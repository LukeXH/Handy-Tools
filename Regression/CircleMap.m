classdef CircleMap
    %CIRCLEMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        a   % X displacement
        b   % Y displacement
        r   % radius of circle
        
        unit_circle_xy
    end
    
    methods
        function this = CircleMap() % Constructor
            this.unit_circle_xy = [cos( (0:10:360)*pi/180 )', sin( (0:10:360)*pi/180 )'];
        end
        
        function this = regressCircle(this, xy_data)
           params = CircleFitByPratt(xy_data);
           this.a = params(1);
           this.b = params(2);
           this.r = params(3);
        end
        
        function this = setParams(this, x_center, y_center, radius)
            this.a = x_center;
            this.b = y_center;
            this.r = radius;
            
        end
        
        function [x_center,y_center,radius] = getParams(this)
           x_center = this.a;
           y_center = this.b;
           radius = this.r;
        end
        
        function circle_xy = genCircle(this)
            circle_xy = [this.r * this.unit_circle_xy(:,1) + this.a,...
                         this.r * this.unit_circle_xy(:,2) + this.b];
        end
        
        function fit_xy_pts = fitData(this, xy_data)
            th = atan2(xy_data(:,2) - this.b, xy_data(:,1) - this.a);
            fit_xy_pts = [(this.r * cos(th) + this.a)',
                          (this.r * sin(th) + this.b)']';
        end
        
        function [fit_xy_pts, this] = regressAndFit(this, xy_data)
            this = this.regressCircle(xy_data);
            fit_xy_pts = this.fitData(xy_data);
        end
        
        function [fit_xy_pts, this] = setAndFit(this, params, xy_data)
            % params of for [a,b,r]
            this =  this.setParams(params(1), params(2), params(3));
            fit_xy_pts = this.fitData(xy_data);
        end
    end
    
end

