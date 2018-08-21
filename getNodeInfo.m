function [nodeInfo] = getNodeInfo(nodeId,gt,params)
%GETNODEINFO Reúne informações sobre um único nó do cromossomo
%   Recebe a posição do nó, o genótipo completo e os parâmetros de exeução.
%   Retorna uma estrutura com as principais informações do nó.
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

