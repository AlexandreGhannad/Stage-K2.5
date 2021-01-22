classdef pdco_K25_GLSMR < pdcoO & K25 & GLSMR
  properties
  end

  methods
  function o = pdco_K25_GLSMR(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@GLSMR(options_solv);
  end
  end
end
