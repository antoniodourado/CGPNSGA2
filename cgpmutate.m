function [gt] = cgpmutate(indv,params)
%CGPMUTATE Faz a mutação de um indivíduo
%   Recebe o indivíduo e os parâmetros de execução.
%   Ex: output=cgpmutate(pop(N,:),params)
    lvs=params.inputs.total:params.graphH:params.gtsize-params.outputs-1;
    gt=indv;
    gtpos=params.inputs.total+1:params.gtsize;
    nmut=round(numel(gtpos)*(params.tmut/100));
    
    genes=gtpos(randperm(size(gtpos,2),nmut));
    for i=1:nmut
        rgene=genes(i);
        allele=randi(3);
        if(rgene <= params.inputs.total+params.graphH+1) %Caso seja da primeira coluna, pode modificar apenas alelos 2 ou 3
            if(allele <= 2)
                gt{rgene}(2)=randi(params.inputs.total);
            else
                gt{rgene}(3)=randi(size(params.funcs,2));
            end
            return;
        elseif(rgene > params.gtsize-params.outputs)
            gt{rgene}=randi([lvs(max(1,sum(lvs < rgene)-params.lback))+1 lvs(sum(lvs < rgene))]);
        else
            if(allele <= 2)
                gt{rgene}(1)=randi([lvs(max(1,sum(lvs < rgene)-params.lback))+1 lvs(sum(lvs < rgene))]);
            else
                gt{rgene}(3)=randi(size(params.funcs,2));
            end
        end
    end
end

