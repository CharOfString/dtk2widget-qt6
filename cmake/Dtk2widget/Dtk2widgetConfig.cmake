# DTK2Widget的安装目录，故意将DTK2WIDGET_TOOL_DIR设置为libdtk-6.0.1/D2widget/bin以与Qt5版区分

find_package(Dtk REQUIRED Core)
set(DTK2WIDGET_INCLUDE_DIR /usr/include/dtk2/DWidget)
set(DTK2WIDGET_TOOL_DIR /usr/lib/x86_64-linux-gnu/libdtk-6.0.1/D2widget/bin)
set(Dtk2widget_LIBRARIES dtk2widget ${DtkCore_LIBRARIES})
include_directories("${DTK2WIDGET_INCLUDE_DIR}")
