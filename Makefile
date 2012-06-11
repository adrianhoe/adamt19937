
all:
	gnatmake -gnatf adamt19937 -cargs -O3
	gnatmake -gnatf adamt19937-float_utilities   -cargs -O3
	gnatmake -gnatf adamt19937-integer_utilities -cargs -O3
	gnatmake -gnatf test1  -cargs -O3
	gnatmake -gnatf test2  -cargs -O3
	gnatmake -gnatf test3  -cargs -O3
	gnatmake -gnatf test4  -cargs -O3
	gnatmake -gnatf test5  -cargs -O3
	gnatmake -gnatf test6  -cargs -O3
	gnatmake -gnatf test7  -cargs -O3
	gnatmake -gnatf test8  -cargs -O3
	gcc -o mt19937ar mt19937ar.c -O3

clean:
	rm -f *~ *.o *.ali \
		test1 test2 test3 test4 test5 test6 test7 test8 mt19937ar
