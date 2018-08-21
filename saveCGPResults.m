function saveCGPResults(cdist,fronts,results,pop,params,name)
%SAVECGPRESULTS Summary of this function goes here
%   Detailed explanation goes here
    cname=exist('name');
    if(cname==1)
        fname=name;
    else
        fname=sprintf('%s_%s_%s.mat',datestr(now,'yyyymmdd_HHMM'),params.inputs.colorscheme,params.trainmode);
    end
    disp(fname);
    save(fname,'cdist','fronts','params','pop','results');
end

