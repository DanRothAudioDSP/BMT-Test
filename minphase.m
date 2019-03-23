function [hn] = minphase(h)

%%% Copyright (c) 1997-1998 Shawn McCaslin
%%% All Rights Reserved.
%%%
%%% This program is free software; you can redistribute it and/or modify
%%% it under the terms of the GNU General Public License as published by
%%% the Free Software Foundation; either version 2 of the License, or
%%% (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%% GNU General Public License for more details.
%%%
%%% The GNU Public License is available in the file LICENSE, or you
%%% can write to the Free Software Foundation, Inc., 59 Temple Place -
%%% Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
%%% World Wide Web at http://www.fsf.org.

r = cplxpair(roots(h));

% Find roots inside & on unit circle

ra = abs(r);

iru   = find(abs(ra-1) <= 1e-8); % indices for roots on uc
irin  = find(ra-1 < -1e-8);  % indices for roots inside uc
irout = find(ra-1 >  1e-8);  % indices for roots outside uc

% Map roots outside the unit circle to inside:

cr = [r(iru) ; r(irin) ; 1./conj(r(irout))];

% Combine complex-conj roots:

j=1;
k=1;
while(j<=length(cr))
 if(imag(cr(j))~=0)
  cc(k,:) = conv([1 -cr(j)],[1 -cr(j+1)]);
  j=j+2;
  k=k+1;
 else
  cc(k,:) = [0 1 -cr(j)];
  j = j+1;
  k=k+1;
 end;
end;
if(rem(length(cc),2)~=0) cc(k,:) = [ 0 0 1 ]; end;

% Get reference spectrum:

Hi = freqz(h,1,512);
K1 = abs(Hi);
K1 = 10*log10(K1/max(K1));
for i=1:512
 if(K1(i)<-100) K1(i)=-100; end;
end;

% Expand polynomial:

c=1;
while(size(cc)>0)
 k=0;
 l = size(cc);
 for j=1:l
  ct = conv(c,cc(j,:));
  H = freqz(ct,1,512);

  K2 = abs(H);
  K2 = 10*log10(K2/max(K2));
  for i=1:512
   if(K1(i)<-100) K2(i)=-100; end;
  end;
  k(j) = cov(abs(K2)-sum(abs(K2)));
 end;

 [minv,mini] = min(k);

 cq = cc(mini,:);

 if(mini==1)
  cc = cc(2:l,:);
 elseif(mini==l)
  cc = cc(1:l-1,:);
 else
  cc = cc([1:mini-1 mini+1:l],:);
 end;

 k=0;
 l = size(cc);
 for j=1:l
  ct = conv(cq,cc(j,:));
  H = freqz(ct,1,512);
  k(j) = max(abs(H));
 end;

 [minv,mini] = min(k);

 cq  = conv(cq,cc(mini,:));
 c  = conv(c,cq);

 if(mini==1)
  cc = cc(2:l,:);
 elseif(mini==l)
  cc = cc(1:l-1,:);
 else
  cc = cc([1:mini-1 mini+1:l],:);
 end;
end;


% Strip off extraneous leading zeros & normalize power:

s = find(c~=0);
hn = real(c(s(1):length(c)));
hn = sqrt(sum(h.*h)/sum(hn.*hn))*hn;

return;
