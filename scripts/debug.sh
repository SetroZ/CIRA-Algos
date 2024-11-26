./build.sh
cd ../src
gdb -q -ex "run" --args ./main $1 $2