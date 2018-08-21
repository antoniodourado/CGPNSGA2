function [s,t] = drawCGPChromo(gt,params)
%DRAWCGPCHROMO Plota o cromossomo cartesino
%   Recebe o cromossomo e os parâmetros do programa, plota o cromossomo e
%   retorna os arrays de começo e fim de nós.
    s=[]; % começo de no
    t=[]; % fim de no
    sx=[]; % coordenadas X dos nós
    sy=[]; % coordenadas Y dos nós
    
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
    
    % --- Posiciona nós de input
    for i=params.inputs.total:-1:1
        sx=[sx 1];
        sy=[sy i];
    end
    
    % --- Posiciona nós intermediários
    pos=2;
    if(params.graphH < params.inputs.total)
        maxH=params.inputs.total;
        stepN=params.inputs.total/params.graphH;
    else
        maxH=params.graphH;
        stepN=1;
    end
    for i=params.inputs.total+1:params.graphH:params.gtsize-params.outputs
        for j=maxH:-stepN:stepN
                sx=[sx pos];
                sy=[sy j];
        end
        pos=pos+1;
    end
    
    % --- Posiciona nós de output
    if(params.graphH > params.outputs)
        prevMaxH=maxH;
        maxH=maxH/(params.outputs+1)*params.outputs;
        stepO=floor(prevMaxH/(params.outputs+1));
    else
        maxH=params.gtsize;
        stepO=1;
    end
    for i=maxH:-stepO:params.outputs
        sx=[sx pos];
        %sy=[sy i-(params.gtsize-params.outputs)];
        sy=[sy i];
    end
        
    % --- Cria grafo direcionado e o plota
    g=digraph(s,t);
    h=plot(g,'XData',sx,'YData',sy);
        
    % -- Define cores para as linhas usadas e cinza para não usadas
    h.EdgeColor=repmat([1 1 1],size(s,2),1);
    if(isequal('yes',params.plotlines))
        for i=params.gtsize-params.outputs+1:1:params.gtsize
            h.EdgeColor=recolorActiveEdges(gt,i,h.EdgeColor,fliplr(s),fliplr(t),[1 0 0],params);
        end
    end
    
    if(isempty(h.NodeLabel))
        h.NodeLabel=cellstr(string(1:params.gtsize));
    end
    
    % -- Muda o tamanho do marker para 15
    h.MarkerSize=20;
    
    % -- Muda a cor dos nós para verde e verifica quais nós não-output são
    % terminais
    h.NodeColor=repmat([0 1 0] ,size(h.NodeLabel,2),1);
    slist=[];
    for i=params.gtsize-params.outputs+1:params.gtsize
        slist=[slist unique(cgpGetActiveNodes(gt{i},gt,params))];
    end
    nlist=1:params.gtsize-params.outputs;
    notused=setdiff(nlist,slist);
    
    % -- Aplica nome nos nós e muda a cor dos nós entre input, output e
    % não-output terminais
    for i=1:size(h.NodeLabel,2)
        %ndata=getNodeInfo(str2double(h.NodeLabel{i}),gt,params);
        h.NodeLabel{i}='';
        if(i <= params.inputs.total)
            h.NodeColor(i,:)=[0 0 1];
        elseif(i > params.gtsize-params.outputs)
            h.NodeColor(i,:)=[0 0 0];
        end
        if(ismember(i,notused))
            h.NodeColor(i,:)=[1 0 0];
        end
    end       
    
    set(h,'ButtonDownFcn',{@plotPartialNode,sx,sy,gt,params});
    
    gtlist="";
    for i=1:params.gtsize-params.outputs
        node=gt{i};
        if(i <= 1)
            gtlist=gtlist+sprintf('%i: Input',i); %gtlist+int2str(i)+": Input";
            text(sx(i)-0.05,sy(i),'Input','HorizontalAlignment', 'right');
            text(sx(i)+1/params.graphW,sy(i),int2str(i));
        elseif(i <= params.inputs.total)
            val=strel2text.getStrElFormated(params.inputs.strlist{node});
            text(sx(i)+1/params.graphW,sy(i),int2str(i));
            gtlist=gtlist+sprintf('%i: %s',i,val);  %gtlist+int2str(i)+": StrEl: "+strel2text.getStrElFormated(params.inputs.strlist{node});
            text(sx(i)-0.05,sy(i),val,'HorizontalAlignment', 'right');
        else
            text(sx(i)+1/params.graphW,sy(i)+stepN/params.graphH+(1+h.MarkerSize/100*(stepN/params.graphH)),params.funcstr{node(3)},'HorizontalAlignment', 'center','VerticalAlignment', 'bottom','Rotation',30);
            text(sx(i)+1/params.graphW,sy(i),int2str(i));
            text(sx(i)-1/params.graphW,sy(i),int2str(node(1)),'HorizontalAlignment', 'right','VerticalAlignment', 'bottom','FontSize',8);
            text(sx(i)-1/params.graphW,sy(i),int2str(node(2)),'HorizontalAlignment', 'right','VerticalAlignment', 'top','FontSize',8);
            gtlist=gtlist+sprintf('%i: %s\t%i\t%i',i,params.funcstr{node(3)},node(1),node(2)); %gtlist+int2str(i)+": "+params.funcstr{node(3)}+" \t "+node(1)+" "+node(2);
        end
        if(ismember(i,slist))
            gtlist=gtlist+" * "+newline;
        else
            gtlist=gtlist+newline;
        end
    end
    gtlist=gtlist+"Outputs:";
    for i=params.gtsize-params.outputs+1:params.gtsize
       node=gt{i};
       text(sx(i)+1/params.graphW,sy(i)+stepO/params.graphH,'Output','HorizontalAlignment', 'center','VerticalAlignment', 'bottom','Rotation',30);
       text(sx(i)+1/params.graphW,sy(i),int2str(i));
       text(sx(i)-1/params.graphW,sy(i),int2str(node(1)),'HorizontalAlignment', 'right','FontSize',8);
       gtlist=gtlist+" "+gt{i};
    end
    disp(gtlist);
    
   
end

function plotPartialNode(src, eventdata, sx, sy, gt, params)
    xyz=eventdata.IntersectionPoint;
    sxy=[sx;sy];
    nodeid=find(round(sxy(1,:),5)==round(xyz(1),5) & round(sxy(2,:),5)==round(xyz(2),5));
    partial=funcobj1rec(nodeid,gt,params);
    if(isequal('strel',class(partial)))
        partial=partial.Neighborhood;
    end
    figure(3);
    imshow(partial);
end