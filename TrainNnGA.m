function [outjadid, net]=TrainAnnGA(net,data)

%% Problem Definition
ad=getwb(net);
Problem.CostFunction=@(x) TrainAnnCost(x,net,data);
Problem.nVar=numel(ad);
alpha=1;
Problem.VarMin=-(10^alpha);
Problem.VarMax=10^alpha;
%% GA Params
prompt = {'Enter MaxIt for GA:','Enter nPop for GA:'};
dlgtitle = 'Parameters';
dims = [1 50];
definput = {'200','100'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
answer=str2double(answer);
Params.MaxIt=answer(1);      % Maximum Number of Iterations
Params.nPop=answer(2);        % Population Size
%% Run GA
results=GAR(Problem,Params);
%% Get Results
wb=results.BestSol;
x=data.Inputs;
t=data.Targets;
net = setwb(net, wb);
outjadid= net(x);
%% Test
TESTHybrid(x,t,net,outjadid);
end