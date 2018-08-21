function [fdname] = runCGPTests(ngens,npops,ncols,nlines,tmuts,name)
%RUNCGPTESTS Summary of this function goes here
%   Detailed explanation goes here
    if(exist('name'))
        fdname=sprintf('%s_%s',datestr(now,'yyyymmdd_HHMM'),name);
    else
        fdname=sprintf('%s',datestr(now,'yyyymmdd_HHMM'));
    end
    if(exist(fdname,'dir'))
        error('Folder with same name.');        
    end
   
    disp('Creating test subfolder');
    mkdir(fdname);
    for i=1:numel(ngens)
        ngen=ngens(i);
        for j=1:numel(npops)
            npop=npops(j);
            for c=1:numel(ncols)
                cols=ncols(c);
                for l=1:numel(nlines)
                    lines=nlines(l);
                    for m=1:numel(tmuts)
                        tmut=tmuts(m);
                        [cdist,fronts,results,pop,params,tempo]=cgpnsga2('ngen',ngen,'npop',npop,'columns',cols,'lines',lines,'tmut',tmut);
                        fname=sprintf('%igens_%ipop_%icols_%ilin_%itmut_%s.mat',ngen,npop,cols,lines,tmut,fdname);
                        save(fullfile(fdname,fname),'cdist','fronts','params','pop','results');                        
                    end
                end
            end
        end
    end
    
    
end

