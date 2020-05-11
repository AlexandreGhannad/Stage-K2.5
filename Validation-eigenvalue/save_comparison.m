function result = save_comparison(Problem1, Problem2, Problem3, show)
% show is a boolean. If show is true, the function will display the result
% like print_comparison.
% Take information from the three problems
iter1 = Problem1.PDitns;
iter2 = Problem2.PDitns;
iter3 = Problem3.PDitns;
reason = ["Solution is found"; "Too many iterations"; "Linesearch failed too often";...
    "Step lengths became too small"; "Other errors occured"];
reason1 = reason(Problem1.inform+1);
reason2 = reason(Problem2.inform+1);
reason3 = reason(Problem3.inform+1);
complementarity_resid1 = Problem1.Cinf0;
complementarity_resid2 = Problem2.Cinf0;
complementarity_resid3 = Problem3.Cinf0;
time1 = Problem1.time;
time2 = Problem2.time;
time3 = Problem3.time;

result = [iter1 iter2 iter3 ;...
    Problem1.inform Problem2.inform Problem3.inform;...
    complementarity_resid1 complementarity_resid2 complementarity_resid3;...
    time1 time2 time3];

if exist("show")
    disp("   Iteration   Complementary Residu     Time       Arrest")
    fprintf("K2.5 :   %g        %g        %g    %s", iter1, complementarity_resid1, time1, reason1)
    fprintf("\nK3.5 :   %g        %g        %g    %s", iter2, complementarity_resid2, time2, reason2)
    fprintf("\nK2   :   %g        %g        %g    %s \n\n", iter3, complementarity_resid3, time3, reason3)
end
end