Scaffold: SPM layout, protocols, stub astronomical engine, lunar selector, validator

实现目的
- 按 SHICHEN 项目计划 v2.0 创建初始代码骨架，包含：SPM 布局、核心数据模型、协议抽象、占位天文引擎、月球转位候选选择器、边界验证器、最小 SwiftUI 视图和 CI 测试工作流。

主要变更（文件）
- Package.swift
- README.md
- Docs/SHICHEN_PROJECT_PLAN.md (占位)
- .github/workflows/ci.yml
- Sources/Shared/AlgorithmVersion.swift
- Sources/Shared/ShichenError.swift
- Sources/Models/GeographicLocation.swift
- Sources/Models/AstronomicalEvent.swift
- Sources/Astronomy/AstronomicalEngine.swift (protocol)
- Sources/Astronomy/StubAstronomicalEngine.swift (stub)
- Sources/Reconstruction/ShichenReconstructionModel.swift (protocol + core types)
- Sources/Reconstruction/LunarAnchorSelector.swift (candidate search + simple nocturnal validator)
- Sources/Reconstruction/BoundaryValidator.swift (implements required checks)
- Sources/UI/ContentView.swift
- Sources/SHICHEN/main.swift
- Tests/SHICHENTests/SHICHENTests.swift

已实现的行为
- 明确定义 AstronomicalEngine 与 ShichenReconstructionModel 协议（可插拔）。
- 提供 StubAstronomicalEngine 便于接口开发（方法当前返回 indeterminate 或抛未实现错误）。
- LunarAnchorSelector：在 target ±window 内枚举转位候选并以太阳高度 < −6° 作为首版夜间过滤（占位启发式）。
- BoundaryValidator：实现计划书第 29 条列出的关键验证（12 个边界、时间顺序、非零/非负时长、分支顺序、周期闭合等）。
- 添加 CI 配置（swift test）与基础测试骨架。

已知限制与下一步计划
- 当前天文实现为占位 stub；合并后建议尽快接入真实 ephemeris（例如 SwiftAA）或自实现精确算法以验证数值结果。
- LunarAnchorSelector 的 nocturnal 判定为首版启发式，后续将用更严格的候选评分与历史验证替换。
- 下一步我将在该分支/PR 下继续：
  1. 添加单元测试：BoundaryValidator 正/负例、LunarAnchorSelector 的模拟候选用例（含高纬度/无日出/无月升情形）。
  2. 实现 SolarPhaseFallback 模型与 HistoricalReconstructionV1 基础骨架。
  3. 在你批准后，集成真实天文库并完成对比验证（USNO / independent sources）。
