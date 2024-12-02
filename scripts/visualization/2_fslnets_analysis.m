

%%% FSLNets - simple network matrix estimation and applications
%%% FMRIB Analysis Group
%%% Copyright (C) 2012-2014 University of Oxford
%%% See documentation at  www.fmrib.ox.ac.uk/fsl



% to open matlab on server:
% open LOCAL terminal in SERVER folder
% connect via: ssh -X hippo@hippocampus.charite.de
% start matlab

%%%%% CHANGE PATH HERE %%%%%%%%
studypath='/data/hippo/maron/Projects/BecauseY/MouseMouse/data/Medusa_rabies_robust_inho/';
dualreg_outputname='output_withmask'
ts_removal = [18]; % setup which components should be removed, standard component to be removed is 18

%%% open matlab from terminal:
%%% matlab -noopengl

%%% change the following paths according to your local setup

%%% change the following paths according to your local setup

addpath /data/hippo/maron/tools/matlab_toolboxes/FSLNets              % wherever you've put this package
addpath /data/hippo/maron/tools/matlab_toolboxes/L1precision            % L1precision toolbox
addpath /data/hippo/maron/tools/matlab_toolboxes/pwling             % pairwise causality toolbox
addpath(sprintf('%s/etc/matlab',getenv('FSLDIR')))    % you don't need to edit this if FSL is setup already


%%% setup the names of the directories containing your group-ICA and dualreg outputs
group_maps=strcat(studypath, 'misc_data/DSURQE_images');     % spatial maps 4D NIFTI file, e.g. from group-ICA
   %%% you must have already run the Matlab_Connectivity_visualization script in the respective analysis directory and copy the MelodicIC.sum directory into the above-mentioned directory


%%%%  ts_dir = fullfile(ts_dir)
ts_dir=strcat(studypath, 'dual_regression/',dualreg_outputname);                           % dual regression output directory, containing all subjects' timeseries


%%% load timeseries data from the dual regression output directory
ts=nets_load(ts_dir,1.0,2);
   %%% arg2 is the TR (in seconds)
   %%% arg3 controls variance normalisation: 0=none, 1=normalise whole subject stddev, 2=normalise each separate timeseries from each subject
ts_spectra=nets_spectra(ts);   % have a look at mean timeseries spectra

%%% BE CAREFUL: NODES ARE NOT EQUAL TO COMPONENTS
%%% NODES START WITH 1,2,3,4,....
%%% COMPONENTS START WITH 0,1,2,3,....
%%% Thus, NODE 50 = COMPONENT 49 and so on!

%%%%%% Exclusion of components by time spectra: (do not exclude 50, 6, 71, 78)
%%%%
%%%%
%%%%% excluded are 13, 25, 34, 41, 47, 51, 52, 55, 57, 83 AND 1, 9, 18, 43, 45, 56, 64, 66, 67, 69, 72, 76, 82, 84  

%%%%%% Exclusion of components by localization: (do not exclude 50, 6, 71, 78)
%%%%
%%%%
%%%% excluded are 3, 7, 14, 17, 43, 49, 52, 53, 58, 59, 79, 82, 83, 85, 89, 90 AND 18, 28, 57, 66, 72, 88, 37

%%% cleanup and remove bad nodes' timeseries (whichever is not listed in ts.DD is *BAD*).

ts.DD=[1:ts.NnodesOrig];
ts.DD=setdiff(ts.DD, ts_removal);

%%% BE CAREFUL: NODES ARE NOT EQUAL TO COMPONENTS
%%% NODES START WITH 1,2,3,4,....
%%% COMPONENTS START WITH 0,1,2,3,....
%%% Thus, NODE 50 = COMPONENT 49 and so on!

% ts.UNK=[10];  optionally setup a list of unknown components (where you're unsure of good vs bad)
ts=nets_tsclean(ts,1);                   % regress the bad nodes out of the good, and then remove the bad nodes' timeseries (1=aggressive, 0=unaggressive (just delete bad)).
                                         % For partial-correlation netmats, if you are going to do nets_tsclean, then it *probably* makes sense to:
                                         %    a) do the cleanup aggressively,
                                         %    b) denote any "unknown" nodes as bad nodes - i.e. list them in ts.DD and not in ts.UNK
                                         %    (for discussion on this, see Griffanti NeuroImage 2014.)

nets_nodepics(ts,group_maps);          % quick views of the good and bad components
ts_spectra=nets_spectra(ts);             % have a look at mean spectra after this cleanup


%%% create various kinds of network matrices and optionally convert correlations to z-stats.
%%% here's various examples - you might only generate/use one of these.
%%% the output has one row per subject; within each row, the net matrix is unwrapped into 1D.
%%% the r2z transformation estimates an empirical correction for autocorrelation in the data.
netmats0=  nets_netmats(ts,0,'cov');        % covariance (with variances on diagonal)
netmats0a= nets_netmats(ts,0,'amp');        % amplitudes only - no correlations (just the diagonal)
netmats1=  nets_netmats(ts,1,'corr');       % full correlation (normalised covariances)
netmats2=  nets_netmats(ts,1,'icov');       % partial correlation
netmats3=  nets_netmats(ts,1,'icov',10);    % L1-regularised partial, with lambda=10
netmats5=  nets_netmats(ts,1,'ridgep');     % Ridge Regression partial, with rho=0.1
netmats11= nets_netmats(ts,0,'pwling');     % Hyvarinen's pairwise causality measure


%%% view of consistency of netmats across subjects; returns t-test Z values as a network matrix
%%% second argument (0 or 1) determines whether to display the Z matrix and a consistency scatter plot
%%% third argument (optional) groups runs together; e.g. setting this to 4 means each group of 4 runs were from the same subjec
[Znet1,Mnet1]=nets_groupmean(netmats1,1); % test whichever netmat you're interested in; returns Z values from one-group t-test and group-mean netmat
[Znet5,Mnet5]=nets_groupmean(netmats5,1);   % test whichever netmat you're interested in; returns Z values from one-group t-test and group-mean netmat


%%% view hierarchical clustering of nodes  
%%% arg1 is shown below the diagonal (and drives the clustering/hierarchy); arg2 is shown above diagonal
nets_hierarchy(Znet1,Znet1,ts.DD,group_maps)  
nets_hierarchy(Znet5,Znet5,ts.DD,group_maps); 

%%% view interactive netmat web-based display


%%%% copy netweb directory to local PC to evaluate circular matrix
nets_netweb(Znet1,Znet5,ts.DD,group_maps,'netweb');


%%% cross-subject GLM, with inference in randomise (assuming you already have the GLM design.mat and design.con files).
%%% arg4 determines whether to view the corrected-p-values, with non-significant entries removed ts=nets_tsclean(ts,1);                   % regress the bad nodes out of the good, and then remove the bad nodes' timeseries (1=aggressive, 0=unaggressive (just delete bad)).
                                         % For partial-correlation netmats, if you are going to do nets_tsclean, then it *probably* makes sense to:
                                         %    a) do the cleanup aggressively,
                                         %    b) denote any "unknown" nodes as bad nodes - i.e. list them in ts.DD and not in ts.UNK
                                         %    (for discussion on this, see Griffanti NeuroImage 2014.)

%%% ts_dir = fullfile(ts_dir)

[p_uncorrected,p_corrected]=nets_glm_fdr01(netmats1,strcat(studypath, 'dual_regression/dual_regression.mat'),strcat(studypath, 'dual_regression/dual_regression.con'),1);  % returns matrices of 1-p

[pp_uncorrected,pp_corrected]=nets_glm_fdr01(netmats5,strcat(studypath, 'dual_regression/dual_regression.mat'),strcat(studypath, 'dual_regression/dual_regression.con'),1);

%%% OR- GLM, but with pre-masking that tests only the connections that are strong on aveabove the diagonal.

%%% ts_dir = fullfile(ts_dir)

[p_uncorrected,p_corrected]=nets_glm_fdr01(netmats1,strcat(studypath, 'dual_regression/dual_regression.mat'),strcat(studypath, 'dual_regression/dual_regression.con'),1);  % returns matrices of 1-p

[pp_uncorrected,pp_corrected]=nets_glm_fdr01(netmats5,strcat(studypath, 'dual_regression/dual_regression.mat'),strcat(studypath, 'dual_regression/dual_regression.con'),1);

p_corrected_empty = zeros(size(p_corrected));

for i = 1:2
    p_values = 1-p_uncorrected(i,:); %not sure if this is correct. is it?
    q = 0.2; % gewünschter FDR-Schwellenwert
    [p_sorted, p_idx] = sort(p_values); % p-Werte sortieren
    n = length(p_values); % Anzahl der Tests
    threshold = (1:n) * q / n; % FDR-Schwellenwerte
    
    % Finde die größte p-Wert-Schwelle, die eingehalten wird
    below_threshold = find(p_sorted <= threshold);
    if isempty(below_threshold)
        disp('Keine signifikanten Werte bei FDR-Korrektur gefunden.');
    else
        max_idx = below_threshold(end);
        p_crit = p_sorted(max_idx); % Kritischer p-Wert
        disp(['Signifikante Werte bis p <= ' num2str(p_crit)]);
        
        % Hypothesen markieren, die signifikant sind
        significant = p_values <= p_crit;
        disp('Signifikante Hypothesen:');
        disp(significant);
    end

    for j = 1:n
        p_corrected_empty(i,j) = min(1,p_sorted(j) * n / j);
    end

    p_corrected_empty(i,p_idx) = 1 - p_corrected_empty(i,:);
    p_corrected(i,:) = p_corrected_empty(i,:);
end


pp_corrected_empty = zeros(size(pp_corrected));

for i = 1:2
    pp_values = 1-pp_uncorrected(i,:); %not sure if this is correct. is it?
    q = 0.2; % gewünschter FDR-Schwellenwert
    [pp_sorted, pp_idx] = sort(pp_values); % p-Werte sortieren
    n = length(pp_values); % Anzahl der Tests
    threshold = (1:n) * q / n; % FDR-Schwellenwerte
    
    % Finde die größte p-Wert-Schwelle, die eingehalten wird
    below_threshold = find(pp_sorted <= threshold);
    if isempty(below_threshold)
        disp('Keine signifikanten Werte bei FDR-Korrektur gefunden.');
    else
        max_idx = below_threshold(end);
        pp_crit = pp_sorted(max_idx); % Kritischer p-Wert
        disp(['Signifikante Werte bis p <= ' num2str(pp_crit)]);
        
        % Hypothesen markieren, die signifikant sind
        significant = pp_values <= pp_crit;
        disp('Signifikante Hypothesen:');
        disp(significant);
    end

    for j = 1:n
        pp_corrected_empty(i,j) = min(1,pp_sorted(j) * n / j);
    end

    pp_corrected_empty(i,pp_idx) = 1 - pp_corrected_empty(i,:);
    pp_corrected(i,:) = pp_corrected_empty(i,:);
end



%%% OR- GLM, but with pre-masking that tests only the connections that are strong on average across all subjects.
%%% change the "8" to a different tstat threshold to make this sparser or less sparse.
%netmats=netmats3;  [grotH,grotP,grotCI,grotSTATS]=ttest(netmats);  netmats(:,abs(grotSTATS.tstat)<8)=0;
%[p_uncorrected,p_corrected]=nets_glm(netmats,'design.mat','design.con',1);

%%% view 10 most significant edges from this GLM


%%% SHOW PARTIAL CORRELATION RESULTS FOR CONTRAST NUMBER 1 and 2 
nets_edgepics(ts,group_maps,Znet5,reshape(pp_corrected(1,:),ts.Nnodes,ts.Nnodes),10);
nets_edgepics(ts,group_maps,Znet5,reshape(pp_corrected(2,:),ts.Nnodes,ts.Nnodes),10);

%%% show full correlation results for contrast number 2
nets_edgepics(ts,group_maps,Znet1,reshape(p_corrected(1,:),ts.Nnodes,ts.Nnodes),10);
nets_edgepics(ts,group_maps,Znet1,reshape(p_corrected(2,:),ts.Nnodes,ts.Nnodes),10);


%% in diesem Falle ist die Verbindung der nodes 33 und 4 signifikant! (entspricht den ic049 und ic005)

%%% simple cross-subject multivariate discriminant analyses, for just two-group cases.
%%% arg1 is whichever netmats you want to test.
%%% arg2 is the size of first group of subjects; set to 0 if you have two groups with paired subjects.
%%% arg3 determines which LDA method to use (help nets_lda to see list of options)
%%[lda_percentages]=nets_lda(netmats5,12,1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Der folgende Command funktioniert nur, wenn die Subjects in der Reihenfolge direkt hintereinander angeordnet sind (also Gruppe 1  =12 subjects und danach Gruppe 2 mit den restilchen) -> daher für unsere Daten nicht brauchbar

%%% create boxplots for the two groups for a network-matrix-element of interest (e.g., selected from GLM output)
%%% arg3 = matrix row number,    i.e. the first  component of interest (from the DD list)
%%% arg4 = matrix column number, i.e. the second component of interest (from the DD list)
%%% arg5 = size of the first group (set to -1 for paired groups)
%%% nets_boxplots(ts,netmats5,50,6,12);
%print('-depsc',sprintf('boxplot-%d-%d.eps',IC1,IC2));  % example syntax for printing to file

%%%%% solution with commands from nets_boxplots script

%%%% enter component number one and component number two
IC1=17;
IC2=4;

%%%% Define place of difference between nodes in network matrix
i=(IC1-1)*ts.Nnodes + IC2; 

% get values for boxplots, padding with NaN for unequal groups (otherwise boxplot doesn't work)
% Here you have to enter the correct design based on the filelist from groupanalysis and dual regression
% which is specific for every cohort (in this case COVID)
grot1=netmats1([2,3,7,8,12,13,15,16,17,19,20,22,23,26,28,29],i) %%% defines file numbers of group 1
grot2=netmats1([1,4,5,6,9,10,11,14,18,21,24,25,27,30,31,32],i) %%% defines file numbers of group 2



% finds out the sizes of the groups and produces an NA value for every subject that is missing in one group compared
% to the other (if group length differs from each other)
grotlength=max(length(grot1),length(grot2));
grot1=[grot1;nan(grotlength-length(grot1),1)]; grot2=[grot2;nan(grotlength-length(grot2),1)];

% creates boxplot
boxplot([grot1 grot2]); set(gcf,'Position',[100 100 150 200],'PaperPositionMode','auto'); set(gca,'XTick',[1 2],'XTickLabel',['GROUP1' ; 'GROUP2']);



