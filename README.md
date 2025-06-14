# 关于本项目

本项目用于上传脚本机制到超先行888服。

# 上传流程

对于不影响 ocgcore 或者 ygopro 主程序的脚本机制测试，步骤如下“”

1. （可选但建议）在 https://github.com/Fluorohydride/ygopro-scripts 提交相关的脚本 PR。
2. 把 PR 的分支合并到 https://code.moenext.com/mycard/ygopro-scripts-888 （本项目）内。
3. 在https://code.moenext.com/mycard/pre-release-database-cdb 创建 script-fix-xxx.cdb 列出正在测试的卡。

完成上述步骤后，ygopro-scripts-888 分支和正式脚本库的差异部分，会自动更新到 888 服务器。
每次 YGOPro 正式更新，需要把 ygopro-scripts-888 仓库 reset 到最新的正式脚本版本。
本方法测试的 BUG 进度在表格的「内核更新测试记录」标签页追踪。