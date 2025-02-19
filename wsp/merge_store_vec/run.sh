os=$(uname)
arch=$(uname -m)
jdk_proj_dir=$(realpath ../..)

JAVA=${jdk_proj_dir}/build/${os}-${arch}-server-fastdebug/images/jdk/bin/java
JAR_FILE=${jdk_proj_dir}/build/${os}-${arch}-server-fastdebug/images/test/micro/benchmarks.jar

TEST=MergeStoreBench.setLongLV           # not vectorized
TEST_good=MergeStoreBench.setLongLV2     # vectorized
TEST_bad=MergeStoreBench.setLongLU2      # not vectorized

JVM_OPT="-XX:+UseParallelGC -Xbatch -XX:-TieredCompilation -XX:CICompilerCount=1 -XX:-UseOnStackReplacement -XX:CompileCommandFile=trace_c2_vec.cmd"

PERF_OPT="-prof perfasm"
PERF_OPT=""

$JAVA --add-opens=java.base/java.io=ALL-UNNAMED -jar $JAR_FILE -f 1 -wi 5 ${PERF_OPT} -jvmArgsPrepend "${JVM_OPT}" $TEST_good
$JAVA --add-opens=java.base/java.io=ALL-UNNAMED -jar $JAR_FILE -f 1 -wi 5 ${PERF_OPT} -jvmArgsPrepend "${JVM_OPT}" $TEST_bad
