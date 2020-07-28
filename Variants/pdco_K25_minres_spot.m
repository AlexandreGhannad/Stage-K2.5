classdef pdco_K25_minres_spot < pdcoO & K25 & minres_spot
  properties
  end

  methods
  function o = pdco_K25_minres_spot(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@minres_spot(options_solv);
  end
  end
end
