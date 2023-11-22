#!/bin/bash

case $HOSTNAME in 
	(belenosndl* | taranisndl*) ;;
	(*) echo "Not on ndl node" && exit 1 ;;
esac

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/fiat/install_nvidia/lib64
NVPROF=/opt/softs/nvidia/hpc_sdk/Linux_x86_64/23.9/cuda/12.2/bin/nvprof
NVPROF=nvprof

$NVPROF ./bench_v0.2.2
$NVPROF ./bench_pinning
$NVPROF ./bench_lukas
