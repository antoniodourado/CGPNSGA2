function [code,out] = generateCPPfromCGP(gt,nodeid)
%GENERATECPPFROMCGP Summary of this function goes here
%   Detailed explanation goes here
    global params;
    node=gt{nodeid};
    %disp(strcat(int2str(nodeid),':',32,mat2str(node)));
    if(nodeid == 1) %Se for um nó de imagem
        code="cv::Mat node"+int2str(nodeid)+"=inputimage.clone();"+newline;
        out=params.inputs.input;
    elseif(nodeid <= params.inputs.total) % Se for qualquer outro input
        out=params.inputs.strlist{node(1)};
        sen=out.Neighborhood;
        telem=numel(sen);
        [nrow,ncol]=size(sen);
        code="float node"+int2str(nodeid)+"_data["+int2str(telem)+"]={";
        for i=1:telem-1
            code=code+int2str(sen(i))+",";
        end
        code=code+int2str(sen(telem))+"};"+newline;
        code=code+"cv::Mat node"+int2str(nodeid)+"=cv::Mat("+int2str(nrow)+","+int2str(ncol)+",CV_32F,node"+int2str(nodeid)+"_data);"+newline;
        code=code+"node"+int2str(nodeid)+".convertTo("+"node"+int2str(nodeid)+",CV_8UC1);"+newline;
    elseif(nodeid <= params.gtsize-params.outputs) % Se for um nó intermediário
        % -- Processa função NOP, repassando para frente o primeiro input
        codex="cv::Mat node"+int2str(nodeid)+";"+newline;
        if(isequal(@nop,params.funcs{node(3)}))
            if(mod(nodeid,2)==1)
                [code,out]=generateCPPfromCGP(gt,node(1));
                code=code+codex+"node"+int2str(nodeid)+"=node"+int2str(node(1))+".clone();"+newline;
            else
                [code,out]=generateCPPfromCGP(gt,node(2));
                code=code+codex+"node"+int2str(nodeid)+"=node"+int2str(node(2))+".clone();"+newline;
            end
        % -- Processa função NOT para imagens BW
        elseif(isequal(@not,params.funcs{node(3)}))
            if(mod(nodeid,2))
                out=imcomplement(funcobj1rec(node(1),gt,params));
                code=generateCPPfromCGP(gt,node(1));
                code=code+"cv::Mat node"+int2str(nodeid)+"=cv::bitwise_not(node"+int2str(node(1))+",node"+int2str(node(1))+");"+newline;
            else
                out=imcomplement(funcobj1rec(node(2),gt,params));
                code=generateCPPfromCGP(gt,node(2));
                code=code+"cv::Mat node"+int2str(nodeid)+"=cv::bitwise_not(node"+int2str(node(2))+",node"+int2str(node(2))+");"+newline;
            end
        % -- Processa funções OR e AND para imagens BW
        % -- Processa funções ADD e SUB para imagens GRAY
        elseif(isequal(@or,params.funcs{node(3)}) || isequal(@and,params.funcs{node(3)}) || isequal(@add,params.funcs{node(3)}) || isequal(@sub,params.funcs{node(3)}))
            p1=funcobj1rec(node(1),gt,params);
            p2=funcobj1rec(node(2),gt,params);
            code1=generateCPPfromCGP(gt,node(1));
            code2=generateCPPfromCGP(gt,node(2));
            if(size(strfind(code1,"cv::Mat node"+int2str(node(1))+"="),1)>1)
                code1="";
            end
            if(size(strfind(code2,"cv::Mat node"+int2str(node(2))+"="),1)>1)
                code2="";
            end
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
                code1=code1+"cv::Mat node"+int2str(node(1))+"img=cstStrEl2Img(node"+int2str(node(1))+","+int2str(node(2))+");"+newline;
            elseif(isequal('strel',class(p2))) % Apenas a entrada 2 é strel
                p2=uint8(strel2img(p2,p1));
                code1=code1+"cv::Mat node"+int2str(node(2))+"img=cstStrEl2Img(node"+int2str(node(2))+","+int2str(node(1))+");"+newline;
            end
            code=code1+code2+newline;
            code=code+"cv::Mat node"+int2str(nodeid)+";"+newline;
            if(strels) % Se ambas as entradas forem strels, gera um novo strel resultando da operação entre eles
                if(isequal(@or,params.funcs{node(3)}) || isequal(@and,params.funcs{node(3)}))
                    out=strel('arbitrary',params.funcs{node(3)}(p1,p2));
                    if(isequal(@or,params.funcs{node(3)}))                        
                        code=code+"cv::bitwise_or(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                    else
                        code=code+"cv::bitwise_and(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                    end
                elseif(isequal(@add,params.funcs{node(3)}) || isequal(@sub,params.funcs{node(3)}))
                    out=strel('arbitrary',xor(p1,p2));
                    code=code+"cv::bitwise_xor(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                end
            else
                if(isequal(@or,params.funcs{node(3)}) || isequal(@and,params.funcs{node(3)}))
                    out=params.funcs{node(3)}(p1,p2);
                    if(isequal(@or,params.funcs{node(3)}))                        
                        code=code+"cv::bitwise_or(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                    else
                        code=code+"cv::bitwise_and(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                    end
                elseif(isequal(@sub,params.funcs{node(3)}))
                    out=p1-p2;
                    out(out < 0)=0;
                    code=code+"cv::subtract(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                    code=code+"node"+int2str(nodeid)+".setTo(cv::Scalar(0),node"+int2str(nodeid)+"<0);"+newline;
                elseif(isequal(@add,params.funcs{node(3)}))
                    out=p1+p2;
                    out(out > 255)=255;
                    code=code+"cv::sum(node"+int2str(node(1))+","+int2str(node(2))+",node"+int2str(nodeid)+");"+newline;
                    code=code+"node"+int2str(nodeid)+".setTo(cv::Scalar(255),node"+int2str(nodeid)+">255);"+newline;
                end                
            end
        else % -- Processa DILATAÇÃO E EROSÃO
            [p1,~,~]=funcobj1rec(node(1),gt,params);
            [p2,~,~]=funcobj1rec(node(2),gt,params);
            code1=generateCPPfromCGP(gt,node(1));
            code2=generateCPPfromCGP(gt,node(2));
            if(size(strfind(code1,"cv::Mat node"+int2str(node(1))+"="),1)>1)
                code1="";
            end
            if(size(strfind(code2,"cv::Mat node"+int2str(node(2))+"="),1)>1)
                code2="";
            end
            code=code1+code2;
            code=code+"cv::Mat node"+int2str(nodeid)+";"+newline;
            if(isequal('strel',class(p1)) && isequal('strel',class(p2))) % Aplica operação receba dois strels
                p1=p1.Neighborhood;
                p2=p2.Neighborhood;
                out=strel('arbitrary',params.funcs{node(3)}(p1,p2));
                if(isequal(@imdilate,params.funcs{node(3)}))
                    code=code+"cv::morphologyEx(node"+int2str(node(1))+",node"+int2str(nodeid)+",cv::MORPH_DILATE,node"+int2str(node(2))+");"+newline;
                elseif(isequal(@imerode,params.funcs{node(3)}))
                    code=code+"cv::morphologyEx(node"+int2str(node(1))+",node"+int2str(nodeid)+",cv::MORPH_ERODE,node"+int2str(node(2))+");"+newline;
                end
            elseif(isequal('strel',class(p1))) % -- Se primeira entrada for um strel, inverte a chamada
                out=params.funcs{node(3)}(p2,p1);
                if(isequal(@imdilate,params.funcs{node(3)}))
                    code=code+"cv::morphologyEx(node"+int2str(node(2))+",node"+int2str(nodeid)+",cv::MORPH_DILATE,node"+int2str(node(1))+");"+newline;
                elseif(isequal(@imerode,params.funcs{node(3)}))
                    code=code+"cv::morphologyEx(node"+int2str(node(2))+",node"+int2str(nodeid)+",cv::MORPH_ERODE,node"+int2str(node(1))+");"+newline;
                end
            elseif(isequal('strel',class(p2))) % Caso comum, primeira entrada imagem e segunda strel
                out=params.funcs{node(3)}(p1,p2);
                if(isequal(@imdilate,params.funcs{node(3)}))
                    code=code+"cv::morphologyEx(node"+int2str(node(1))+",node"+int2str(nodeid)+",cv::MORPH_DILATE,node"+int2str(node(2))+");"+newline;
                elseif(isequal(@imerode,params.funcs{node(3)}))
                    code=code+"cv::morphologyEx(node"+int2str(node(1))+",node"+int2str(nodeid)+",cv::MORPH_ERODE,node"+int2str(node(2))+");"+newline;
                end
            else
                if(mod(nodeid,2))
                    out=p1; % -- Caso AMBAS as entradas sejam imagens, repassa a primeira à frente se o nó for impar
                    code=code+"node"+int2str(nodeid)+"=node"+int2str(node(1))+";"+newline;
                else
                    out=p2; % -- Caso AMBAS as entradas sejam imagens, repassa a primeira à frente se o nó for par
                    code=code+"node"+int2str(nodeid)+"=node"+int2str(node(2))+";"+newline;
                end
            end
        end
    else % Se for um output
        [code,out]=generateCPPfromCGP(gt,node(1));
        code=code+"cv::Mat imgout=node"+int2str(node(1))+".clone();";
    end
end

