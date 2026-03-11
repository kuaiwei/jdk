#!/bin/bash
#
# TestStackBang 独立测试脚本
# 从 jtreg 测试日志中提取的测试命令
#

# 设置基础目录
MODE=$1
BUILD_DIR="/home/kuaiwei.kw/repo/openjdk/build/linux-x86_64-server-${MODE}"
JDK_DIR="${BUILD_DIR}/images/jdk"
TEST_SUPPORT_DIR="${BUILD_DIR}/test-support/jtreg_test_hotspot_jtreg_compiler_uncommontrap_TestStackBang_java"
TEST_CLASSES_DIR="${TEST_SUPPORT_DIR}/classes/0/compiler/uncommontrap/TestStackBang.d"
TEST_SRC_DIR="/mnt/data/kuaiwei.kw_home_ext/repo/jeandle/jeandle-jdk/test/hotspot/jtreg/compiler/uncommontrap"

# 设置 CLASSPATH
CLASSPATH="${TEST_CLASSES_DIR}:${TEST_SRC_DIR}"

# 测试 JVM 选项
# 注意：去掉了 jtreg 特定的选项，保留核心测试参数
JAVA_OPTS="
    -Xcomp -Xbatch
    -Xss2m
    -XX:-UseOnStackReplacement
    -XX:CompileCommand=compileonly,compiler.uncommontrap.TestStackBang::m1
    -XX:CompileCommand=quiet
    -XX:+UnlockDiagnosticVMOptions
    -XX:-TieredCompilation -XX:+PrintCompilation
"

# 设置 Java 命令
JAVA_CMD="${JDK_DIR}/bin/java"

# 打印测试信息
echo "========================================"
echo "TestStackBang 独立测试脚本"
echo "========================================"
echo "JDK: ${JDK_DIR}"
echo "Classpath: ${CLASSPATH}"
echo "Java options: ${JAVA_OPTS}"
echo "========================================"
echo ""

# 首先编译测试类（如果尚未编译）
if [ ! -d "${TEST_CLASSES_DIR}" ] || [ ! -f "${TEST_CLASSES_DIR}/compiler/uncommontrap/TestStackBang.class" ]; then
	echo "编译测试类..."
	mkdir -p "${TEST_CLASSES_DIR}"
	${JDK_DIR}/bin/javac \
		-d "${TEST_CLASSES_DIR}" \
		-sourcepath "${TEST_SRC_DIR}" \
		"${TEST_SRC_DIR}/TestStackBang.java"
	if [ $? -ne 0 ]; then
		echo "编译失败!"
		exit 1
	fi
	echo "编译成功"
	echo ""
fi

# 运行测试
echo "运行测试..."
echo "Command: ${JAVA_CMD} ${JAVA_OPTS} -cp ${CLASSPATH} compiler.uncommontrap.TestStackBang"
echo ""

${JAVA_CMD} \
	${JAVA_OPTS} \
	-cp "${CLASSPATH}" \
	compiler.uncommontrap.TestStackBang

EXIT_CODE=$?

echo ""
echo "========================================"
if [ $EXIT_CODE -eq 0 ]; then
	echo "测试通过! (exit code: $EXIT_CODE)"
else
	echo "测试失败! (exit code: $EXIT_CODE)"
fi
echo "========================================"

exit $EXIT_CODE
