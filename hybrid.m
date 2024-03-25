disp('To cooperate in articles, send an email to the following address') 
disp('')
disp ('email subject : CO Article')
disp('')
disp('Email: Eng.mehdighasri@gmail.com') 
disp('')
G = '<a href = "https://www.mathworks.com/matlabcentral/profile/authors/20537547">MathWorks Profile</a>';
disp(G)
%% Data
data=CreateData();
%% ANN
warning off
% Create a Fitting Network
prompt = {' Enter the Number of Hidden Layers'};
dlgtitle = 'Parameters';
dims = [1 50];
definput = {'10'};
answer1 = inputdlg(prompt,dlgtitle,dims,definput);
answer1=str2double(answer1);
hiddenLayerSize = answer1(1);
% create a neural network
net = feedforwardnet(hiddenLayerSize);
net = configure(net, data.Inputs, data.Targets);
%% Train Hybrid ANN-GA
[outjadid, net]=TrainAnnGA(net,data);

