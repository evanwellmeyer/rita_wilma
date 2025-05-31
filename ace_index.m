function [ace] = ace_index(max_wind)

    clear ace

    knots = max_wind.*1.943844;

    knots35 = knots > 35;
    kts = knots.*knots35;
    knots = nonzeros(kts);

    knots2 = knots.^2;

    i = 1;
    while i < length(knots2)

        if i+6 <= length(knots2)
            ace(i,1) = mean(knots2(i:i+6));
        end

        i = i+6;

    end

    ace = nonzeros(ace);

    ace = sum(ace)./10^4;

end