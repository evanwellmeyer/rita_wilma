% function to calculate the bergeron
%
% Author: Evan David Wellmeyer
% Date Created: March 1, 2023
%
% Input: 
%       pres 
%
%       ID - cyclone ID number for which to calculate Bergeron (first
%       column of the .txt file above)
%
%       timestep - timestep for DR calculation in hours (12,24 standard)
%
%
% Output: timeseries of hourly deepening rate in bergeron


function berg = get_bergeron_3hr(pres,timestep)
    
    
    % starting index of computation based on deepening rate length 
    idx1 = timestep/6 + 1;
    
    mod_time = timestep/6;

    % modify end of loop
    mod_end = timestep/6;
    
    % retrieve pressure values 
    PRES = pres;
    
    
    % initialize array
    berg = NaN(length(PRES),1);

    % calculate bergeron
    for ii = idx1:length(PRES)-mod_end
        
        if PRES(ii-mod_end) > 0 && PRES(ii+mod_end) > 0
            % pressure 1/2 timestep before
            t1 = PRES(ii-mod_time);

            % pressure 1/2 timestep after
            t2 = PRES(ii+mod_time);

            % pressure gradient
            temporal = (t1-t2)/timestep;


            lats = 1/1.5;


            % calculate bergeron
            berg(ii,1) = temporal*lats;  
        end

    end


    
end