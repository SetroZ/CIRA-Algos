cd scripts

./build.sh

gdb -q -ex "run" --args ../src/main $1 $2