#!/usr/bin/env bash

function configure_template {
    echo "Configuring Zig directory in $1 using template at $2"

    cp -r $2/* $1
}

function run_solutions {
    exit 1
}

function test_solution {
    exit 1
}