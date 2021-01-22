classdef pdco_K25_LSMR < pdcoO & K25 & LSMR
  properties
  end

  methods
  function o = pdco_K25_LSMR(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@LSMR(options_solv);
  end
  end
end
