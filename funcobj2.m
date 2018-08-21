function [out] = funcobj2(gt,params)
%FUNCOBJ2 Summary of this function goes here
%   Detailed explanation goes here
    [~,mulel,sumel,n]=funcobj2rec(params.gtsize,gt,params);
    %out=round(sumel/n);
    %out=round(sqrt(sumel),2);
    out=mulel;
    if(out==0)
        disp('asdasd');
    end
end

