function setTimepoints(Scp, num_tp, time_interval)
    Scp.Tpnts = Timepoints;
    Scp.Tpnts = createEqualSpacingTimelapse(Scp.Tpnts, num_tp, time_interval); % # of time points, seconds btwn each timepoint
end