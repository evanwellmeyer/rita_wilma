
function [ace] = ace_index3(max_wind)
% Input is an array of HOURLY max wind velocity for the Tropical Cyclone 
% in m/s. Output is the ace index for the time period of input.
    clear ace
    
    % Convert m/s to knots
    knots = max_wind.*1.943844;
    
    % Take only wind values over 35 knots and reduce the array around those
    % values.
    knots35 = knots > 35;
    kts = knots.*knots35;
    knots = nonzeros(kts);
    
    % Square the wind velocity according to the ace index equation
    knots2 = knots.^2;

    i = 1; % Initialize array index value
    
    % Loop over the squared wind velocity array and take the average of
    % each 6 hours.
    while i < length(knots2)

        if i+2 <= length(knots2)
            ace(i,1) = mean(knots2(i:i+2));
        end

        i = i+2;

    end
    
    % Remove any zero values present in the new array
    ace = nonzeros(ace);
    
    % Calculate the Ace index according to equation
    ace = sum(ace)./10^4;

end