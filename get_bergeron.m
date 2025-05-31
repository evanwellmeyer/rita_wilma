% function to calculate the bergeron
%
% Author: Evan David Wellmeyer
% Date Created: March 1, 2023
%
% Input: 
%       cyc - 'TRACKS19792020.TXT', or subset with matching columns 
%
%       ID - cyclone ID number for which to calculate Bergeron (first
%       column of the .txt file above)
%
%       timestep - timestep for DR calculation in hours (6,12,24 standard)
%
%
% Output: timeseries of hourly deepening rate in bergeron


function berg = get_bergeron(cyc,timestep,lat_ref)
    
    
    % starting index of computation based on deepening rate length 
    idx1 = timestep/2+1;

    % modify end of loop
    mod_end = timestep/2;
    
    % retrieve pressure values for the selected cyclone 
    PRES = cyc(:,8);
    
%     mm_pres = movmean(PRES,[mod_end mod_end]);
    
    % retrieve latitude values for the selected cyclone
    LATS = cyc(:,3);
    ml = mean(LATS);
    
    % initialize array
    berg = NaN(length(PRES),1);

    % calculate bergeron for selected cyclogenesis
    for ii = idx1:length(PRES)-mod_end
        
        % pressure 1/2 timestep before
        t1 = PRES(ii-mod_end);
        
        % pressure 1/2 timestep after
        t2 = PRES(ii+mod_end);
        
        % pressure gradient
        temporal = (t1-t2)/timestep;

        % calculate mean latitude
        L1 = LATS(ii-mod_end);
        L2 = LATS(ii+mod_end);
        lat_mean = (L1 + L2)/2;
        
        % latitude term for bergeron function
        if lat_ref == 1
            lats = sind(20)/sind(lat_mean);
        elseif lat_ref == 2
            lats = sind(ml)/sind(lat_mean);
        end

        % calculate bergeron
        berg(ii,1) = temporal*lats;  

    end


    
end
