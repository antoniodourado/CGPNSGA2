function [out] = funcobj1(gt,params)
%FUNCOBJ1 Calcula a diferença absoluta entre o cromossomo e o resultado
%esperado.
%   Detailed explanation goes here
    out=funcobj1rec(params.gtsize,gt,params);
    if(isequal('strel',class(out)))
        out=Inf;
    else
        if(isequal(params.inputs.colorscheme,'gray'))
            tblack=1+(sum(out(:)==0)/numel(out));
            if(isequal('corr',params.errorfunc))
                if(isnan(out))
                    out=1*tblack;
                else
                    %out=(1-corr2(out,params.inputs.expout))*tblack;
                    out=(1-mean(mean(corrcoef(im2double(out),im2double(params.inputs.expout)))))*tblack;
                end
            else
                out=immse(params.inputs.expout,out);
            end
        else
            if(isequal('corr',params.errorfunc))
                out=(1-mean(mean(corrcoef(im2double(out),im2double(params.inputs.expout)))));
            elseif(isequal('absdiff',params.errorfunc))
                out=sum(sum(imabsdiff(params.inputs.expout,out)));
            end
        end
    end
end