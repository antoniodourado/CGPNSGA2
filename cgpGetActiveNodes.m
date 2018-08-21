function [out] = cgpGetActiveNodes(nodeid,gt,params)
%CGPGETACTIVENODES Summary of this function goes here
%   Detailed explanation goes here
    node=gt{nodeid};
    if(nodeid <= params.inputs.total)
        out=(nodeid);
    elseif(nodeid <= params.gtsize-params.outputs)
        out=[cgpGetActiveNodes(node(1),gt,params) cgpGetActiveNodes(node(2),gt,params) nodeid];
    else
        out=[cgpGetActiveNodes(node,gt,params) nodeid];
    end
end