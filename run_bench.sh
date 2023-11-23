#!/bin/bash

source env.sh
load_env

case $HOSTNAME in 
	(belenosndl* | taranisndl*) ;;
	(*) echo "Not on ndl node" && exit 1 ;;
esac

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/fiat/install_nvidia/lib64
NVPROF="nvprof --normalized-time-unit ms --csv"
export LD_LIBRARY_PATH=/opt/softs/nvidia/hpc_sdk/Linux_x86_64/23.9/cuda/12.2/extras/CUPTI/lib64/:$LD_LIBRARY_PATH

echo "#all time in ms" > res.csv
echo "v0.2.2, pinning, lukas" >> res.csv

for name in ping-pong owner contiguous mostly-contiguous not-contiguous; do
	for version in v0.2.2 pinning lukas; do 
		echo "Bench $name $version"
		$NVPROF ./bench_${name}_${version} &> log_${name}_${version}.csv
	done
	for dir in HtoD DtoH; do
		echo -n "$name $dir," >> res.csv
		for version in v0.2.2 pinning lukas; do 
			awk -F "," "/CUDA memcpy $dir/ {printf \"%f,\",\$3}" log_${name}_${version}.csv >> res.csv
		done
		echo "" >> res.csv
	done
	echo "" >> res.csv
done

cat res.csv
