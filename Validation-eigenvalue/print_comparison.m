function print_comparison(Problem1, Problem2, Problem3, result)
% Take information
if exist("result")
    iter1 = result(1,1);
    iter2 = result(1,2);
    iter3 = result(1,3);
    reason1 = result(2,1);
    reason2 = result(2,2);
    reason3 = result(2,3);
    complementarity_resid1 = result(3,1);
    complementarity_resid2 = result(3,2);
    complementarity_resid3 = result(3,3);
    time1 = result(4,1);
    time2 = result(4,2);
    time3 = result(4,3);
    
    disp("   Iteration   Complementary Residu     Time       Arrest")
    fprintf("K2.5 :   %g        %g        %g    %s", iter1, complementarity_resid1, time1, reason1)
    fprintf("\nK3.5 :   %g        %g        %g    %s", iter2, complementarity_resid2, time2, reason2)
    fprintf("\nK2   :   %g        %g        %g    %s \n\n", iter3, complementarity_resid3, time3, reason3)
else
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
    
    disp("   Iteration   Complementary Residu     Time       Arrest")
    fprintf("K2.5 :   %g        %g        %g    %s", iter1, complementarity_resid1, time1, reason1)
    fprintf("\nK3.5 :   %g        %g        %g    %s", iter2, complementarity_resid2, time2, reason2)
    fprintf("\nK2   :   %g        %g        %g    %s \n\n", iter3, complementarity_resid3, time3, reason3)
end
end