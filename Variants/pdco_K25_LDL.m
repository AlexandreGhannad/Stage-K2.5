classdef pdco_K25_LDL < pdcoO & K25 & LDL
  properties
  end

  methods
  function o = pdco_K25_LDL(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@LDL(options_solv);
  end
  end
end
