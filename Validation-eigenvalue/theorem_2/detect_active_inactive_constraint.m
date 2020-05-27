function ind = detect_active_inactive_constraint(x, method, z, n)
switch method
    case "Threshold"
        % Threshold which depends on the norm of the vector x.
        n = norm(x);
        ind = find(abs(x) > n *10^-8);
        
    case "MaxGap"
        % Sort values of abs(x). Find the greater gap between two
        % consecutive sorted values and eliminate all the values before
        % this gap.
        % This method is based on the idea that there is a great gap
        % between active and inactive values of x.
        [t, perm] = sort(abs(x));
        gap = t(2:end)./t(1:end-1);
        [~,l] = max(gap);
        ind = sort(perm(l+1:end));
        
    case "FirstBigGap"
        %  Sort values of abs(x). Find the first gap superior to 100.
        % All the values before this gap are considered to be 0.
        % This method considered the possibility of a greater gap in the
        % active or the inactive value rather than between the active and
        % inactive values of x.
        [t, perm] = sort(abs(x));
        gap = t(2:end)./t(1:end-1);
        l = find(gap >= 100);
        if not(isempty(l))
            l = l(1);
        else
            l = 0;
        end
        ind = sort(perm(l+1:end));
        
    case "broken_lines"
        % Sort x and use the same permutation on z. After, try to fit the
        % evolution of z with a broken line (only one point of break).
        % Total discrete optimization: the break point is also optimize
        % discretly, but rounded after. n correspond to the start points
        % which are test. To improve the results, few star points are
        % tried, and only the best is kept. you can choose the start point
        % with the option n_theorem2 of pdcoo
        if ismember(0,z)
            ind = 1:length(x);
        else
            [t, perm] = sort(abs(x), "descend");
            ztmp = abs(z(perm));
            if not(exist("n"))
                n = [round(length(z)/4) round(length(z)/2) round(3*length(z)/4)];
            end
            Cf = [];
            err = Inf;
            for k = 1 : length(n)
                [tmp_Cf, tmp_err] = g_broken_lines(ztmp,n(k));
                if tmp_err < err
                    err = tmp_err;
                    Cf= tmp_Cf;
                end
            end
            ind = sort(perm(round(1:Cf(end))));
        end
        
        
    case "power_lines"
        % Sort x and use the same permutation on z. After, try to fit the
        % evolution of z with two power functions with one point of break.
        % Total discrete optimization: the break point is also optimize
        % discretly, but rounded after. n correspond to the start points
        % which are test. To improve the results, few star points are
        % tried, and only the best is kept. you can choose the start point
        % with the option n_theorem2 of pdcoo
        if ismember(0,z)
            ind = 1:length(x);
        else
            [t, perm] = sort(abs(x), "descend");
            ztmp = abs(z(perm));
            if not(exist("n"))
                n = [round(length(z)/4) round(length(z)/2) round(3*length(z)/4)];
            end
            Cf = [];
            err = Inf;
            for k = 1 : length(n)
                [tmp_Cf, tmp_err] = g_power_lines(ztmp,n(k));
                if tmp_err < err
                    err = tmp_err;
                    Cf = tmp_Cf;
                end
            end
            ind = sort(perm(round(1:Cf(end))));
        end
end
end