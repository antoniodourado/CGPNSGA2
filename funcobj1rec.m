function [out,sumel,n] = funcobj1rec(nodeid,gt,params)
%FUNCOBJ1REC Processa recursivamente o cromossomo.
%   Detailed explanation goes here
    node=gt{nodeid};
    %disp(strcat(int2str(nodeid),':',32,mat2str(node)));
    if(nodeid == 1) %Se for um nó de imagem
        out=params.inputs.input;
        sumel=0;
        n=0;
    elseif(nodeid <= params.inputs.total) % Se for qualquer outro input
        out=params.inputs.strlist{node(1)};
        sumel=sum(sum(out.Neighborhood));
        n=1;
    elseif(nodeid <= params.gtsize-params.outputs) % Se for um nó intermediário
        % -- Processa função NOP, repassando para frente o primeiro input
        if(isequal(@nop,params.funcs{node(3)}))
            if(mod(nodeid,2)==1)
                [out,sumel,n]=funcobj1rec(node(1),gt,params);
            else
                [out,sumel,n]=funcobj1rec(node(2),gt,params);
            end
        % -- Processa função NOT para imagens BW
        elseif(isequal(@not,params.funcs{node(3)}))
            if(mod(nodeid,2)==1)
                [out,sumel,n]=funcobj1rec(node(1),gt,params);
            else
                [out,sumel,n]=funcobj1rec(node(2),gt,params);
            end
            out=imcomplement(out);
        % -- Processa funções OR e AND para imagens BW
        % -- Processa funções ADD e SUB para imagens GRAY
        elseif(isequal(@or,params.funcs{node(3)}) || isequal(@and,params.funcs{node(3)}) || isequal(@add,params.funcs{node(3)}) || isequal(@sub,params.funcs{node(3)}))
            [p1,sumel1,n1]=funcobj1rec(node(1),gt,params);
            [p2,sumel2,n2]=funcobj1rec(node(2),gt,params);
            strels=0;
            if(isequal('strel',class(p1)) && isequal('strel',class(p2))) %Duas entradas como STRELS
                strels=1;
                if(~isequal(size(p1.Neighborhood),size(p2.Neighborhood))) % Verifica se o tamanho dos strels são diferentes
                    if(sum(size(p1.Neighborhood))>sum(size(p2.Neighborhood)))
                        p2=uint8(strel2img(p2,p1.Neighborhood));
                        p1=p1.Neighborhood;
                    else
                        p1=uint8(strel2img(p1,p2.Neighborhood));
                        p2=p2.Neighborhood;
                    end
                else
                    p1=p1.Neighborhood;
                    p2=p2.Neighborhood;
                end
            elseif(isequal('strel',class(p1))) % Apenas a entrada 1 é strel
                p1=uint8(strel2img(p1,p2));
                sumel=sumel1+sumel2+sum(sum(p1.Neighborhood));
                n=n1+n2+1;
            elseif(isequal('strel',class(p2))) % Apenas a entrada 2 é strel
                p2=uint8(strel2img(p2,p1));
                sumel=sumel1+sumel2+sum(sum(p2.Neighborhood));
                n=n1+n2+1;
            end
            if(strels) % Se ambas as entradas forem strels, gera um novo strel resultando da operação entre eles
                sumel=sumel1+sumel2+sum(sum(p1.Neighborhood))+sum(sum(p2.Neighborhood));
                n=n1+n2+2;
                if(isequal(@or,params.funcs{node(3)}) || isequal(@and,params.funcs{node(3)}))
                    out=strel('arbitrary',params.funcs{node(3)}(p1,p2));
                elseif(isequal(@add,params.funcs{node(3)}) || isequal(@sub,params.funcs{node(3)}))
                    out=strel('arbitrary',xor(p1,p2));
                end
            else
                if(isequal(@or,params.funcs{node(3)}) || isequal(@and,params.funcs{node(3)}))
                    out=params.funcs{node(3)}(p1,p2);
                elseif(isequal(@add,params.funcs{node(3)}))
                    out=p1-p2;
                    out(out < 0)=0;
                elseif(isequal(@sub,params.funcs{node(3)}))
                    out=p1+p2;
                    out(out > 255)=255;
                end                
            end
        else % -- Processa DILATAÇÃO E EROSÃO
            [p1,sumel1,n1]=funcobj1rec(node(1),gt,params);
            [p2,sumel2,n2]=funcobj1rec(node(2),gt,params);
            if(isequal('strel',class(p1)) && isequal('strel',class(p2))) % Aplica operação receba dois strels
                p1=p1.Neighborhood;
                p2=p2.Neighborhood;
                out=strel('arbitrary',params.funcs{node(3)}(p1,p2));
                sumel=sumel1+sumel2+sum(sum(p1))+sum(sum(p2));
                n=n1+n2+2;
            elseif(isequal('strel',class(p1))) % -- Se primeira entrada for um strel, inverte a chamada
                %t=p2;
                %p2=p1;
                %p1=t;
                out=params.funcs{node(3)}(p2,p1);
                sumel=sumel1+sumel2+sum(sum(p1.Neighborhood));
                n=n1+n2+1;
            elseif(isequal('strel',class(p2))) % Caso comum, primeira entrada imagem e segunda strel
                out=params.funcs{node(3)}(p1,p2);
                sumel=sumel1+sumel2+sum(sum(p2.Neighborhood));
                n=n1+n2+1;
            else
                if(mod(nodeid,2))
                    out=p1; % -- Caso AMBAS as entradas sejam imagens, repassa a primeira à frente se o nó for impar
                else
                    out=p2; % -- Caso AMBAS as entradas sejam imagens, repassa a primeira à frente se o nó for par
                end
                sumel=sumel1+sumel2;
                n=n1+n2;
            end
        end
    else % Se for um output
        [out,sumel,n]=funcobj1rec(node(1),gt,params);
    end
end

