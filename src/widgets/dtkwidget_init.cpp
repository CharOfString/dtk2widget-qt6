// DTK2的Qt6移植的「运行时引导程序」

// 当libdtk2widget.so.6被映射到进程中，例如使用此库的程序的main开始初始化时，阻止Qt加载系统的chameleon样式插件（此时系统会加载基于libdtk6widget的chameleon，与我们ABI不兼容），阻止后我们加载我们自己修改的dstyleplugin-gxde-qt6（暂定名称，即自己的样式插件，基于旧版chameleon移植）

// 这里的环境变量设置为overwrite=0，允许外部的环境变量或者-style flag覆盖设置

// TODO: 不优雅，后期需要改为更优雅的实现，目前只保证能运行

#include <stdlib.h>

namespace {

__attribute__((constructor(101)))

void dtk2widget_qt6_bootstrap()
{
    setenv("QT_STYLE_OVERRIDE", "dlight2", 0);
}

}  // namespace
