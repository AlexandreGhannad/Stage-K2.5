% First fucntion to evaluate the results of a problem.
% Display the absolute and relative error on x, z and obj of a problem.
%
% Not use for a long time

function print_result(result, list_problem)
n = size(result, 3);
for i = 1:n

    res = result(:,:,i);

    obj = res(1,:);
    abs_err_x = res(2,:);
    abs_err_z = res(3,:);
    abs_err_obj = res(4,:);
    rel_err_x = res(5,:);
    rel_err_z = res(6,:);
    rel_err_obj = res(7,:);
    rank = res(8,:);
    eigenvalue_validation = res(9,1);
    error = res(9,2);

    fprintf("\n\nNumber problem : %g   Name problem : %s",[i char(list_problem(i))])
    disp("                          K25         K35         K2")
    fprintf("\nObjective value       %g       %g       %g" , obj)
    fprintf("\nAbsolute error on x   %g   %g   %g" , abs_err_x)
    fprintf("\nAbsolute error on z   %g   %g   %g" , abs_err_z)
    fprintf("\nAbsolute error on obj %g   %g   %g" , abs_err_obj)
    fprintf("\nRelative error on x   %g   %g   %g" , rel_err_x)
    fprintf("\nRelative error on z   %g   %g   %g" , rel_err_z)
    fprintf("\nRelative error on obj %g   %g   %g" , rel_err_obj)
    fprintf("\nRanking               %g             %g             %g" , rank)
    fprintf("\n\nValidation of eigenvalue : %g" , eigenvalue_validation)
    fprintf("\nError : %g" , error)
end
eigenvalue_validation = result(9,1,:);
error = result(9,2,:);
disp("Validation of the localisation of eigenvalue")
disp(squeeze(eigenvalue_validation)')
disp("Associated error")
disp(squeeze(error)')
end