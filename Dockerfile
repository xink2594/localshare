# 使用OpenJDK 21作为基础镜像
FROM openjdk:21-jdk-slim

# 设置工作目录
WORKDIR /app

# 复制Maven配置文件
COPY pom.xml .

# 复制源代码
COPY src ./src

# 安装Maven并构建项目
RUN apt-get update && \
    apt-get install -y maven && \
    mvn clean package -DskipTests && \
    apt-get remove -y maven && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 暴露端口
EXPOSE 8080

# 设置环境变量
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# 运行应用
CMD ["java", "-jar", "target/localshare-1-1.0-SNAPSHOT.jar"]
