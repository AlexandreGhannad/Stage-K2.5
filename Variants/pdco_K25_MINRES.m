classdef pdco_K25_MINRES < pdcoO & K25 & MINRES
  properties
  end

  methods
  function o = pdco_K25_MINRES(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@MINRES(options_solv);
  end
  end
end
