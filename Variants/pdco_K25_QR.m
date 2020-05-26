classdef pdco_K25_QR < pdcoO & K25 & QR
  properties
  end

  methods
  function o = pdco_K25_QR(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K25(options_form);
    o = o@QR(options_solv);
  end
  end
end
