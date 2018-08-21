function [results] = calculateObjFuns(pop,params)
%CALCULATEOBJFUNS Summary of this function goes here
%   Detailed explanation goes here
    results=zeros(params.npop,1+params.objnum);
    i=1:params.npop;
    results(:,1)=i;    
    for i=1:params.npop
        for j=1:params.objnum
            results(i,j+1)=params.objf{j}(pop(i,:),params);
        end
    end
end

