for lmn = 1 : 4
%     o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
%     o1.solve;
%     o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
%     o2.solve;
%     o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
%     o3.solve;
    o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
    o4.solve;
end