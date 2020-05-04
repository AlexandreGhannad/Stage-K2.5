classdef pdco_K2_LDL < pdcoO & K2 & LDL
  properties
  end

  methods
  function o = pdco_K2_LDL(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K2(options_form);
    o = o@LDL(options_solv);
  end
  end
end
