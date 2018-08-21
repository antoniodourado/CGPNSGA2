function params = init_params(varargin)
%INIT_PARAMS Inicializa os par�metros de execu��o
%   Tamanho total de inputs, quantidade de elemetos estruturantes nos
%   inputs, quantidade de elementos outputs, n�mero de n�s de largura e
%   altura etc.
%
%   EXEMPLO: params=init_params('parametro1',valor1,'parametro2,valor2, ... ,'parametroN',valorN)
%
%   Tipos de par�metros:
%   'addstrels' - adiciona array de c�lulas contendo elemetros estruturantes aos padr�es. Ex: {strel('square',3) strel('disk',5) strel('rectangle',[4 5]) ...}
%   'newstrels' - sobreescreve elementos estruturantes padr�o por novos passados em *addstrels*.
%   'lines' - n�mero de linhas que cada coluna ter�. Ex: 5. Padr�o 6.
%   'columns' - n�mero de colunas que cada linha ter�. Ex: 4. Padr�o 6.
%   'levelback' - quantidade de level-back de cada n�. Ex: 2. Padr�o 1.
%   'npop' - n�mero de indiv�duos da popula��o. Ex: 100. Padr�o 50.
%   'ngen' - n�mero de gera��es. Ex: 100. Padr�o 64.
%   'tmut' - taxa de muta��o. Padr�o 10(%).
%   'inputpath' - caminho absoluto para a imagem de entrada.
%   'expoutpath' - caminho absoluto para a imagem sa�da esperada.
%   'input' - imagem de entrada em forma de matriz.
%   'expout' - imagem sa�da esperada em forma de matriz.
%   'maxfplot' - m�ximo de fronts para plotagem. Ex: 5. Padr�o 20.
%   'colorscheme' - esquema de cores das imagens ('gray' ou 'bw'). Ex 'bw'. Padr�o 'gray'.
%   'error' - define tipo de erro entre 'corr' e 'mse'. Padr�o 'corr'.
%   'plotlines' - define se ser�o plotadas as linhas ligando os n�s ativos. Padr�o 'no'.
%   'uselogical' - define se fun��es l�gicas ser�o utilizadas. Padr�o 'no'.
%   'trainmode' - Tipo de treinamento. 'multi' define que m�ltiplas
%                   entradas e sa�das ser�o usadas para treinamento.
%                   'single' subentende apenas um par de images.
%   'inputarraypath' - Array de caminhos de imagens de entrada.
%   'expoutarraypath' - Array de caminhos de imagens experadas. Uma para
%                       cada entrada.
%   'inputarray' - Array de imagens de entrada j� carregadas.
%   'expoutarray' - Array de imagens de sa�da j� carregadas.


disp('Initializating parameters:');
p=inputParser;
%dinput=strcat(pwd,'/kinectinput.png'); % Imagem de entrada padr�o
%dout=strcat(pwd,'/kinectgt.png'); % Imagem de sa�da padr�o
dinput=strcat(pwd,'/kin1.png'); % Imagem de entrada padr�o
dout=strcat(pwd,'/kin1out.png'); % Imagem de sa�da padr�o
dH=6; dW=6; lb=-1; % Valor padr�o para linhas, colunas e level-back respectivamente.
dmut=10; %padr�o de muta��o
dstrel={};
for i=1:2:21
    dstrel=[dstrel {strel('square',i)}];
    dstrel=[dstrel {strel('disk',i)}];
    dstrel=[dstrel {strel('diamond',i)}];
    dstrel=[dstrel {strel('line',i,0)} {strel('line',i,45)} {strel('line',i,90)} {strel('line',i,135)}];
end
dpop=50; dgen=64; % Valor padr�o��o para popula��o e gera��es.
maxfplot=20; % M�ximo de fronteiras a serem plotadas.
cscheme='gray'; % Esquema de cores padr�o
derror='corr'; % erro padr�o
dplotlines='no'; % quantidade de fronts a serem plotados
duselogical='no'; % Usar l�gicos?
dtrainmode='multi'; % Modo de treino: multi = m�ltiplas imagens, single = unico par de imagens.
dinputarraypath={strcat(pwd,'/kin1.png') strcat(pwd,'/kin2.jpg') strcat(pwd,'/kin3.jpg') strcat(pwd,'/kin4.jpg') strcat(pwd,'/kin5.jpg') strcat(pwd,'/kin6.jpg')}; % array de caminhos de entrada padr�o.
dexpoutarraypath={strcat(pwd,'/kin1out.png') strcat(pwd,'/kin2out.jpg') strcat(pwd,'/kin3out.jpg') strcat(pwd,'/kin4out.jpg') strcat(pwd,'/kin5out.jpg') strcat(pwd,'/kin6out.jpg')}; % array de caminhos de sa�da esperada padr�o.
%dinputarraypath={strcat(pwd,'/4in.png') strcat(pwd,'/5in.png') strcat(pwd,'/6in.png') strcat(pwd,'/7in.png')};
%dexpoutarraypath={strcat(pwd,'/4out.png') strcat(pwd,'/5out.png') strcat(pwd,'/6out.png') strcat(pwd,'/7out.png')};
dautosave='no';
dautoplot='no';

% -- Elementos Estruturantes e Inputs
addOptional(p,'addstrels',dstrel);
addOptional(p,'newstrels','no');
addOptional(p,'lines',dH);
addOptional(p,'columns',dW);
addOptional(p,'levelback',lb);
addOptional(p,'npop',dpop);
addOptional(p,'ngen',dgen);
addOptional(p,'tmut',dmut);
addOptional(p,'inputpath',dinput);
addOptional(p,'expoutpath',dout);
addOptional(p,'input',-1);
addOptional(p,'expout',-1);
addOptional(p,'maxfplot',maxfplot);
addOptional(p,'colorscheme',cscheme);
addOptional(p,'error',derror);
addOptional(p,'plotlines',dplotlines);
addOptional(p,'uselogical',duselogical);
addOptional(p,'trainmode',dtrainmode);
addOptional(p,'inputarraypath',dinputarraypath);
addOptional(p,'expoutarraypath',dexpoutarraypath);
addOptional(p,'inputarray',-1);
addOptional(p,'expoutarray',-1);
addOptional(p,'autosave',dautosave);
addOptional(p,'autoplot',dautoplot);
parse(p,varargin{:});

global params;
% -- Esquema de cores da imagem (gray, bw)
params.inputs.colorscheme=p.Results.colorscheme;

params.plotlines=p.Results.plotlines; % Plotar� linhas entre n�s?
params.inputs.uselogical=p.Results.uselogical; % Utilizar� fun��es l�gicas?
params.plot.currpos=1;

% -- Fun��es
params.funcs={@imdilate @imerode @nop}; % Fun��es
params.funcstr={'dil' 'ero' 'nop'};

if(isequal('gray',params.inputs.colorscheme) && isequal('yes',params.inputs.uselogical))
    params.funcs=[params.funcs {@add} {@sub}];
    params.funcstr=[params.funcstr {'add'} {'sub'}];
elseif(isequal('yes',params.inputs.uselogical))
    params.funcs=[params.funcs {@and} {@or}];
    params.funcstr=[params.funcstr {'and'} {'or'}];
end


nstrel=p.Results.addstrels;
if(~isequal('yes',p.Results.newstrels)) % Adiciona novos elementos estrduturantes aos padr�o
    if(~isequal(p.Results.addstrels,dstrel))
        for i=1:size(nstrel,2)
            if(sum(cellfun(@(x) ismember(x,nstrel{i}),dstrel)) <= 0)
                dstrel=[dstrel nstrel(i)];
            end
        end
    end
    params.inputs.strlist=dstrel; % Elementos estruturantes
else % Usa apenas os elementos estruturantes passados por par�metros
    params.inputs.strlist=nstrel;
end
[~,params.inputs.strels]=size(params.inputs.strlist);

params.inputs.total=params.inputs.strels+1; % Nro total de entradas

disp('Loading images...');
% -- Caso tenha sido passado um caminho de entrada/saida ao inves de uma imagem,
%    le o arquivo do caminho passado
params.inputs.inputpath=p.Results.inputpath;
params.inputs.expoutpath=p.Results.expoutpath;
if(~isequal(p.Results.input,-1))
    params.inputs.input=p.Results.input;
    if(size(p.Results.input,3) > 1)
        params.inputs.input=rgb2gray(p.Results.input);
    end
    if(isequal('bw',params.inputs.colorscheme) && ~islogical(params.inputs.input))
        params.inputs.input=imbinarize(params.inputs.input);
    end
else
    params.inputs.input=imread(params.inputs.inputpath);
    if(size(params.inputs.input,3) > 1)
        params.inputs.input=rgb2gray(params.inputs.input);
    end
    if(isequal('bw',params.inputs.colorscheme) && ~islogical(params.inputs.input))
        params.inputs.input=imbinarize(params.inputs.input);
    end
end

if(~isequal(p.Results.expout,-1))
    params.inputs.expout=p.Results.expout;
    if(size(p.Results.expout,3) > 1)
        params.inputs.expout=rgb2gray(p.Results.expout);
    end
    if(isequal('bw',params.inputs.colorscheme) && ~islogical(params.inputs.expout))
        params.inputs.expout=imbinarize(params.inputs.expout);
    end
else
    params.inputs.expout=imread(params.inputs.expoutpath);
    if(size(params.inputs.expout,3) > 1)
        params.inputs.expout=rgb2gray(params.inputs.expout);
    end
    if(isequal('bw',params.inputs.colorscheme) && ~islogical(params.inputs.expout))
        params.inputs.expout=imbinarize(params.inputs.expout);
    end
end

params.trainmode=p.Results.trainmode;
if(isequal('multi',params.trainmode))
    params.inputs.inputarraypath=p.Results.inputarraypath;
    params.inputs.expoutarraypath=p.Results.expoutarraypath;
    if(~isequal(p.Results.inputarray,-1))
        params.inputs.inputarray=p.Results.inputarray;
    else
        inpaths=p.Results.inputarraypath;
        params.inputs.inputarray=cell(size(inpaths));
        for i=1:size(inpaths,2)
            params.inputs.inputarray{i}=imread(inpaths{i});
        end
    end
    for i=1:size(params.inputs.inputarray,2)
        if(size(params.inputs.inputarray{i},3)>1)
            params.inputs.inputarray{i}=rgb2gray(params.inputs.inputarray{i});
        end
        if(isequal('bw',params.inputs.colorscheme) && ~islogical(params.inputs.inputarray{i}))
            params.inputs.inputarray{i}=imbinarize(params.inputs.inputarray{i});
        end
    end
    if(~isequal(p.Results.expoutarray,-1))
        params.inputs.inputarray=p.Results.expoutarray;
    else
        outpaths=p.Results.expoutarraypath;
        params.inputs.expoutarray=cell(size(outpaths));
        for i=1:size(outpaths,2)
            params.inputs.expoutarray{i}=imread(outpaths{i});
        end
    end
    for i=1:size(params.inputs.expoutarray,2)
        if(size(params.inputs.expoutarray{i},3)>1)
            params.inputs.expoutarray{i}=rgb2gray(params.inputs.expoutarray{i});
        end
        if(isequal('bw',params.inputs.colorscheme)  && ~islogical(params.inputs.expoutarray{i}))
            params.inputs.expoutarray{i}=imbinarize(params.inputs.expoutarray{i});
        end
    end
end

disp('Done!');

% -- Quantidade de saidas
params.outputs=1;

% -- Estrutura Geral do Cromossomo
params.graphH=p.Results.lines; % Quantidade de linhas do cromossomo
params.graphW=p.Results.columns; % Quantidade de colunas do cromossomo
if(p.Results.levelback > 0)
    params.lback=p.Results.levelback; % Levels-back
else
    params.lback=params.graphW;
end
params.gtsize=params.graphW*params.graphH+params.inputs.total+params.outputs; % Quantidade de niveis / Tamanho do genotipo


% -- Fun��o de c�lculo do erro
params.errorfunc=p.Results.error;

% -- Funcoes de Objetivo
params.objf={@funcobj1b @funcobj2};
[~,params.objnum]=size(params.objf);
params.objdesc={params.errorfunc 'Complexidade'};

% -- Tamanho da populacao
params.npop=p.Results.npop;

% -- Multiplicado de gerador de populacao
params.xnpop=2;

% -- Quantidade de geracoes
params.ngen=p.Results.ngen;

% -- Percentual de mutacao
params.tmut=p.Results.tmut;

% -- max de fronts para plotagem
params.maxfplot=p.Results.maxfplot;

% -- salvar automaticamente o resultado
params.autosave=p.Results.autosave;

% -- plotar automaticamente o resultado
params.autoplot=p.Results.autoplot;

end

