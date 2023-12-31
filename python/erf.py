import math
""" error function for Probit Percentage """

for Y in range(20):
    y = Y/2 - 5.0000001
    P = 50*(1+(y/abs(y))*math.erf(abs(y)/2**0.5))
    # print(f"{Y/2:<6.1f}{P:>7.2f}")


P_0 = 100000000/25**2
Y = -77.1 + (6.91 * math.log(P_0))
print(Y)
y = Y-5
P = 50*(1+(y/abs(y))*math.erf(abs(y)/2**0.5))
print(P)
