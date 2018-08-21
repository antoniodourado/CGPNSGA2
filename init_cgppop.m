function [pop] = init_cgppop(params)
%INIT_CGPPOP Summary of this function goes here
%   Detailed explanation goes here
    xnpop=params.xnpop*params.npop;
    xpop=cell(xnpop,params.gtsize);
    for i=1:xnpop
        xpop(i,:)=createCGPArray(params);
    end         
    [~,idx]=unique(cell2mat(xpop(:,:)),'rows','stable');
    if(size(idx,1) < params.npop)
        error('init_cpgpop could not generate the minimum amount of unique population individuals');
        return;
    end
    pop=xpop(1:params.npop,:);
end

