function [x_mu, y_mu, sig, ddiv] = fitgauss2d(M,sigfix, showfig)
% [x_mu, y_mu, sig, ddiv] = fitgauss2d(M,sigfix, showfig)
% Fits isotropic gaussian to the each z-slice of hte matrix M.
% Uses fminsearch to look for the minimum of d-divergence (log-Poisson model).
% x_mu, y_mu : coordiantes of the fitted mean
% sig : fitted std
% ddiv: D -divergence between data and figure generated form gaussian
% sigfig : if set to a certain vaulem it does not fit he variance of hte
% gaussian. If let empty (sigfix = []) then it fits sigma as well (default). 
% 31/3/2011
if ~exist('sigfix','var'); sigfix = []; end
if ~exist('showfig','var'); showfig = 0; end

nd=ndims(M);
sm=size(M);
switch nd
    case 2
        nslice =1;
        M(:,:,2)=eps; %? not sure why I put this here...
        
    case 3
        nslice = size(M,3);
end

M = max(abs(M),eps); %ensures positive values
mM = max(max(M));
% indlin = find(bsxfun(@eq,M,mM));
% [xm,ym]=ind2sub(sm,indlin);
M = bsxfun(@rdivide,M,mM); % scales the matrix to maximum is 1

x_mu = zeros(1,nslice);
y_mu = zeros(1,nslice);
sig = zeros(1,nslice);
ddiv = zeros(1,nslice);

for sl = 1:nslice
    Mslice = M(:,:,sl);
    [xguess, yguess]=find(Mslice == 1,1);
    if isempty(sigfix)        
        sguess = max(sum(Mslice(:))/(sm(1)*sm(2))*sm(1),1); % guess of the initital sigma:
        x = fminsearch(@(x) ddivGauss(x,Mslice),[yguess,xguess,sguess]);
        sig(sl) = x(3);
    else
        x = fminsearch(@(x) ddivGauss_sigfix(x,Mslice,sigfix),[yguess,xguess]);
        sig(sl) = sigfix;
        x(3) = sigfix; 
    end
    x_mu(sl) = x(1);
    y_mu(sl) = x(2);
    ddiv(sl) = ddivGauss(x,Mslice);
end

if showfig
    for sl = 1 : nslice     
        width = 1;
        ims(M(:,:,sl), 'gray');
        hold on
        scatter (x_mu(sl), y_mu(sl), 'xr','linewidth',width);
        h=circle([x_mu(sl),y_mu(sl)], sig(sl),100,'--r');
        set(h,'linewidth',width)
    end
end