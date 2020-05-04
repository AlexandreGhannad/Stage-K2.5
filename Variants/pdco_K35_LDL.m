classdef pdco_K35_LDL < pdcoO & K35 & LDL
  properties
  end

  methods
  function o = pdco_K35_LDL(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K35(options_form);
    o = o@LDL(options_solv);
  end
  end
end
