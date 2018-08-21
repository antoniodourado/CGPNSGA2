function [out] = cgpcalcdiversity(pop,params,mode)
%CGPCALCDIVERSITY Summary of this function goes here
%   Detailed explanation goes here
    j=params.inputs.total+1:params.gtsize;
    popmat=cell2mat(pop);
    popmat=popmat(:,j);
    if(isequal('entropy',mode))
        out=ones(max(j)-params.inputs.total,1);
        for i=1:max(j)-params.inputs.total
            out(i)=entropy(popmat(:,i)./norm(popmat(:,i)));
        end    
    end
end

