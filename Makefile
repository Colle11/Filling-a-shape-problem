COMPILE_OPTIONS = -Wall -O3 -std=c++11 

instance_converter.exe: instance_converter.o
	g++ -o instance_converter.exe instance_converter.o

instance_converter.o: instance_converter.cpp
	g++ -c $(COMPILE_OPTIONS) instance_converter.cpp

clean:
	rm -f instance_converter.exe instance_converter.o