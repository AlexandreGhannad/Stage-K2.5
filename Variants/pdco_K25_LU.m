classdef pdco_K25_LU < pdcoO & K25 & LU
  properties
  end

  methods
  function o = pdco_K25_LU(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@LU(options_solv);
  end
  end
end
