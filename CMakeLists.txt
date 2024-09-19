cmake_minimum_required(VERSION 3.5)

project(rosidl_generator_dart)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_python REQUIRED)
find_package(rosidl_generator_c REQUIRED)


ament_export_dependencies(rosidl_cmake)
ament_export_dependencies(rosidl_generator_c)

ament_python_install_package(${PROJECT_NAME})

ament_index_register_resource("rosidl_generator_packages")

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

endif()

install(
  PROGRAMS bin/rosidl_generator_dart
  DESTINATION lib/rosidl_generator_dart
)

install(
  DIRECTORY cmake resource
  DESTINATION share/${PROJECT_NAME}
)

ament_package(
  CONFIG_EXTRAS "cmake/rosidl_generator_dart_get_typesupports.cmake"
    "cmake/register_dart.cmake"
    "rosidl_generator_dart-extras.cmake.in"
)
