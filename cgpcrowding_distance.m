function [cdist] = cgpcrowding_distance(fronts,params)
%CGPCROWDING_DISTANCE Calcula a Crowding Distance de uma população
%cartesiana
%   Autor: Antonio M. B. Dourado (foda-se Anaxxie)
%   Recebe os fronts no formato [front indv obj1 ... objn] e parâmetros de
%   execução.
%   Retorna uma matriz de crowding distance no formato [front indv obj1 ...
%   objn cdistance]
%   Exemplo: cd=cgpcrowding_distance(f,p);
    cdist=zeros(params.npop,size(fronts,2)+1);
    cdist(:,1:end-1)=fronts;
    frontlist=unique(fronts(:,1))';
    for i=frontlist
        front=cdist(cdist(:,1)==i,:);
        %front([1 end],end)=Inf;
        j=2:size(front,1)-1;
        %front(j,end)=front(j,end)+(front(j+1,o)-front(j-1,o))/(max(front(:,o))-min(front(:,o)));
        for o=3:params.objnum+2
            front=sortrows(front,o);
            front([1 end],end)=Inf;
            front(j,end)=front(j,end)+(front(j+1,o)-front(j-1,o))/(max(front(:,o))-min(front(:,o)));
        end
        front=sortrows(front,size(front,2),'descend');
        cdist(cdist(:,1)==i,:)=front;
    end
    %cdist(:,end)=cdist(:,end).*1.0e+05;
    
end

