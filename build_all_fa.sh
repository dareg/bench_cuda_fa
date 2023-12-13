#!/bin/bash

set -x
ROOT=$PWD

source env.sh

function fiat(){
cd "$ROOT/fiat" || exit 1
BUILD_DIR="build_$1"
FIAT_INSTALL_DIR="$ROOT/fiat/install_$1/"
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1
cmake .. -DCMAKE_INSTALL_PREFIX="$FIAT_INSTALL_DIR"
make -j
make install
}

function field_api(){
cd $ROOT
git clone https://github.com/ecmwf-ifs/field_api field_api_v0.2.2
cd "$ROOT/field_api_v0.2.2" || exit 1
BUILD_DIR="build"
FIAT_INSTALL_DIR="$ROOT/fiat/install_nvidia"
INSTALL_DIR="$ROOT/install_field_api"
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1
cmake .. -Dfiat_ROOT="$FIAT_INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DENABLE_ACC=ON
make -j
make install
}

function field_api_pinning(){
cd $ROOT
git clone --branch naan-cuda https://github.com/ecmwf-ifs/field_api field_api_pinning
cd "$ROOT/field_api_pinning" || exit 1
BUILD_DIR="build"
FIAT_INSTALL_DIR="$ROOT/fiat/install_nvidia"
INSTALL_DIR="$ROOT/install_pinning"
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1
cmake .. -Dfiat_ROOT="$FIAT_INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DENABLE_ACC=ON -DENABLE_CUDA=ON
make -j
make install
}

function field_api_lukas(){
cd $ROOT
git clone https://github.com/lukasm91/field_api field_api_lukas
cd "$ROOT/field_api_lukas" || exit 1
git checkout improve-noncontiguous
BUILD_DIR="build"
FIAT_INSTALL_DIR="$ROOT/fiat/install_nvidia"
INSTALL_DIR="$ROOT/install_lukas"
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1
cmake .. -Dfiat_ROOT="$FIAT_INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DENABLE_ACC=ON
make -j
make install
}

load_env
git clone https://github.com/ecmwf-ifs/fiat
fiat nvidia
field_api
field_api_pinning
field_api_lukas

