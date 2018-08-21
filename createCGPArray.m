function ph = createCGPArray(params)
%CREATECGPARRAY Cria alatoriamente um cromossomo cartesiano.
%   Recebe os parâmetros de execução e retorna um cromossomo.
    ph=cell(1,params.gtsize);
    lvs=params.inputs.total:params.graphH:params.gtsize-params.outputs-1;
    lvs=[0 lvs];
    ph{1}=1;
    for i=2:params.inputs.total
        ph{i}=i-1;
    end
    for j=params.inputs.total:params.graphH:params.gtsize-params.outputs-1
        currLvl=find(lvs==j);
        if(currLvl==2)
            rg=1:j;
        else
            minLvl=max(1,currLvl-params.lback);
            rg=lvs(minLvl)+1:j;
        end
        for i=1:params.graphH
            randp=randperm(size(rg,2),2);
            if(currLvl == 2)
                ph{j+i}=[1,randi([2 params.inputs.total]),randi(size(params.funcs,2))];
            else
                %ph{j+i}=[rg(randp(1)),randi([2 params.inputs.total]),randi(size(params.funcs,2))];
                ph{j+i}=[rg(randp(1)),rg(randp(2)),randi(size(params.funcs,2))];
            end
        end
    end
    
    lvs=fliplr(lvs);
    
    for j=params.gtsize-params.outputs+1:params.gtsize
        ph{j}=randi([max(lvs(params.lback),1)+1 params.gtsize-params.outputs]);
    end
    
end

