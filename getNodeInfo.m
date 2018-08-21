function [nodeInfo] = getNodeInfo(nodeId,gt,params)
%GETNODEINFO Re�ne informa��es sobre um �nico n� do cromossomo
%   Recebe a posi��o do n�, o gen�tipo completo e os par�metros de exeu��o.
%   Retorna uma estrutura com as principais informa��es do n�.
    phcell=gt{nodeId};
    if(nodeId <= 1)
        nodeInfo.opname='Input';
    elseif(nodeId <= params.inputs.total)
        nodeInfo.opname=char(strel2text.getStrElFormated(params.inputs.strlist{phcell}));
    elseif(nodeId > params.gtsize-params.outputs)
        nodeInfo.opname=strcat('O',int2str(nodeId-(params.gtsize-params.outputs)));
    else
        nodeInfo.opname=strcat(params.funcstr{phcell(end)},'_',int2str(nodeId));
    end
end

