#!/usr/bin/env bash

function lang_usage {
    echo "Ruby Language Extension"
    echo ""
    echo "Configuration is normal copy of template"
    echo "Run supports one additional argument which is passed as a custom input file (see template README)"
    echo "Test filters for tests with part1 or partA (and part2 or partB) in name for those switches. Any untagged tests run in all"
}

function configure_template {
    echo "Configuring Ruby directory in $1 using template at $2"

    cp -r $2/* $1
}

function run_solutions {
    echo "Running Ruby solution for $1 part $2 with args $3"

    pushd $1 >&2

    case $2 in
        partA)
            if [ $# -gt 2 ]
            then
                rake runPartA[$3]
            else
                rake runPartA
            fi
            ;;
        partB)
            if [ $# -gt 2 ]
            then
                rake runPartB[$3]
            else
                rake runPartB
            fi
            ;;
        *)
            if [ $# -gt 2 ]
            then
                rake runAll[$3]
            else
                rake runAll
            fi
            ;;
    esac

    popd >&2
}

function test_solution {
    echo "Testing Zig solution for $1 part $2"

    pushd $1 >&2

    case $2 in
        partA)
            rake test A="--name=/.*part[1|A].*/"
            ;;
        partB)
            rake test A="--name=/.*part[2|B].*/"
            ;;
        *)
            rake test
            ;;
    esac

    popd >&2
}