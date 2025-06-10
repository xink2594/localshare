# P2P文件传输系统技术方案  
> **基于SpringBoot + WebSocket的局域网文件传输解决方案**  
> *最后更新：2025年06月09日*

## 一、项目概述
### 1.1 核心功能  
- ✅ **设备发现机制**：自动检测同一局域网内的在线设备  
- ✅ **文件传输协议**：支持WebSocket二进制流分片传输  
- ✅ **交互流程**：  
  ```mermaid
  graph LR
  A[设备A]--> B[选择设备]-->C[选择文件] --> D[请求设备B]
  D --> E{设备B确认}
  E -->|同意| F[分片传输文件]
  E -->|拒绝| G[终止连接]
  ```


### 1.2 技术栈
| 模块         | 技术选型                         |
| ------------ | -------------------------------- |
| **后端**     | Spring Boot 3.x + WebSocket      |
| **前端**     | HTML5 + WebSocket API + File API |
| **传输协议** | WebSocket (WSS加密)              |
| **依赖**     | `spring-boot-starter-websocket`  |

## 二、核心模块设计
### 2.1 设备发现服务
```java
// 设备注册管理示例
public class DeviceRegistry {
    private static ConcurrentHashMap<String, Session> onlineDevices = new ConcurrentHashMap<>();
    
    public void registerDevice(String deviceId, Session session) {
        onlineDevices.put(deviceId, session);
        broadcastDeviceList(); // 广播更新设备列表
    }
}
```

### 2.2 文件传输流程
1. **传输初始化**  
   - 发送元数据：文件名、大小、分片数、MD5校验码
   - 配置缓冲区：`setBinaryMessageSizeLimit(4 * 1024 * 1024)`

2. **分片传输机制**  
   
   ```javascript
   // 前端文件分片读取
   const reader = new FileReader();
   reader.onload = (e) => {
     websocket.send(e.target.result); // 发送二进制片段
   }
   reader.readAsArrayBuffer(fileSlice);
   ```

### 2.3 安全控制
- **传输加密**：启用WSS协议防止中间人攻击  
- **设备认证**：连接时生成6位动态PIN码验证  
- **文件校验**：SHA-256完整性验证

## 三、接口规范
### 3.1 WebSocket消息协议
| 消息类型     | JSON格式示例                       | 方向        |
| ------------ | ---------------------------------- | ----------- |
| **设备上线** | `{"type":"online","id":"DEV01"}`   | 设备→服务端 |
| **传输请求** | `{"type":"req","file":"test.zip"}` | 设备A→设备B |
| **分片数据** | `BinaryMessage`                    | 双向传输    |

## 四、部署指南
1. **服务端配置**
   
   ```yaml
   # application.yml
   server:
     port: 8080
   spring:
     websocket:
       max-binary-message-size: 4MB  # 关键配置
   ```

2. **客户端要求**  
   - 浏览器支持：Chrome 90+ / Firefox 88+  
   - 网络环境：同一局域网段

> **注意事项**：大文件传输建议启用WebRTC直连模式（需额外实现NAT穿透）



