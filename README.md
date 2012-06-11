adamt1937
=========

An Ada implementation of Mersenne Twister (MT19937) pseudo random number generator.

The original Matsumoto's mt19937ar.c is included for verification of the correctness of AdaMT19937. The Makefile will compile this C source. Run mt19937ar and test1 as below:

% mt19937ar > r1
% test1 > r2
% diff r1 r2

Note: I have added additional code in the main() in order to generate the exact sets of numbers as in test1.adb. This C source for comparison had been overlook in the past.

Visit http://adrianhoe.com/adrianhoe/projects/adamt19937/ for more information.
