function [e,n] = genPublicKey(p,q)
% generates a RSA public key from two prime integers, p and q
% does not check that p and q are prime !!
n = p*q;
phi_n = (p-1)*(q-1);

% p,q < e < phi_n ET GCD(phi_n,e) = 1
% GCD = greatest common denominator

% loop to find e
for e = max(p,q)+1 : phi_n - 1
  if gcd(phi_n,e)==1
    break
  end
end

end