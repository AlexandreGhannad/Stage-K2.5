classdef pdco_K3_QR < pdcoO & K3 & QR
  properties
  end

  methods
  function o = pdco_K3_QR(slack, options_pdco, options_form, options_solv)
    o = o@pdcoO(slack, options_pdco);
    o = o@K3(options_form);
    o = o@QR(options_solv);
  end
  end
end
