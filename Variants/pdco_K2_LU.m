classdef pdco_K2_LU < pdcoO & K2 & LU
  properties
  end

  methods
  function o = pdco_K2_LU(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K2(options_form);
    o = o@LU(options_solv);
  end
  end
end
