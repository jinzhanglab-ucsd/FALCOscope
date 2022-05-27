function setPlateIndex(Scp, start_row, end_row, start_col, end_col, ExperimentConfig)
    msk = false(8,12);
    r=start_row:end_row;  
    c=start_col:end_col; 
    msk(r,c)=1;

    batchInds = zeros(8,12);
    for k = 1:length(c)
        batchInds(1:8,c(k)) = k;
    end
    Scp.createPositions([],'sitesperwell',[1,1],'msk',msk,'batchinds',batchInds,'experimentdata',ExperimentConfig);
end