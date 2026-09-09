# 以 Events Popup Framework 为弹窗底座，而非自写 UI

复用 3247819643 框架的 UI 与回传链路，只补它缺的部分（.modinfo、触发器层、冷却），不另起炉灶写弹窗界面。

框架已具备本 mod 需要的绝大部分能力：2~6 个动态选项、每选项图标/tooltip/置灰与置灰原因、多事件排队、以及 options → `RequestPlayerOperation(EXECUTE_SCRIPT)` 的联机安全回传（与通宝、收藏品、海克斯的落地方式一致）。自写 UI 要重新解决排队和多选项布局，收益为负。

代价：框架副本缺 .modinfo，需自建并注册 UI context、保证加载顺序；框架的选项回调分发样板（"MANDATORY COPY PASTE" 段）必须逐个事件复制，且模板中 D/E/F 回调有 `pPlayer` 未定义的 bug，需自行修正。
