function Data=CreateData()

f=readmatrix('DATA(cylindrical)')';
x=f(1:4,:);
t=f(5:6,:);

ANSWER=questdlg(' Do you want the dataset to be normalized?',...
  'Normalization','Yes','No','Yes');
if strcmp(ANSWER,'Yes')
    for i= 1:4
        MinX = min(x);
        MaxX = max(x);
        x(:,i) = Normalize_Fcn(x(:,i),MinX(i),MaxX(i));
    end
    
    
    for i= 1:2
        Mint = min(t);
        Maxt = max(t);
        t(:,i) = Normalize_Fcn(t(:,i),Mint(i),Maxt(i));
    end
end
%% Train
Inputs=x;
Targets=t;
Data.Inputs=Inputs;
Data.Targets=Targets;
end