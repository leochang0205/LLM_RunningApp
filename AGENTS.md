# AGENTS.md - Garmin Connect IQ Monkey C Project

## 约束
禁止修改项目文件以外的任何文件
可以自己进行编译，修改文件需要用户确认后执行，不得擅自操作
不得擅自提交代码，只有在明确指示提交代码时才可以提交代码

## 技术参考
- **API接口文档** 通过 https://developer.garmin.com/connect-iq/api-docs/index.html 查阅相关的接口用法

## Build Commands

Garmin Connect IQ projects use the Connect IQ SDK and VS Code extension for building.
### Bulid commands:
    java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true -jar c:\Users\leo\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.4.1-2026-02-03-e9f77eeaa\bin\monkeybrains.jar -o bin\LLM_RunningApp.prg -f d:\WorkSpace\garminProject\LLM_RunningApp\monkey.jungle -y d:\WorkSpace\garminProject\developer_key -d fenix7pro_sim -w
### Standard Build
Build the project using VS Code command palette:
- `Monkey C: Build Project` - Builds all configured products
- `Monkey C: Build for Device` - Builds for a specific device

### Build Targets
Products are configured in `manifest.xml` (currently fenix7pro and fr255).

### Testing
This project does not currently have automated tests. Monkey C projects typically use:
- Device simulation via VS Code Connect IQ extension
- Manual testing on physical devices
- Simulator testing via `Monkey C: Start Simulator`

## Code Style Guidelines

### File Naming
- Source files: `PascalCase.mc` (e.g., `LLM_RunningAppView.mc`)
- Classes must match file names exactly
- Resource files use lowercase with hyphens/underscores as appropriate

### Imports
- Place imports at top of file before class definition
- Use fully qualified module names: `import Toybox.Graphics;`
- Group imports by module (Toybox, then other modules if any)

### Class Structure
```monkeyc
import Toybox.Module1;
import Toybox.Module2;

class ClassName extends BaseClass {
    // Constructor
    function initialize() {
        BaseClass.initialize();
    }

    // Methods
    function methodName(param as Type) as ReturnType {
        // Implementation
    }
}
```

### Type Annotations
- All parameters must have explicit type annotations: `as Type`
- Return types must be declared: `as Void`, `as Dictionary?`, `as Boolean`
- Use nullable types with `?`: `as Dictionary?`
- Union types use `or`: `as [Views] or [Views, InputDelegates]`

### Naming Conventions
- **Classes**: PascalCase (e.g., `LLM_RunningAppView`)
- **Functions**: camelCase (e.g., `onUpdate`, `initialize`)
- **Variables**: camelCase
- **Constants**: SCREAMING_SNAKE_CASE (though not seen in this project)
- **Symbols**: Colon prefix, lowercase_with_underscores (e.g., `:item_1`)

### Comments
- Add comments above functions explaining their purpose
- Use `//` for single-line comments
- Format: `// Brief description of what this does`
- Document parameters and return values for complex functions

### Error Handling
- Check return values where applicable
- Use try/catch if available (Monkey C has limited exception handling)
- Validate inputs before processing
- Handle null/nil values carefully (use `?` nullable types)

### Resource References
- String resources: `@Strings.StringName`
- Drawable resources: `@Drawables.DrawableName`
- Layout resources: `Rez.Layouts.LayoutName`
- Menu resources: `Rez.Menus.MenuName`
- Always reference resources through the `Rez` module

### Inheritance
- Always call parent class constructor: `ParentClass.initialize();`
- Override parent methods when extending classes
- Call parent methods using `ParentClass.methodName()` when appropriate

### View Lifecycle
- `onLayout(dc as Dc)`: Set up layout with `setLayout(Rez.Layouts.Name(dc))`
- `onShow()`: Initialize view state, load resources
- `onUpdate(dc as Dc)`: Redraw view, call `View.onUpdate(dc)` first
- `onHide()`: Clean up, free resources

### App Structure
- Entry point class must match `entry` attribute in `manifest.xml`
- Implement `getInitialView()` to return array of views and delegates
- Use `getApp()` helper function to get app instance
- App lifecycle: `onStart()`, `onStop()`, `getInitialView()`

### Behavior/Menu Delegates
- Extend `WatchUi.BehaviorDelegate` or `WatchUi.MenuInputDelegate`
- Implement event handlers: `onMenu()`, `onMenuItem(item as Symbol)`, etc.
- Use `WatchUi.pushView()` to navigate between views
- Return `true` from event handlers to indicate handled event

### Console Output
- Use `System.println()` for debugging
- Avoid in production code (or remove before release)
- Useful for tracing execution flow

### Device Compatibility
- Support minimum API level 5.2.0 (as per manifest.xml)
- Test on configured products (fenix7pro, fr255)
- Check API availability before using features (using `has()` or similar)
