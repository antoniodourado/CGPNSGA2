function [gvstr] = saveDotChromo(gt,params)
%SAVEDOTCHROMO Summary of this function goes here
%   Detailed explanation goes here
    s=[]; % começo de no
    t=[]; % fim de no
    
    % --- Constrói pares de comeco e fim de nós
    for i=params.gtsize:-1:1
        for j=1:i-1
            if(size(gt{i},2)<=1) % input ou output
                if(gt{i}==j)
                    s=[s j];
                    t=[t i];
                end
            elseif(ismember(j,gt{i}(1:2))) % intermediários
                s=[s j];
                t=[t i];
            end
        end
    end
    
    % --- Organiza os pares de começo e fim de nó
    [s,idx]=sort(s,'descend');
    t=t(idx); 
    slist=unique(s);
    nlist=1:params.gtsize-params.outputs;
    notused=setdiff(nlist,slist);    
    
    nsize=150;
    
    gvstr="digraph G {"+newline;
    gvstr=gvstr+"rankdir=LR;"+newline;
    gvstr=gvstr+"splines=splines;"+newline;
    gvstr=gvstr+"edge[style=invis];"+newline;
    gvstr=gvstr+"{"+newline;
    for i=1:size(gt,2)
        ndata=getNodeInfo(i,gt,params);
        if(i <= params.inputs.total)
            gvstr=gvstr+newline+int2str(i)+" [shape=circle,size="+nsize+",fontcolor=white,style=filled,fillcolor=blue,label="+ndata.opname+"];";
        elseif(i > params.gtsize-params.outputs)
            gvstr=gvstr+newline+int2str(i)+" [shape=circle,size="+nsize+",fontcolor=white,style=filled,fillcolor=black,label="+ndata.opname+"];";
        elseif(ismember(nlist(i),notused))
            gvstr=gvstr+newline+int2str(i)+" [shape=circle,size="+nsize+",fontcolor=white,style=filled,fillcolor=red,label="+ndata.opname+"];";
        else
            gvstr=gvstr+newline+int2str(i)+" [shape=circle,size="+nsize+",fontcolor=white,style=filled,fillcolor=green,label="+ndata.opname+"];";
        end
    end
    gvstr=gvstr+newline+"}";
    gvstr=gvstr+newline+"{";
    gvstr=gvstr+newline+"rank=source;";
    gvstr=gvstr+newline+"1";
    for i=2:params.inputs.total
        gvstr=gvstr+"->"+int2str(i);
    end
    gvstr=gvstr+";"+newline+"}";
    
    for i=params.inputs.total:params.graphH:params.gtsize-params.outputs-1
        gvstr=gvstr+newline+"{";
        gvstr=gvstr+newline+"rank=same;";
        gvstr=gvstr+newline+int2str(i+1);
        for j=2:params.graphH
            gvstr=gvstr+"->"+int2str(i+j);
        end
        gvstr=gvstr+";"+newline+"}";
    end
    
    gvstr=gvstr+newline+"{";
    gvstr=gvstr+newline+"rank=sink;";
    gvstr=gvstr+newline+int2str(params.gtsize-params.outputs+1);
    for i=params.gtsize-params.outputs+2:params.gtsize
        gvstr=gvstr+"->"+int2str(i);
    end
    gvstr=gvstr+";"+newline+"}";
    gvstr=gvstr+newline+"edge[style=solid, tailport=e, headport=w]";
    for i=1:size(s,2)
        gvstr=gvstr+newline+s(i)+"->"+t(i)+";";
    end
    gvstr=gvstr+newline+"}";
    fID=fopen('chromo.gv','w+');
    fprintf(fID,gvstr);
    fclose(fID);
    system('dot -Tpng -Gdpi=300 chromo.gv -o chromo.png');
end

