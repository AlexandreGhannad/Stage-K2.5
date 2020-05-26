classdef pdco_K3_LU < pdcoO & K3 & LU
  properties
  end

  methods
  function o = pdco_K3_LU(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K3(options_form);
    o = o@LU(options_solv);
  end
  end
end