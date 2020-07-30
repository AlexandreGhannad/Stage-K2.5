function z = Jfunction(y, mode, self, dR, dC, x)
J = dR*self.gcon_local(self.dc.*x)*dC;
if mode == 1
    z = J*y;
else
    z = J'*y;
end
