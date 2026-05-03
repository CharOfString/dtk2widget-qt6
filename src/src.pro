# DTK2的Qt6移植修改
# 1. 命名: 采用类似libdtk2widget.so.6.0.1 / dtk2widget.pc / /usr/include/dtk2/DWidget的命名，与Qt5 DTK2区分并共存
# 2. SONAME版本号改为6

TARGET = dtk2widget
VERSION = 6.0.1
isEmpty(INCLUDE_INSTALL_DIR): INCLUDE_INSTALL_DIR = $$PREFIX/include/dtk2
isEmpty(includes.path):       includes.path = $$INCLUDE_INSTALL_DIR/DWidget
TEMPLATE = lib
QT += dtkcore
include($$PWD/../dtk_build.prf)

CONFIG += internal_module

# 暂时禁用多媒体支持
DTK_NO_MULTIMEDIA = 1

QT += network concurrent multimedia multimediawidgets
qtHaveModule(statemachine): QT += statemachine
QT += widgets widgets-private gui-private

linux* {
    QT += dbus
    # Qt6：QX11Info好像移到了QPA Private头

    ###(zccrs): use load(dtk_qmake), dtkcore > 2.0.9
    ARCH = $$QMAKE_HOST.arch
    isEqual(ARCH, sw_64) | isEqual(ARCH, mips64) | isEqual(ARCH, mips32) {
        DEFINES += FORCE_RASTER_WIDGETS
    }
}

mac* {
    QT += svg dbus
    DEFINES += DTK_TITLE_DRAG_WINDOW
}

win* {
    QT += svg
    DEFINES += DTK_TITLE_DRAG_WINDOW
}
QT += multimedia multimediawidgets
!isEmpty(DTK_NO_MULTIMEDIA){
    DEFINES += DTK_NO_MULTIMEDIA

}

!isEmpty(DTK_STATIC_LIB){
    DEFINES += DTK_STATIC_LIB
    CONFIG += staticlib
}

HEADERS += dtkwidget_global.h

includes.files += \
    $$PWD/dtkwidget_global.h\
    $$PWD/DtkWidgets\
    $$PWD/dtkwidget_config.h

include($$PWD/util/util.pri)
include($$PWD/widgets/widgets.pri)

linux* {
    includes.files += $$PWD/platforms/linux/*.h
}
win32* {
    includes.files += $$PWD/platforms/windows/*.h
}

# create DtkWidgets file
defineTest(containIncludeFiles) {
    header = $$absolute_path($$ARGS)
    header_dir = $$quote($$dirname(header))

    for (file, includes.files) {
        file_ap = $$absolute_path($$file)
        file_dir = $$quote($$dirname(file_ap))

        isEqual(file_dir, $$header_dir):return(true)
    }

    return(false)
}

defineTest(updateDtkWidgetsFile) {
    dtkwidgets_include_files = $$HEADERS
    dtkwidgets_file_content = $$quote($${LITERAL_HASH}ifndef DTK_WIDGETS_MODULE_H)
    dtkwidgets_file_content += $$quote($${LITERAL_HASH}define DTK_WIDGETS_MODULE_H)

    for(header, dtkwidgets_include_files) {
        containIncludeFiles($$header) {
            dtkwidgets_file_content += $$quote($${LITERAL_HASH}include \"$$basename(header)\")
        }
    }

    dtkwidgets_file_content += $$quote($${LITERAL_HASH}endif)
    !write_file($$PWD/DtkWidgets, dtkwidgets_file_content):return(false)

    return(true)
}

!updateDtkWidgetsFile():warning(Cannot create "DtkWidgets" header file)

# create dtkwidget_config.h file
defineTest(updateDtkWidgetConfigFile) {
    for(file, includes.files) {
        file = $$quote($$basename(file))

        !isEqual(file, DtkWidgets):contains(file, D[A-Za-z0-9_]+) {
            dtkwidget_config_content += $$quote($${LITERAL_HASH}define DTKWIDGET_CLASS_$$file)
        }
    }

    !write_file($$PWD/dtkwidget_config.h, dtkwidget_config_content):return(false)

    return(true)
}

!updateDtkWidgetConfigFile():warning(Cannot create "dtkwidget_config.h" header file)

INSTALLS += includes target

include($$PWD/../dtk_cmake.prf)

include($$PWD/../dtk_module.prf)
