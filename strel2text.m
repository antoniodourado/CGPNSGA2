classdef strel2text < strel
    %STREL2TEXT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sel;
    end
    
    methods
        function obj = strel2text(se)
            %STREL2TEXT Construct an instance of this class
            %   Detailed explanation goes here
            obj.sel = strel(se);
        end
        
    end
    
    methods(Static)
        
        function shape = getStrElShape(se)
            shape=se.Type;
        end
        
        function fs = getStrElFormated(se)
            nb=se.Neighborhood;
            sz=size(nb);
            shape=se.Type;
            switch shape
                case 'square'
                    fs=int2str(sz(1))+"x"+int2str(sz(2));
                case 'rectangle'
                    fs=int2str(sz(1))+"x"+int2str(sz(2));
                case 'disk'
                    rad=ceil(sz(1)/2);
                    napr=sum(nb(:,1));
                    fs=int2str(rad)+","+int2str(napr);
                case 'diamond'
                    fs=int2str(ceil(sz(1)/2));
                case 'octagon'
                    fs=int2str(ceil(sz(1)/2));
                case 'sphere'
                    fs=int2str(ceil(sz(1)/2));
                case 'line'
                    if(sz(1) <= 1)
                        dg=0;
                        sze=round(sz(2)-(sz(2)*(pi/180)));
                    elseif(sz(2) <= 1)
                        dg=90;
                        sze=round(sz(1)-(sz(1)*(pi/180)));
                    else
                        if(isequal(nb,logical(eye(sz(1)))))
                            dg=135;
                        else
                            dg=45;
                        end
                        sze=floor((sz(2)+ceil(sz(2)/2))-((sz(1)+ceil(sz(2)/2))*(pi/180)));
                    end
                    fs=int2str(sze)+","+int2str(dg);
                otherwise
                    fs=int2str(sz(1));
                    for i=2:size(sz,2)
                        fs=fs+"x"+int2str(sz(i));
                    end
            end
            fs=shape+"("+fs+")";
        end
        
    end
    
end

