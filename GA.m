function[BestRepGA,BestRepGAPOS]=GA(nPop,MaxIt,lb,up,D,func)


%% Problem Definition
VarSize=[1 D];   % Decision Variables Matrix Size
%% Type of selection methods
ANSWER=questdlg('Choose Selection Method:','Real Genetic Algorithm',...
    'Roulette Wheel Selection','Tournament Selection','Random Selection','Roulette Wheel Selection');
UseRouletteWheelSelection=strcmp(ANSWER,'Roulette Wheel Selection');
UseTournamentSelection=strcmp(ANSWER,'Tournament Selection');
UseRandomSelection=strcmp(ANSWER,'Random Selection');
if UseRouletteWheelSelection
    beta=8;         % Selection Pressure
elseif UseTournamentSelection
    beta=3;          % Tournamnet Pressure
elseif UseRandomSelection
    beta=5;
end
if UseTournamentSelection
    TournamentSize=3;   % Tournamnet Size
end
%%  Parameters
prompt = {' Enter Crossover Percentage(0.1< nc <0.8)','Enter Mutation Percentage (1 - nc)'};
dlgtitle = 'GA Parameters';
dims = [1 50];
definput = {'0.8','0.2'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
answer=str2double(answer);

pc=answer(1);                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)
pm=answer(2);                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants
gamma=0.05;
mu=0.02;         % Mutation Rate\
pause(0.1);
%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    % Initialize Position
    pop(i).Position=unifrnd(lb,up,VarSize);
    % Evaluation
    pop(i).Cost=func(pop(i).Position);
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;

% Array to Hold Number of Function Evaluations
nfe=zeros(MaxIt,1);


%% Main Loop

for it=1:MaxIt
    
    % Calculate Selection Probabilities
    P=exp(-beta*Costs/WorstCost);
    P=P/sum(P);
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
        if UseRouletteWheelSelection
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        end
        if UseTournamentSelection
            i1=TournamentSelection(pop,TournamentSize);
            i2=TournamentSelection(pop,TournamentSize);
        end
        if UseRandomSelection
            i1=randi([1 nPop]);
            i2=randi([1 nPop]);
        end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        [popc(k,1).Position, popc(k,2).Position]=...
            Crossover(p1.Position,p2.Position,gamma,lb,up);
        
        % Evaluate Offsprings
        popc(k,1).Cost=feval(func,popc(k,1).Position);
        popc(k,2).Cost=feval(func,popc(k,2).Position);
        
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
        popm(k).Position=Mutate(p.Position,mu,lb,up);
        
        % Evaluate Mutant
        popm(k).Cost=feval(func,popm(k).Position);
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm];
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
        BestPos(it,:)=BestSol.Position;

    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) , 'Best Cost = ' num2str(BestCost(it))]);
end


    BestRepGA=BestCost;
    BestRepGAPOS=BestPos(MaxIt,:);

%% Results
figure;
semilogy(BestCost,'r','LineWidth',2);
legend('Real Genetic Algorithm');
title(ANSWER)
xlabel('Number of Iterations ');
ylabel('RMSE');
grid on
set(gca,'fontname','Times new roman','FontSize', 10);  % Set fontname
end