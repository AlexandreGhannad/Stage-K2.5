function ind = detect_active_inactive_constraint(x, method)
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
        l = l(1)
        ind = sort(perm(l+1:end));

end