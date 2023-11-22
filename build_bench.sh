#!/bin/bash

ROOT=$PWD

module load nvhpc/23.9

INC_FIAT=fiat/install_nvidia/module/fiat/
INC_PAR=fiat/install_nvidia/module/parkind_dp/
LD_FIAT="fiat/install_nvidia/lib64/ -lfiat" 

NVF="nvfortran -O2 -acc=gpu -I$INC_PAR -I$INC_FIAT -L$LD_FIAT"

for name in contiguous mostly-contiguous not-contiguous; do
	#v0.2.2
	echo "Building $name v0.2.2"
	LD_FA=install_field_api/lib64/
	INC_FA=install_field_api/include/field_api_dp/ 
	$NVF $name.F90 -I$INC_FA  -L$LD_FA -lfield_api_dp
	mv a.out "bench_${name}_v0.2.2"

	#pinning
	echo "Building $name pinning"
	LD_FA=install_pinning/lib64/
	INC_FA=install_pinning/include/field_api_dp/ 
	$NVF -cuda $name.F90 -I$INC_FA  -L$LD_FA -lfield_api_dp
	mv a.out "bench_${name}_pinning"

	#lukas
	echo "Building $name lukas"
	LD_FA=install_lukas/lib64/
	INC_FA=install_lukas/include/field_api_dp/ 
	$NVF -cuda $name.F90 -I$INC_FA  -L$LD_FA -lfield_api_dp
	mv a.out "bench_${name}_lukas"
done
