function [cdist,fronts,results,pop,params,tempo] = cgpnsga2(varargin)
%CGPNSGA2 Realiza a otimização multiobjetivo de filtros morfológicos com 2 objetivos. 
%   Objetivos:
%   a) Diferença absoluta entre entrada e saida esperada 
%   b) Complexidade dos elementos estruturantes
%   
%   EXEMPLO: cgpnsga2('parametro1',valor1,'parametro2,valor2, ... ,'parametroN',valorN)
%
%   Tipos de parâmetros:
%   'addstrels' - adiciona array de células contendo elemetros estruturantes aos padrões. Ex: {strel('square',3) strel('disk',5) strel('rectangle',[4 5]) ...}
%   'newstrels' - sobreescreve elementos estruturantes padrão por novos passados em *addstrels*.
%   'lines' - número de linhas que cada coluna terá. Ex: 5. Padrão 6.
%   'columns' - número de colunas que cada linha terá. Ex: 4. Padrão 6.
%   'levelback' - quantidade de level-back de cada nó. Ex: 2. Padrão 1.
%   'npop' - número de indivíduos da população. Ex: 100. Padrão 50.
%   'ngen' - número de gerações. Ex: 100. Padrão 64.
%   'inputpath' - caminho absoluto para a imagem de entrada.
%   'expoutpath' - caminho absoluto para a imagem saída esperada.
%   'input' - imagem de entrada em forma de matriz.
%   'expout' - imagem saída esperada em forma de matriz.
%   'maxfplot' - máximo de fronts para plotagem. Ex: 5. Padrão 20.
%   'colorscheme' - esquema de cores das imagens ('gray' ou 'bw'). Ex 'bw'. Padrão 'gray'.
%   'error' - define tipo de erro entre 'corr' e 'mse'. Padrão 'corr'.
%   'plotlines' - define se serão plotadas as linhas ligando os nós ativos. Padrão 'no'.
%   'uselogical' - define se funções lógicas serão utilizadas. Padrão 'no'.
%   'trainmode' - Tipo de treinamento. 'multi' define que múltiplas
%                   entradas e saídas serão usadas para treinamento.
%                   'single' subentende apenas um par de images.
%   'inputarraypath' - Array de caminhos de imagens de entrada.
%   'expoutarraypath' - Array de caminhos de imagens experadas. Uma para
%                       cada entrada.
%   'inputarray' - Array de imagens de entrada já carregadas.
%   'expoutarray' - Array de imagens de saída já carregadas.
%
%   Exemplos de chamadas:
%   cgpnsga2
%   cgpnsga2('ngen',25,'npop',500,'levelback',2,'lines',10,'columns',10,'maxfplot',2)
%   cgpnsga2('ngen',50,'npop',250,'levelback',2,'lines',10,'columns',10,'maxfplot',2)
%   cgpnsga2('ngen',100,'npop',125,'levelback',2,'lines',10,'columns',10,'maxfplot',2)
%   cgpnsga2('ngen',1000,'npop',25,'levelback',2,'lines',10,'columns',10,'maxfplot',2)
%
%   cgpnsga2('colorscheme','bw','input',in1,'expout',expout1,'ngen',1000,'columns',8,'lines',10,'levelback',2)
    clear params cdist pop results fronts;
    tic;
    params=init_params(varargin{:});
    disp('Creating intial population');
    pop=init_cgppop(params);
    gen=1;
    disp('Calculating initial results');
    results=calculateObjFuns(pop,params);
    while(gen <= params.ngen)
        disp(strcat('Generation',32,int2str(gen),'/',int2str(params.ngen)));
        fronts=cgpfronts(results,params);
        cdist=cgpcrowding_distance(fronts,params);
        if(gen < params.ngen)
            [pop,results]=cgprepop(pop,cdist,results,params);
        end
        gen=gen+1;
    end
    %cdist(:,4)=(sqrt(cdist(:,4))-min(cdist(:,4)))./(max((sqrt(cdist(:,4))-min(cdist(:,4)))));
    tempo=toc;
    assignin('base','cdist',cdist);
    assignin('base','pop',pop);
    assignin('base','params',params);
    assignin('base','results',results);
    assignin('base','fronts',fronts);
    if(isequal(params.autosave,'yes'))
        saveCGPResults(cdist,fronts,results,pop,params);
    end
    if(isequal(params.autoplot,'yes'))
        plotcgpresults(cdist,pop,params,results);
    end
end

%demoresults=[1 10 2; 2 10 1; 3 6 3; 4 7 4; 5 3 7; 6 2 2; 7 4 8; 8 1 2; 9 2 4; 10 2 3; 11 1 10; 12 1 9];
%params.npop=12; results=demoresults;