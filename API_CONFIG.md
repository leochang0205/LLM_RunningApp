# AI Body Doctor - 配置指南

## API 配置说明

本应用需要配置大模型的 API 信息才能正常使用。推荐以下配置方式：

### 方式一：通过代码配置（推荐）⭐

修改 `source/SettingsManager.mc` 文件中的默认值：

```monkeyc
function initialize() {
    self.apiKey = "YOUR_API_KEY_HERE";  // 填入你的 API Key
    self.apiUrl = "https://open.bigmodel.cn/api/paas/v4/chat/completions";  // API 地址
    loadSettings();
}
```

修改后需要重新编译并安装到手表。

### 方式二：通过模拟器控制台

1. 在 VS Code 中打开模拟器
2. 在调试控制台输入：
```monkeyc
var app = Application.getApp() as LLM_RunningAppApp;
var sm = app.getSettingsManager();
sm.setApiKey("YOUR_API_KEY_HERE");
sm.setApiUrl("https://open.bigmodel.cn/api/paas/v4/chat/completions");
```

### 方式三：通过手表端设置界面

在手表上打开应用 → 菜单 → 设置 → 选择 API 提供商 → 输入 API Key

**注意**: 手表输入较长字符串比较困难，推荐使用方式一或方式二。

## 获取智谱 API Key

1. 访问智谱 AI 开放平台：https://open.bigmodel.cn/
2. 注册/登录账号
3. 进入控制台
4. 创建 API Key
5. 复制 API Key

## API 配置示例

```monkeyc
// 智谱 GLM-4
apiKey = "your_zhipu_api_key_here"
apiUrl = "https://open.bigmodel.cn/api/paas/v4/chat/completions"

// OpenAI
apiKey = "your_openai_api_key_here"
apiUrl = "https://api.openai.com/v1/chat/completions"
```

## 手表端设置说明

手表应用支持以下 API 提供商：

1. **智谱 GLM-4**: 自动配置 API 地址
2. **OpenAI**: 自动配置 API 地址
3. **自定义**: 手动输入 API 地址

选择提供商后，输入对应的 API Key 即可。

## 自定义提示语

如果需要自定义分析提示语，可以使用以下方式：

```monkeyc
// 通过代码设置自定义提示语
var app = Application.getApp() as LLM_RunningAppApp;
var promptManager = new PromptManager(app);

// 设置身体分析自定义提示语
promptManager.setCustomPrompt(:body_analysis, "你的自定义提示语");

// 设置运动分析自定义提示语
promptManager.setCustomPrompt(:motion_analysis, "你的自定义提示语");

// 设置睡眠分析自定义提示语
promptManager.setCustomPrompt(:sleep_analysis, "你的自定义提示语");
```

## 注意事项

1. API Key 不要泄露，不要提交到公开代码仓库
2. API 地址可能会变更，请关注官方通知
3. 免费版 API 可能有调用频率限制
4. 确保手表已连接网络（WiFi 或通过手机连接）
5. API 调用可能需要一定时间，请耐心等待
6. 手表输入建议：通过电脑配置更方便

## 测试配置

配置完成后，可以通过以下方式测试：

1. 打开应用
2. 选择"设置"菜单项
3. 查看配置状态
4. 如果显示"✓ 已配置"，说明配置成功
5. 如果显示"✗ 未配置"，需要重新配置

## 常见问题

**Q: 为什么显示"API 未配置"？**  
A: API Key 或 API 地址未设置，请按照上述方式配置。

**Q: 为什么显示"网络连接失败"？**  
A: 请检查手表的网络连接，确保可以通过网络访问 API。

**Q: API 调用失败怎么办？**  
A: 请检查 API Key 是否正确，账户是否有足够额度，网络是否正常。

**Q: 如何恢复默认提示语？**  
A: 调用 `promptManager.resetPrompt(:body_analysis)` 等方法恢复默认。

**Q: 手表上输入很困难怎么办？**  
A: 推荐使用方式一（修改代码）或方式二（模拟器控制台）配置。

---

如有问题，请参考智谱 AI 官方文档：https://open.bigmodel.cn/dev/api
