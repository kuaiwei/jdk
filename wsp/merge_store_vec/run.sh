os=linux
arch=$(uname -m)
jdk_proj_dir=$(realpath ../..)

JAVA=${jdk_proj_dir}/build/${os}-${arch}-server-slowdebug/images/jdk/bin/java
JAR_FILE=${jdk_proj_dir}/build/${os}-${arch}-server-slowdebug/images/test/micro/benchmarks.jar

JAVA=${jdk_proj_dir}/build/${os}-${arch}-server-fastdebug/images/jdk/bin/java
JAR_FILE=${jdk_proj_dir}/build/${os}-${arch}-server-fastdebug/images/test/micro/benchmarks.jar

TEST=MergeStoreBench.setLongLV           # not vectorized
TEST_good=MergeStoreBench.setLongLV2     # vectorized
TEST_good=MergeStoreBench.setIntLV2     # vectorized
TEST_bad=MergeStoreBench.setIntLU2      # not vectorized

JVM_OPT="-XX:+UseParallelGC -Xbatch -XX:-TieredCompilation -XX:CICompilerCount=1 -XX:-UseOnStackReplacement -XX:CompileCommandFile=trace_c2_vec.cmd -XX:LoopMaxUnroll=8"
JVM_OPT="-XX:+UseParallelGC -XX:LoopMaxUnroll=8"

PERF_OPT="-prof perfasm"
PERF_OPT=""

$JAVA --add-opens=java.base/java.io=ALL-UNNAMED -jar $JAR_FILE -f 1 -wi 5 ${PERF_OPT} -jvmArgsPrepend "${JVM_OPT}" $TEST_good
$JAVA --add-opens=java.base/java.io=ALL-UNNAMED -jar $JAR_FILE -f 1 -wi 5 ${PERF_OPT} -jvmArgsPrepend "${JVM_OPT}" $TEST_bad

# same vm
#$JAVA --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-exports java.base/jdk.internal.misc=ALL-UNNAMED $JVM_OPT -jar $JAR_FILE -f 0 -wi 5 ${PERF_OPT} -jvmArgsPrepend "${JVM_OPT}" $TEST_bad
