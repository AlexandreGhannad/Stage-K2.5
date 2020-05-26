classdef pdco_K25_PCG < pdcoO & K25 & PCG
  properties
  end

  methods
  function o = pdco_K25_PCG(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@PCG(options_solv);
  end
  end
end
