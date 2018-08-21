function [fronts,dma] = cgpfronts(results,params)
%CGPFRONTS Summary of this function goes here
%   Detailed explanation goes here
    fronts=zeros(params.npop,2+params.objnum); % Colunas: [front indv obj1 ... objn]
    fronts(:,2:size(results,2)+1)=results;
    dma=zeros(params.npop+1,params.npop+1);
    i=1:params.npop;
    for j=i
        dma(i,j)= (results(i,2) < results(j,2) & results(i,3) <= results(j,3)) | (results(i,2) <= results(j,2) & results(i,3) < results(j,3));
        %dma(end,j)=sum(dma(:,j));
    end
    dma(end,i)=sum(dma(:,i));
    dmatot=unique(dma(end,1:end-1));
    for j=1:size(dmatot,2)
        fronts(dma(end,i)==dmatot(j))=j;
    end
    fronts=sortrows(fronts);
    
end

