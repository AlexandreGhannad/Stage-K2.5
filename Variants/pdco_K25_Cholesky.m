classdef pdco_K25_Cholesky < pdcoO & K25 & Cholesky
  properties
  end

  methods
  function o = pdco_K25_Cholesky(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@Cholesky(options_solv);
  end
  end
end
