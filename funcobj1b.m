function [out] = funcobj1b(gt,params)
%FUNCOBJ1B Calcula o tradeoff entre especificidade e suavidade
%   Detailed explanation goes here
    if(isequal('multi',params.trainmode))
        sout=0;
        scount=size(params.inputs.inputarray,2);
        for i=1:size(params.inputs.inputarray,2)
            params.inputs.input=params.inputs.inputarray{i};
            params.inputs.expout=params.inputs.expoutarray{i};
            out=funcobj1rec(params.gtsize,gt,params);
            if(isequal('strel',class(out)))
                sout=sout+Inf;
            else
                if(isequal(params.inputs.colorscheme,'gray'))
                    eout=params.inputs.expout;
                    [TP,TN,FP,FN]=calcPositivesNegatives(out,eout);
                    SV=max(0,TP/(TP+FN));
                    SP=max(0,TN/(TN+FP));
                    cc=corrcoef(im2double(out),im2double(params.inputs.expout));
                    cc(1,1)=1;
                    cc(2,2)=1;
                    cc=max(0,cc);
                    nout=sqrt((1-SP)^2+(1-SV)^2)/sqrt(2)+(1-mean([cc(1,2) cc(2,1)]));
                    tb=sum(out(:)==0);
                    tel=numel(out);
                    if(tb > 0)
                        sout=sout+nout*(1+tb/tel);
                    else
                        sout=sout+nout;
                    end
                else
                    eout=params.inputs.expout;
                    [TP,TN,FP,FN]=calcPositivesNegatives(out,eout);
                    SV=TP/(TP+FN);
                    SP=TN/(TN+FP);
                    cc=corrcoef(im2double(out),im2double(params.inputs.expout));
                    sout=sout+sqrt((1-SP)^2+(1-SV)^2)/sqrt(2)+(1-mean([cc(1,2) cc(2,1)]));
                end
            end
            out=sout/scount;
        end
    else
       out=funcobj1rec(params.gtsize,gt,params);
        if(isequal('strel',class(out)))
            out=Inf;
        else
            if(isequal(params.inputs.colorscheme,'gray'))
                eout=params.inputs.expout;
                [TP,TN,FP,FN]=calcPositivesNegatives(out,eout);
                SV=TP/(TP+FN);
                SP=TN/(TN+FP);
                cc=corrcoef(im2double(out),im2double(params.inputs.expout));
                nout=sqrt((1-SP)^2+(1-SV)^2)/sqrt(2)+(1-mean([cc(1,2) cc(2,1)]));
                tb=sum(out(:)==0);
                tel=numel(out);
                if(tb > 0)
                    out=nout*(1+tb/tel);w
                else
                    out=nout;
                end
            else
                eout=params.inputs.expout;
                [TP,TN,FP,FN]=calcPositivesNegatives(out,eout);
                SV=TP/(TP+FN);
                SP=TN/(TN+FP);
                cc=corrcoef(im2double(out),im2double(params.inputs.expout));
                out=sqrt((1-SP)^2+(1-SV)^2)/sqrt(2)+(1-mean([cc(1,2) cc(2,1)]));
            end
        end 
    end
end