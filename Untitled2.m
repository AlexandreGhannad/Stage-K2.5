for i = 1:3
o1 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
o1.solve;
end