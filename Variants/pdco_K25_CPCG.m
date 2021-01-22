classdef pdco_K25_CPCG < pdcoO & K25 & CPCG
  properties
  end

  methods
  function o = pdco_K25_CPCG(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@CPCG(options_solv);
  end
  end
end
