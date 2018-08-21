function [TP,TN,FP,FN] = calcPositivesNegatives(out,expout)
%CALCPOSITIVESNEGATIVES Summary of this function goes here
%   Detailed explanation goes here
    FP=0; TP=0; FN=0; TN=0;
    for i=1:numel(out(:))
        FP=FP+(out(i)==0 && expout(i)>0);
        TP=TP+(out(i)>0 && expout(i)>0);
        FN=FN+(out(i)>0 && expout(i)==0);
        TN=TN+(out(i)==0 && expout(i)==0);
    end    
end


%FP=numel(find(arrayfun(@(x,y) (x==0 && y>0),out,eout)==1));
%TP=numel(find(arrayfun(@(x,y) (x>0 && y>0),out,eout)==1));
%FN=numel(find(arrayfun(@(x,y) (x>0 && y==0),out,eout)==1));
%TN=numel(find(arrayfun(@(x,y) (x==0 && y==0),out,eout)==1));
