function [pop,results] = cgprepop(pop,cdist,results,params)
%CGPREPOP Summary of this function goes here
    %   Detailed explanation goes here
    fsize=round(params.npop*(params.tmut/100));
        
    for i=1:fsize
        popmat=cell2mat(pop(:,:));
        offspr=cgpmutate(pop(cdist(i,2),:),params);
        if(~ismember(cell2mat(offspr),popmat,'rows'))
            obj1=params.objf{1}(offspr,params);
            obj2=params.objf{2}(offspr,params);
            if((cdist(i,3) > obj1 && cdist(i,4) >= obj2) || ...
                    (cdist(i,3) >= obj1 && cdist(i,4) > obj2) || isequal(cdist(i,3:4),[obj1 obj2]))
                if((cdist(i,3) > obj1 && cdist(i,4) >= obj2) || (cdist(i,3) >= obj1 && cdist(i,4) > obj2))
                    fprintf('Parent: %f %f | Offspr: %f %f\n',cdist(i,3),cdist(i,4),obj1,obj2);
                end
                pop(cdist(i,2),:)=offspr;
                cdist(i,[3 4])=[obj1 obj2];
                results(cdist(i,2),[3 4])=[obj1 obj2];
            end
        end
    end    
    results=cdist(:,2:4);
    results=sortrows(results,1);
    
    
end

