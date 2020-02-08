#!/bin/bash

if test $# -gt 0; then
	echo "Usage: $0"
	exit 1
fi

mkdir -p benchmark_results
mkdir -p benchmark_results/dzn_benchmark_results
mkdir -p benchmark_results/lp_benchmark_results

for f in benchmark_instances/lp_benchmark_instances/*.lp
do
	s=$(echo "$f" | cut -d'/' -f 3 | cut -d'.' -f 1)
	clingo --outf=1 --time-limit=300 --configuration=handy $f filling_a_shape.lp > "./benchmark_results/lp_benchmark_results/$s-result.txt"
	echo "ASP: $s-result.txt"
done

for f in benchmark_instances/dzn_benchmark_instances/*.dzn
do
	s=$(echo "$f" | cut -d'/' -f 3 | cut -d'.' -f 1)
	minizinc --solver Gecode --time-limit 300000 --output-time filling_a_shape.mzn $f > "./benchmark_results/dzn_benchmark_results/$s-result.txt"
	echo "MiniZinc: $s-result.txt"
done
