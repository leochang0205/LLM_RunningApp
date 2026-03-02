# AI Body Doctor - Garmin 手表应用

基于大模型的智能运动健康分析手表应用。

## 功能

- **身体状态分析**: 分析步数、心率、压力、卡路里等健康数据
- **运动分析**: 分析运动类型、时长、距离等运动数据
- **睡眠分析**: 分析睡眠时长和质量
- **AI 智能建议**: 基于大模型提供个性化建议
- **灵活配置**: 支持智谱 GLM、OpenAI 等多种 API

## 快速开始

### 1. 配置 API（推荐）

**方式一：修改代码（推荐）**
编辑 `source/SettingsManager.mc`，设置默认值：

```monkeyc
function initialize() {
    self.apiKey = "YOUR_API_KEY_HERE";
    self.apiUrl = "https://open.bigmodel.cn/api/paas/v4/chat/completions";
    loadSettings();
}
```

**方式二：模拟器控制台**
```monkeyc
var app = Application.getApp() as LLM_RunningAppApp;
var sm = app.getSettingsManager();
sm.setApiKey("YOUR_API_KEY_HERE");
sm.setApiUrl("https://open.bigmodel.cn/api/paas/v4/chat/completions");
```

**方式三：手表端设置**
打开应用 → 菜单 → 设置 → 选择 API 提供商 → 输入 API Key

**获取智谱 API Key**:
1. 访问：https://open.bigmodel.cn/
2. 注册/登录账号
3. 进入控制台创建 API Key

### 2. 构建和安装

使用 VS Code 的 Connect IQ 扩展：
- `Monkey C: Build Project` - 构建项目
- `Monkey C: Build for Device` - 为特定设备构建
- 连接设备后选择 `Monkey C: Build for Device`

### 3. 使用应用

1. 打开手表上的应用
2. 按 Menu 键打开主菜单
3. 选择功能：
   - 身体状态分析
   - 运动分析
   - 睡眠分析
   - 设置（查看/修改配置）
4. 等待 AI 分析完成
5. 查看分析结果（支持上下键滚动）

## 项目结构

```
source/
├── LLM_RunningAppApp.mc         # 应用主类
├── LLM_RunningAppView.mc        # 主视图
├── LLM_RunningAppDelegate.mc    # 主委托
├── LLM_RunningAppMenuDelegate.mc # 菜单委托
├── DataManager.mc               # 数据采集
├── APIClient.mc                 # API 调用
├── PromptManager.mc             # 提示语管理
├── SettingsManager.mc           # 配置管理
├── BodyAnalysisView.mc          # 身体分析视图
├── MotionAnalysisView.mc        # 运动分析视图
├── SleepAnalysisView.mc         # 睡眠分析视图
├── ResultView.mc                # 结果显示
├── LoadingView.mc               # 加载动画
├── ErrorView.mc                # 错误提示
├── ConfigView.mc                # 配置状态视图
├── SettingsView.mc             # 设置界面
├── ApiKeyInputView.mc          # API Key 输入
└── 对应的 Delegate 类
```

## 开发

### 依赖

- Garmin Connect IQ SDK
- VS Code with Connect IQ Extension
- 支持 API Level 5.2.0+ 的设备

### 权限

应用需要以下权限：
- ActivityMonitor - 采集健康数据
- UserProfile - 获取用户活动历史
- Communications - 网络请求
- AppSettings - 本地配置存储

### 支持的 API

- 智谱 GLM-4
- OpenAI GPT
- 自定义 API（OpenAI 兼容格式）

### 自定义

#### 修改提示语

```monkeyc
var app = Application.getApp() as LLM_RunningAppApp;
var promptManager = new PromptManager(app);

// 设置自定义提示语
promptManager.setCustomPrompt(:body_analysis, "你的提示语");
```

#### 配置 API

参见 `API_CONFIG.md`。

## 设备兼容性

- Garmin fenix 7 Pro
- Garmin Forerunner 255
- 其他支持 API Level 5.2.0+ 的设备

## 注意事项

- 需要网络连接（WiFi 或通过手机）
- API 调用可能产生费用
- API 响应时间取决于网络状况
- 推荐通过电脑配置（手表输入较困难）

## 常见问题

**Q: 如何配置 API？**  
A: 查看 `API_CONFIG.md`，推荐修改代码配置。

**Q: 为什么显示"API 未配置"？**  
A: 需要配置 API Key 和地址。

**Q: 为什么显示"网络连接失败"？**  
A: 检查手表的网络连接。

**Q: API 调用失败？**  
A: 检查 API Key 是否正确，账户是否有额度。

**Q: 如何更新配置？**  
A: 重新修改代码或在手表设置中修改。

## 许可

MIT License

## 支持

- 智谱 AI: https://open.bigmodel.cn/
- Garmin Connect IQ: https://developer.garmin.com/connect-iq/
