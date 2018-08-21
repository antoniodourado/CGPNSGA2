function [out] = cgpcrom2text(nodeid,gt,params)
%CGPCROM2TEXT Summary of this function goes here
%   Detailed explanation goes here
    node=gt{nodeid};
    %disp(strcat(int2str(nodeid),':',32,mat2str(node)));
    if(nodeid == 1) %Se for um nó de imagem
        out="input";
    elseif(nodeid <= params.inputs.total) % Se for qualquer outro input
        out=strel2text.getStrElFormated(params.inputs.strlist{gt{node(1)}});
    elseif(nodeid <= params.gtsize-params.outputs) % Se for um nó intermediário
        if(isequal(@nop,params.funcs{node(3)}))
            out=cgpcrom2text(node(1),gt,params);%+newline+int2str(nodeid)+": "+"nop";
        elseif(isequal(params.funcs{node(3)},@and) || isequal(params.funcs{node(3)},@or))
            out=cgpcrom2text(node(1),gt,params)+cgpcrom2text(node(2),gt,params)+newline+int2str(nodeid)+": "+params.funcstr{node(3)}+"("+int2str(node(1))+","+int2str(node(2))+")";
        elseif(isequal(params.funcs{node(3)},@not))
            out=cgpcrom2text(node(1),gt,params)+cgpcrom2text(node(2),gt,params)+newline+params.funcstr{node(3)}+"("+int2str(node(1))+")";
        else
            %{
            n1=int2str(node(1));
            n2=int2str(node(2));
            if(node(1) <= params.inputs.total)
                if(node(1) <= 1)
                    n1='input';
                else
                    %n1=strcat('StrEl',32,int2str(node(1)));
                    n1=strel2text.getStrElFormated(params.inputs.strlist{gt{node(1)-1}});
                end
            end
            if(node(2) <= params.inputs.total)
                if(node(1) <= 1)
                    n2='input';
                else
                    %n2=strcat('StrEl',32,int2str(node(2)));
                    n2=strel2text.getStrElFormated(params.inputs.strlist{gt{node(2)-1}});
                end
            end
            %}
            %out=cgpcrom2text(node(1),gt,params)+cgpcrom2text(node(2),gt,params)+newline+int2str(nodeid)+": "+strcat(params.funcstr{node(3)},'(',n1,',',n2,')');
            out=strcat(params.funcstr{node(3)},'(',cgpcrom2text(node(1),gt,params),',',cgpcrom2text(node(2),gt,params),')');
        end
    else % Se for um output
        out=cgpcrom2text(node(1),gt,params);
    end
end

