# Handoff — 文明6 弹窗事件效果 mod（设计已冻结，待产出文档）

> 本文件让一个 fresh agent 接手"把多个文明6 mod 的特殊效果改造成弹窗事件选项"项目。
> 生成时间：2026-09-10。**设计阶段已完成**（grill-with-docs frontier 清空，用户确认共同理解）。
> 下一阶段：产出四份设计文档，用户确认后才实现 mod。
> 本压缩包即完整工作区，下文路径均相对压缩包根目录。

---

## 1. 项目目标（一句话）

从十余个文明6 mod 中提取"特殊效果"（修饰器 / lua / 各类可选强化），改造成弹窗事件的选项：满足触发条件时弹窗，玩家选一项后附着效果。已确认交付方式：**先出文档，用户确认后再实现可运行 mod**。

## 2. 必读文件（按此顺序）

- `CONTEXT.md` — 领域术语表。**先读**，全部设计讨论用这套语言。
- `docs/adr/0001-self-contained-effect-library.md` — 效果库自包含，不依赖原 mod。
- `docs/adr/0002-events-popup-framework-as-base.md` — 以 Events Popup Framework 为弹窗底座。
- `docs/adr/0003-slot-ladder-over-truncation.md` — 槽位阶梯：专属不截断，保底与通用池按序让位。
- `2026-09-09.md` — round 1–3 全部已敲定决策 + 触发器技术事实。
- `2026-09-10.md` — round 4–5 决策（AI 固定保底 / 专属不截断 / 三批实现 / schema+文档格式 / 槽位阶梯）。
- `文明6事件模板mod/` — 弹窗框架 3247819643、模板 3247827926、彗星示例 3249385963。
- `文明6特殊效果提取mod/` — 征服模式、上古之遗、收藏品、SpatialX 退休等效果来源。

## 3. 设计状态

- **frontier 已清空，无未决问题。** 不要重开已敲定决策，除非用户主动提出。
- round 1–3 决策清单见 `2026-09-09.md`「已敲定的设计决策」；round 4–5 见 `2026-09-10.md`。
- 事件 schema 字段已在 round 4 确认，原文见 `2026-09-10.md` Q4 条。
- 注意：round 1–3 的"最多 4 个专属选项"已被 round 4 推翻，以 ADR 0003 的槽位阶梯为准。

## 4. 关键技术事实（探索 agent 已验证，不在 CONTEXT.md 内，写代码前先读）

- **占领钩子**：`GameEvents.CityConquered(iNewOwner, iOldOwner, cityID, x, y)` 最直接（收藏品 mod `Collectibles_theme1.lua:371` 用过）；`pCity:IsOriginalCapital()` 判定原始首都；`GetOriginalOwner() ~= playerID` 区分占领 vs 新建。比征服模式的 `Events.CityAddedToMap` 更对口。
- **结盟**：无现成事件钩子。只能每回合轮询 `pPlayer:GetDiplomaticAI():GetDiplomaticStateIndex()` 比对 `GameInfo.DiplomaticStates` 的 ALLIANCE 行，用 player Property 做边沿检测。
- **自然奇观全发现**：无现成查询。用 `Events.NaturalWonderRevealed(plotx, ploty, eFeature, isFirstToFind)` 计数，与 `GameInfo.Features` 中 `NaturalWonder=true` 的总数比对。
- **进入新时代**：`Events.GameEraChanged(previousEra, newEra)`（上古之遗 mod 用过）。
- **每回合**：`GameEvents.OnGameTurnStarted`（弹窗模板用过）；掷骰示例见彗星事件 `math.random`。
- **世界城市总数**：`PlayerManager.GetAliveMajorIDs()` 迭代 + `pPlayer:GetCities():Members()`（需排除 IsBarbarian / IsFreeCities / 非 IsMajor）。
- **跨端通行做法**：Gameplay→UI 用 `ReportingEvents.Send("EVENT_POPUP_REQUEST", {...})`（框架 `EventBuilder.lua:585` 接收 `Events.EventPopupRequest`）；UI→Gameplay 用 `UI.RequestPlayerOperation(localPlayer, PlayerOperations.EXECUTE_SCRIPT, param)`。
- **框架坑**：3247819643 框架副本缺 `.modinfo`（需自建注册 UI context、保证加载顺序）；模板 `Template_EventsDefinitions.lua` 的 D/E/F 选项回调有 `pPlayer` 未定义 bug，每个回调须写 `local pPlayer = Players[kParams.ForPlayer]`；选项分发样板（"MANDATORY COPY PASTE" 段）需逐个事件复制。

## 5. 下一步（fresh agent 应执行）

1. 读第 2 节全部文件，确保术语与决策对齐。
2. 产出四份文档（格式已定：Markdown 分文件 + 可筛选 HTML 总览，见 `2026-09-10.md` Q4）：
   - 提取分析报告（各 mod 效果机制 + 迁移难度）
   - 效果目录（全量清单，标注 排除/难度/类型）
   - 事件与触发器设计规格（采用已确认的 schema）
   - 实现方案与分批计划（三批，见 `2026-09-10.md` Q3）
3. **用户确认四份文档后才动工实现第一批**：以 3247819643 框架为底座，建 modinfo + 触发器层 + 冷却层 + 三种通用触发器 + 通用池接海克斯（"巨像的勇气"在 `Haikesi_Modifier.sql:201`）+ 征服模式专属选项（预生成修饰器见 `CC_Modifier.sql`）。

## 6. Suggested skills（下一 agent 应调用）

- **domain-modeling** — 文档与实现阶段持续维护 `CONTEXT.md` 与 `docs/adr/`（本项目既有纪律）。
- 实现阶段若任务拆解变大，可用 **to-tickets** 拆批次；读 mod 源码与框架 `EventBuilder.lua` 无需额外 skill。
