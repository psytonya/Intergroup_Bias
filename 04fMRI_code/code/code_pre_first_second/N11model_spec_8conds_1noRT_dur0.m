clear all;
root_path=['E:\no_slice_timing\data'];
folders=dir([root_path,'\sub*']);


for sub_num=1:length(folders)
    path=[root_path, '\' folders(sub_num).name];
    
    %-------------------------------------------
    % Onsets of each condition for each run
    %-------------------------------------------
    
    for run=1:2 %2 runs
        
        eve_type={'in6','in7','in9','in12','out6','out7','out9','out12','nores'};
        
        
        %% getting onsets
        
        nTXT=dir(fullfile([path], '*fMRI.txt'));
        
        
        rData=textread([path '\' nTXT.name],'%s');
        [m,n]=size(rData);
        nData=reshape(rData,16,m*n/16);
        nData=nData';
        nData=nData(2:end,3:end);
        [m,n]=size(nData);
        nData3=zeros(m,n);
        %i;
        for j=1:m
            for k=1:n
                nData3(j,k)=str2num(nData{j,k});
            end
        end
        nData=nData3;
        
        
        %% parameters for each run
        
        for typ_num=1:9
           
             dur=0; %6 s for each trial.

            if typ_num==1 %in6-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==6 & nData(:,7)==1 & nData(:,13)~=0),10);  % 6:6 offer of RUN1
                
            elseif typ_num==2 %in7-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==7 & nData(:,7)==1 & nData(:,13)~=0),10);  % 7:5 offer of RUN1
                
            elseif typ_num==3 %in9-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==9 & nData(:,7)==2 & nData(:,13)~=0),10);  % 9:3 offer of RUN1
                
            elseif typ_num==4 %in12-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==12 & nData(:,7)==2 & nData(:,13)~=0),10);  % 12:0 offer of RUN1
                
            elseif typ_num==5 %out6-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==6 & nData(:,7)==3 & nData(:,13)~=0),10);  % 6:6 offer of RUN1
                
            elseif typ_num==6 %out7-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==7 & nData(:,7)==3 & nData(:,13)~=0),10);  % 7:5 offer of RUN1
                
            elseif typ_num==7 %out9-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==9 & nData(:,7)==4 & nData(:,13)~=0),10);  % 9:3 offer of RUN1
                
            elseif typ_num==8 %out12-run1
                onset=nData(find(nData(:,4)==run & nData(:,6)==12 & nData(:,7)==4 & nData(:,13)~=0),10);  % 12:0 offer of RUN1
                
            elseif typ_num==9 %RT==0    
                onset=nData(find(nData(:,4)==run & nData(:,13)==0),10);  % 12:0 offer of RUN1                
            end
            
            if isempty(onset)
                onset=['NAN'];
                dur=['NAN'];
            end
            
            names{typ_num}=eve_type{typ_num};
            onsets{typ_num}=onset;
            durations{typ_num}=dur;
            pmod(typ_num).name{1}='none';
            pmod(typ_num).param{1}=0;
            pmod(typ_num).poly{1}=1;
            
            onset=[];
            dur=[];
        end
        
        %save conditions.mat conditions;
        run1_path=[path,'\func\run01'];
        run2_path=[path,'\func\run02'];
        
        oup_name=['cond8_newN11_run0' num2str(run) '.mat'];
        
        if run==1
            save([run1_path '\' oup_name], 'names', 'onsets', 'durations','pmod');
        elseif run==2
            save([run2_path '\' oup_name], 'names', 'onsets', 'durations','pmod');
        end
        
    end
end