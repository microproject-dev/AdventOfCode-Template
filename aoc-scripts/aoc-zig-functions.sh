#!/usr/bin/env bash

function lang_usage {
    echo "Zig Language Extension"
    echo ""
    echo "Configuration is normal copy of template"
    echo "Run functions as normal"
    echo "Tests are extracted from the part1 and part2 files respectively"
}

function configure_template {
    echo "Configuring Zig directory in $1 using template at $2"

    cp -r $2/* $1
}

function run_solutions {
    echo "Running Zig solution for $1 part $2"

    pushd $1 >&2

    case $2 in
        partA)
            zig build runPartA
            ;;
        partB)
            zig build runPartB
            ;;
        *)
            zig build runAll
            ;;
    esac

    popd >&2
}

function test_solution {
    echo "Testing Zig solution for $1 part $2"

    pushd $1 >&2

    case $2 in
        partA)
            zig build --summary all testPartA
            ;;
        partB)
            zig build --summary all testPartB
            ;;
        *)
            zig build --summary all testAll
            ;;
    esac

    popd >&2
}