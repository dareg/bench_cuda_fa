#!/bin/bash

ROOT=$PWD

INC_FIAT=fiat/install_nvidia/module/fiat/
INC_PAR=fiat/install_nvidia/module/parkind_dp/
LD_FIAT="fiat/install_nvidia/lib64/ -lfiat" 


#v0.2.2
echo "Building v0.2.2"
LD_FA=install_field_api/lib64/
INC_FA=install_field_api/include/field_api_dp/ 
nvfortran -O2 -acc=gpu main.F90 -I$INC_PAR -I$INC_FIAT -I$INC_FA -L$LD_FIAT -L$LD_FA -lfield_api_dp
mv a.out bench_v0.2.2

#pinning
echo "Building pinning"
LD_FA=install_pinning/lib64/
INC_FA=install_pinning/include/field_api_dp/ 
nvfortran -O2 -acc=gpu -cuda main.F90 -I$INC_PAR -I$INC_FIAT -I$INC_FA -L$LD_FIAT -L$LD_FA -lfield_api_dp
mv a.out bench_pinning

#lukas
echo "Building lukas"
LD_FA=install_lukas/lib64/
INC_FA=install_lukas/include/field_api_dp/ 
nvfortran -O2 -acc=gpu -cuda main.F90 -I$INC_PAR -I$INC_FIAT -I$INC_FA -L$LD_FIAT -L$LD_FA -lfield_api_dp
mv a.out bench_lukas
