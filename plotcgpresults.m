function [f] = plotcgpresults(cf,pop,params,results)
%PLOTRESULTS Plota a população resultante da otimização.
%   Recebe como entrada:
%   1) Uma matriz com a otimização no formato: [front num_indiv obj1 ... objn crowd_dist]
%   2) Uma matriz contendo a população de cromossomos
%   3) Os parâmetros de execução do programa
%   4) Uma imagem de entrada para exibição de pontos individuais
f=figure('units','normalized','outerposition',[0 0 1 1]);
fcolors={'or' 'og' 'ob' 'ok' 'sr' 'sg' 'sb' 'sk' 'dr' 'dg' 'db' 'dk' 'xr' 'xg' 'xb' 'xk' '^r' '^g' '^r' '^r' 'pr' 'pg' 'pb' 'pk' 'hr' 'hg' 'hb' 'hk'};
cf=sortrows(cf(:,:),[1 3 4]);
fnum=size(unique(cf(:,1)),1);
fnum=min(fnum,params.maxfplot);
fnum=min(fnum,size(fcolors,2));
leg=zeros(fnum,1);
hold on
cf=cf(cf(:,1)<=fnum,:);
for i=1:fnum
    fdata=cf(cf(:,1)==i,:);
    for j=1:size(fdata,1)    
        plot(fdata(j,3),fdata(j,4),fcolors{i},'ButtonDownFcn',{@showCrom,pop,fdata(j,2),[fdata(j,3) fdata(j,4)]});
    end
    leg(i)=plot(NaN,NaN,fcolors{i},'DisplayName',sprintf('Front %d',i));
end
legend(leg);
xlabel('Obj1: Abs Diff Error')
ylabel('Obj2: Complexity')
%axis([min(cf(:,3))*0.8 max(cf(:,3))*1.05 0 max(cf(:,4))])
hold off
end

function showCrom(src, eventdata, pop,ind,objs)
  global params;
  h=figure('units','normalized','outerposition',[0 0 1 1]);
  subplot(2,2,1)
  if(isequal(params.trainmode,'multi'))
      params.inputs.input=params.inputs.inputarray{1};
      params.inputs.expout=params.inputs.expoutarray{1};
      params.plot.currpos=1;
  end
  imshow(params.inputs.input)
  title('Entrada');
  subplot(2,2,4)
  out=funcobj1rec(params.gtsize,pop(ind,:),params);
  if(isequal('strel',class(out)))
    imshow(out.Neighborhood)
  else
    imshow(out)
  end
  title('Saída');
  subplot(2,2,2,'ButtonDownFcn',{@drawCromCallback, rand(5,1)})
  imshow(params.inputs.expout);
  title('Saída Esperada');
  textcrom=char(cgpcrom2text(params.gtsize,pop(ind,:),params));
  n = 85;
  ns = numel(textcrom);
  if(ns > n)
      textcrom = cellstr(reshape([textcrom repmat(' ',1,ceil(ns/n)*n-ns)],n,[])')';
  end
  subplot(2,2,3)
  ax = gca;
  ax.Visible = 'off';
  strdesc="Indiv: "+int2str(ind)+" (Clique para ver o grafo)"+newline;
  for i=1:params.objnum
      strdesc=strdesc+"Obj."+int2str(i)+"("+params.objdesc{i}+"): "+num2str(objs(i))+newline;
  end
  
  t=text(0.4,0.5,strdesc,'FontSize',18);
  set(t,'ButtonDownFcn',{@drawCromCallback, pop(ind,:),params});
  %text(0.1,0.85-(size(textcrom,1)*0.1),textcrom,'FontSize',15)
  if(isequal(params.trainmode,'multi'))
    set(h,'KeyPressFcn',{@keyPressCallback,pop(ind,:),h});
  end
  
end

function drawCromCallback(src, eventdata, ind, params)
    figure(4);
    drawCGPChromo(ind,params);
end

function keyPressCallback(src, eventdata, gt,h)
    set(0,'CurrentFigure',h);
    global params;
    maxpos=size(params.inputs.inputarray,2);
    cpos=params.plot.currpos;
    if(isequal(eventdata.Key,'rightarrow') || isequal(eventdata.Key,'leftarrow'))
        if(isequal(eventdata.Key,'rightarrow'))
            if(cpos>=maxpos)
                cpos=1;
            else
                cpos=cpos+1;
            end
        elseif(isequal(eventdata.Key,'leftarrow'))
            if(cpos<=1)
                cpos=maxpos;
            else
                cpos=cpos-1;
            end
        end
        params.inputs.input=params.inputs.inputarray{cpos};
        params.inputs.expout=params.inputs.expoutarray{cpos};
        subplot(2,2,1);
        imshow(params.inputs.input)
        title('Entrada');
        subplot(2,2,2);
        imshow(params.inputs.expout);
        title('Saída Esperada');
        subplot(2,2,4)
        out=funcobj1rec(params.gtsize,gt,params);
        if(isequal('strel',class(out)))
          imshow(out.Neighborhood)
        else
          imshow(out)
        end
        title('Saída');
        params.plot.currpos=cpos;
    end
    if(isequal(eventdata.Key,'escape'))
        close(h);
    end
end