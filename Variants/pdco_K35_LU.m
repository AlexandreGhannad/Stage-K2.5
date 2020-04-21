classdef pdco_K35_LU < pdcoO & K35 & LU
  properties
  end

  methods
  function o = pdco_K35_LU(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K35(options_form);
    o = o@LU(options_solv);
  end
  end
end
