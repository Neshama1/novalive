# CMake generated Testfile for 
# Source directory: /home/mike/Devel/GitHub/novalive
# Build directory: /home/mike/Devel/GitHub/novalive/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(appstreamtest "/usr/bin/cmake" "-DAPPSTREAMCLI=/usr/bin/appstreamcli" "-DINSTALL_FILES=/home/mike/Devel/GitHub/novalive/build/install_manifest.txt" "-P" "/usr/share/ECM/kde-modules/appstreamtest.cmake")
set_tests_properties(appstreamtest PROPERTIES  _BACKTRACE_TRIPLES "/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;168;add_test;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;187;appstreamtest;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;0;;/home/mike/Devel/GitHub/novalive/CMakeLists.txt;54;include;/home/mike/Devel/GitHub/novalive/CMakeLists.txt;0;")
subdirs("src")
