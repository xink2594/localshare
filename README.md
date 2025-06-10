# LocalShare - 局域网文件共享系统

<div align="center">
![Java](https://img.shields.io/badge/Java-21-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen)
![WebSocket](https://img.shields.io/badge/WebSocket-Real--time-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

一个基于 Spring Boot 和 WebSocket 技术的现代化局域网文件传输系统

[功能特点](#功能特点) • [快速开始](#快速开始) • [技术架构](#技术架构) • [使用指南](#使用指南) • [开发文档](#开发文档)

</div>

## 📋 项目概述

LocalShare 是一个现代化的局域网文件共享系统，采用前后端分离架构，支持实时设备发现和高效文件传输。系统具有美观的现代化界面，提供流畅的用户体验。

### ✨ 功能特点

- 🔍 **自动设备发现** - 同一局域网内设备自动互相发现
- 📁 **文件传输** - 支持任意格式文件的高速传输
- 🎯 **传输控制** - 接收方确认机制，安全可控
- 📊 **实时进度** - 实时显示传输进度、速度和预计时间
- 🏷️ **友好命名** - 自动生成"形容词+食物名称+数字"格式的设备名
- 🔄 **断线重连** - 智能重连机制，确保连接稳定
- 📱 **响应式设计** - 适配桌面和移动设备
- 🎨 **现代化界面** - 美观的卡片式布局和动画效果

### 🛠️ 技术栈

- **后端**: Spring Boot 3.2.0 + WebSocket
- **前端**: HTML5 + JavaScript + CSS3
- **传输协议**: 二进制 WebSocket 分片传输
- **设备管理**: 基于 UUID 的唯一标识

## 🚀 快速开始

### 环境要求

- Java 21 或更高版本
- Maven 3.6 或更高版本
- 现代浏览器（Chrome、Firefox、Safari、Edge）

### 安装运行

1. **克隆项目**
   ```bash
   git clone git@github.com:xink2594/localshare.git
   cd localshare-1
   ```

2. **编译项目**
   ```bash
   mvn clean compile
   ```

3. **启动应用**
   ```bash
   mvn spring-boot:run
   ```
   
   或者使用可执行 JAR：
   ```bash
   mvn clean package
   java -jar target/localshare-1-1.0-SNAPSHOT.jar
   ```

4. **访问应用**
   - 打开浏览器访问: `http://localhost:8080`
   - 系统会自动分配设备名称并连接到服务器

## 📖 使用指南

### 基本操作

1. **设备连接**
   - 启动应用后，设备会自动获得一个友好的名称
   - 左上角显示设备信息和连接状态
   - 点击信息图标查看详细连接信息

2. **发现设备**
   - 右侧栏显示局域网内所有在线设备
   - 点击刷新按钮更新设备列表
   - 选择目标设备准备文件传输

3. **发送文件**
   - 选择目标设备后，左侧会显示文件传输区域
   - 点击"选择文件"按钮选择要发送的文件
   - 点击"发送文件"按钮开始传输请求

4. **接收文件**
   - 收到传输请求时会显示文件信息
   - 选择"接受"或"拒绝"传输请求
   - 接受后文件会自动下载到本地

### 高级功能

- **传输监控**: 实时查看传输进度和速度
- **错误处理**: 自动处理网络异常和重连
- **多文件支持**: 支持各种文件格式和大小
- **安全传输**: 基于 WebSocket 的安全传输通道

## 🏗️ 技术架构

### 系统架构图

```
┌─────────────────┐    WebSocket     ┌─────────────────┐
│   Browser A     │◄─────────────────►│   Spring Boot   │
│   (Sender)      │                  │   Application   │
└─────────────────┘                  │                 │
                                     │  FileTransfer   │
┌─────────────────┐    WebSocket     │    Handler      │
│   Browser B     │◄─────────────────►│                 │
│   (Receiver)    │                  │  DeviceRegistry │
└─────────────────┘                  └─────────────────┘
```

### 核心组件

#### 后端架构
```
LocalShareApplication (启动类)
├── Config Layer (配置层)
│   ├── WebSocketConfig - WebSocket路由配置
│   └── WebSocketBinaryMessageSizeConfig - 消息大小配置
├── Controller Layer (控制器层)
│   └── HomeController - 页面路由控制
├── Handler Layer (处理器层)
│   └── FileTransferHandler - WebSocket消息处理核心
├── Service Layer (服务层)
│   └── DeviceRegistry - 设备注册管理服务
└── Model Layer (模型层)
    ├── DeviceInfo - 设备信息实体
    └── FileTransferMessage - 消息传输实体
```

#### 前端架构
- **app.html** - 主应用页面，响应式单页应用
- **styles.css** - 现代化CSS样式，支持动画和响应式
- **JavaScript** - 原生ES6+，WebSocket客户端逻辑

### 数据流设计

1. **设备注册流程**
   ```
   客户端连接 → 生成设备ID → 分配设备名称 → 注册到设备注册表 → 广播设备列表
   ```

2. **文件传输流程**
   ```
   选择文件 → 发送传输请求 → 接收方确认 → 发送文件元数据 → 分片传输 → 重组下载
   ```

3. **消息类型**
   - `device_info` - 设备信息
   - `device_list` - 设备列表更新
   - `request_transfer` - 传输请求
   - `transfer_response` - 传输响应
   - `file_metadata` - 文件元数据
   - `transfer_error` - 传输错误

## 🔧 开发文档

### 项目结构

```
localshare-1/
├── src/main/java/com/example/localshare/
│   ├── LocalShareApplication.java         # 应用启动类
│   ├── config/
│   │   ├── WebSocketConfig.java          # WebSocket配置
│   │   └── WebSocketBinaryMessageSizeConfig.java
│   ├── controller/
│   │   └── HomeController.java           # 首页控制器
│   ├── handler/
│   │   └── FileTransferHandler.java      # 文件传输处理器
│   ├── model/
│   │   ├── DeviceInfo.java              # 设备信息模型
│   │   └── FileTransferMessage.java     # 传输消息模型
│   └── service/
│       └── DeviceRegistry.java          # 设备注册服务
├── src/main/resources/
│   ├── application.yml                   # 应用配置
│   └── static/
│       ├── app.html                     # 主页面
│       ├── index.html                   # 重定向页面
│       └── styles.css                   # 样式文件
├── pom.xml                              # Maven配置
├── README.md                            # 项目文档
└── process.md                           # 流程详解
```

### 配置说明

#### application.yml
```yaml
server:
  port: 8080                    # 服务端口

spring:
  servlet:
    multipart:
      max-file-size: 100MB      # 最大文件大小
      max-request-size: 100MB   # 最大请求大小
  
  websocket:
    max-text-message-size: 8192         # 文本消息最大大小
    max-binary-message-size: 4194304    # 二进制消息最大大小(4MB)
```

### API接口

#### WebSocket接口
- **连接地址**: `ws://localhost:8080/file-transfer`
- **消息格式**: JSON（文本）/ Binary（文件数据）

#### REST接口
- `GET /` - 重定向到主页面
- `GET /app.html` - 主应用页面

### 开发指南

#### 添加新消息类型

1. 在 `FileTransferMessage.java` 中添加新字段
2. 在 `FileTransferHandler.java` 中添加处理逻辑
3. 在前端 JavaScript 中添加消息处理

#### 自定义设备命名

修改 `FileTransferHandler.java` 中的 `ADJECTIVES` 和 `FOOD_NOUNS` 数组：

```java
private static final String[] ADJECTIVES = {
    "快乐的", "聪明的", "活泼的", "神秘的", // 添加更多形容词
};

private static final String[] FOOD_NOUNS = {
    "苹果", "香蕉", "草莓", "橙子", // 添加更多食物名词
};
```

#### 扩展功能建议

- 📂 **文件夹传输** - 支持批量文件和目录传输
- 🔐 **端到端加密** - 添加文件传输加密
- 🌐 **跨网络支持** - 支持不同网络间的文件传输
- 📱 **移动端优化** - 开发移动端专用界面
- 🗂️ **传输历史** - 记录和管理传输历史
- ⚡ **断点续传** - 支持大文件断点续传

## 🐛 故障排除

### 常见问题

**Q: 连接失败或无法发现设备？**
A: 确保所有设备在同一局域网内，检查防火墙设置是否允许8080端口访问。

**Q: 文件传输中断？**
A: 系统具有自动重连机制，稍等片刻会自动恢复。如持续中断，请检查网络连接。

**Q: 大文件传输失败？**
A: 检查 `application.yml` 中的文件大小限制配置，默认支持100MB文件。

**Q: 浏览器兼容性问题？**
A: 建议使用现代浏览器（Chrome 80+、Firefox 75+、Safari 13+、Edge 80+）。

### 性能优化

- **网络优化**: 减少传输延迟，调整分片大小
- **内存管理**: 大文件传输时的内存使用优化
- **并发控制**: 多设备同时传输的性能调优

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🤝 贡献指南

我们欢迎所有形式的贡献！

1. Fork 本项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 开发规范

- 遵循现有代码风格
- 添加适当的注释和文档
- 编写测试用例
- 确保向后兼容性

## 📞 联系我们

- 项目主页: [GitHub Repository]
- 问题反馈: [Issues](issues)
- 讨论区: [Discussions](discussions)

## 🙏 致谢

- Spring Boot 团队提供的优秀框架
- 前端开源社区的设计灵感
- 所有贡献者的努力和支持

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给它一个星标！**

Made with ❤️ by LocalShare Team

</div>