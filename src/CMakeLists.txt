remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_STRICT_ITERATORS -DQT_NO_CAST_FROM_BYTEARRAY -DQT_NO_URL_CAST_FROM_STRING)

set(clipSRCS
    code/main.cpp
    code/genresbackend.cpp
    code/countrybackend.cpp
    code/languagebackend.cpp
    code/mpvrenderer.cpp
    code/qthelper.hpp)

set(clip_ASSETS
    assets/assets.qrc)

if(ANDROID)
    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${clipSRCS}
        ${clip_ASSETS})
    set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android_files)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/android_files/version.gradle.in ${CMAKE_BINARY_DIR}/src/version.gradle)
else()
    list(APPEND clipSRCS)
    #qt_add_dbus_interface(clipSRCS controllers/linux/org.freedesktop.ScreenSaver.xml screensaverdbusinterface)
    qt_add_executable(${PROJECT_NAME}
        ${clipSRCS}
        ${clip_ASSETS})
endif()

qt_add_qml_module(${PROJECT_NAME} URI org.kde.novalive
    NO_PLUGIN
    QML_FILES
    controls/main.qml
    controls/APIKeyYouTube1.qml
    controls/APIKeyYouTube2.qml
    controls/APIKeyYouTube3.qml
    controls/Country.qml
    controls/Favorites.qml
    controls/Genres.qml
    controls/Home.qml
    controls/Language.qml
    controls/Notifications.qml
    controls/Search.qml
    controls/SettingsDialog.qml
    controls/SoulFunk.qml
    controls/StationsByCountry.qml
    controls/StationsByGenre.qml
    controls/StationsByLanguage.qml
    controls/YouTube.qml)

if (ANDROID)
    find_package(OpenSSL REQUIRED)

    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        Qt6::QuickControls2
        OpenSSL::SSL)

    message(${ANDROID_SDK_ROOT})

    # include(${ANDROID_SDK_ROOT}/openssl/android_openssl.cmake)
    # add_android_openssl_libraries(${PROJECT_NAME})

    # set_property(TARGET ${PROJECT_NAME} PROPERTY QT_ANDROID_EXTRA_LIBS
    #     ${ANDROID_SDK_ROOT}/openssl/ssl_3/arm64-v8a/libcrypto.so
    #     ${ANDROID_SDK_ROOT}/openssl/ssl_3/arm64-v8a/libssl.so)
else()
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        Qt6::DBus
        Qt6::Widgets)
endif()

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_compile_options(${PROJECT_NAME} PRIVATE -fexceptions)

if(MPV_AVAILABLE)
    target_link_libraries(${PROJECT_NAME} mpv)
    add_definitions(-DMPV_AVAILABLE)
    target_compile_definitions(${PROJECT_NAME} PUBLIC MPV_AVAILABLE)
endif()

set(Taglib_LIBRARIES
    TagLib::tag)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit4
    MauiKit4::FileBrowsing
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    Qt6::Widgets
    Qt6::Multimedia
    KF6::I18n
    KF6::CoreAddons
    KF6::ConfigCore
    PkgConfig::MPV
    ${AVCODEC_LIBRARIES}
    ${AVFORMAT_LIBRARIES}
    ${SWSCALE_LIBRARIES}
    ${AVUTIL_LIBRARIES}
    ${AVFILTER_LIBRARIES}
    ${Taglib_LIBRARIES})

qt_finalize_target(${PROJECT_NAME})
