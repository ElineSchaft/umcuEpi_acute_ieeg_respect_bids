
function bsuppression = look_for_burst_suppression(annots,sfreq)
BSstarts={'200','Burstsup_on'};
BSstops={'201','Burstsup_off'};

start_bs =[];
end_bs = [];
for i=numel(BSstarts)
    BS_Start = BSstarts{i};
    BS_Stop = BSstops{i};
    
    start_bs = [start_bs;find(startsWith(annots(:,2),BS_Start))];
    end_bs   = [end_bs;find(startsWith(annots(:,2),BS_Stop))];


    if(length(start_bs) ~= length(end_bs))
        error('burst suppression: starts and ends did no match')
end
end

bsuppression = cell(size(start_bs));

for i = 1:numel(start_bs)
    
    bs          = struct;
    matched_end = find(contains(annots(:,2),BS_Stop));
    
    if(isempty(matched_end))
        error('start and stop %s does not match',annots{start_bs(i),2});
    end
    if(length(matched_end)>1)
        
        matched_end       = matched_end((matched_end-start_bs(i))>0);
        [val,idx_closest] = min(matched_end);
        matched_end       = matched_end(idx_closest);%take the closest in time
    end
    
    bs.pos          = [(annots{start_bs(i),1})/sfreq annots{matched_end,1}/sfreq];
    bsuppression{i} = bs;
end
