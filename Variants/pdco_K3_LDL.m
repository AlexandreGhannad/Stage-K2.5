classdef pdco_K3_LDL < pdcoO & K3 & LDL
  properties
  end

  methods
  function o = pdco_K3_LDL(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K3(options_form);
    o = o@LDL(options_solv);
  end
  end
end
