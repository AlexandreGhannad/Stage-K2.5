classdef pdco_K2_MINRES < pdcoO & K2 & MINRES
  properties
  end

  methods
  function o = pdco_K2_MINRES(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K2(options_form);
    o = o@MINRES(options_solv);
  end
  end
end
