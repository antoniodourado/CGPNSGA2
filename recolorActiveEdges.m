function [edgecolor] = recolorActiveEdges(gt,id,edgecolor,s,t,c,params)
%RECOLORACTIVEEDGES Summary of this function goes here
%   Detailed explanation goes here
    if(id <= params.inputs.total)
        return;
    elseif(id > params.gtsize-params.outputs)
        edgecolor=recolorActiveEdges(gt,gt{id},edgecolor,s,t,c,params);
        edgecolor(t==id,:)=c;
    else
        node=gt{id};
        edgecolor=recolorActiveEdges(gt,node(1),edgecolor,s,t,c,params);
        edgecolor=recolorActiveEdges(gt,node(2),edgecolor,s,t,c,params);
        edgecolor(t==id,:)=repmat(c,size(edgecolor(t==id,:),1),1);
    end
        
end

