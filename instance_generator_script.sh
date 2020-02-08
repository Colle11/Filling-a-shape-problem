#!/bin/bash

if test $# -ne 2; then
	echo "Usage: $0 <lower-bound> <upper-bound>"
	exit 1
fi

re='^[0-9]+$'

if ! [[ $1 =~ $re ]]; then
	echo "Usage: $0 <lower-bound> <upper-bound>"
	exit 1
fi

if ! [[ $2 =~ $re ]]; then
	echo "Usage: $0 <lower-bound> <upper-bound>"
	exit 1
fi

l=$1	# lower-bound
u=$2	# upper-bound

mkdir -p raw_benchmark_instances

while [ "$l" -le "$u" ]; do
	for i in {1..5}
	do
		clingo --verbose=0 --outf=1 --quiet=1,2,2 --models 1 --rand-freq=0.25 --seed=$RANDOM -c w=$l -c h=$l -c p=$(($(($RANDOM%51))+35)) instance_generator.lp > "./raw_benchmark_instances/raw_benchmark_instance_$l-$i.txt"
	done
	l=$(($l + 1))
done

l=$1

make

while [ "$l" -le "$u" ]; do
	for i in {1..5}
	do
		./instance_converter.exe "./raw_benchmark_instances/raw_benchmark_instance_$l-$i.txt"
	done
	l=$(($l + 1))
done

make clean

rm -rf raw_benchmark_instances