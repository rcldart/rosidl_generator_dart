@{
from rosidl_generator_dart import get_field_name
from rosidl_generator_dart import get_dart_type
from rosidl_generator_dart import get_dart_type_for_message
from rosidl_generator_dart import get_builtin_dart_type
from rosidl_generator_dart import constant_value_to_dotnet

from rosidl_parser.definition import AbstractNestedType
from rosidl_parser.definition import AbstractGenericString
from rosidl_parser.definition import AbstractString
from rosidl_parser.definition import AbstractWString
from rosidl_parser.definition import AbstractSequence
from rosidl_parser.definition import Array
from rosidl_parser.definition import BasicType
from rosidl_parser.definition import NamespacedType

type_name = service.namespaced_type.name

request_type_name = get_dart_type_for_message(service.request_message)
response_type_name = get_dart_type_for_message(service.response_message)

srv_typename = '%s__%s' % ('__'.join(service.namespaced_type.namespaces), type_name)
}
namespace @('.'.join(service.namespaced_type.namespaces))
{
@# sealed class with private constructor -> no instance can be created
@# static classes can't implement an interface (or any other basetype),
@# but we need some type that can hold the typesupport and be passed to the Node.CreateService() method.
@# So sealed + private constructor is as static as it gets.
@# static abstract interface members are currently in preview, so maybe we could use the feature in the future.
@# (if hey add support to derive from static only interfaces in static classes)
@# Another option is to not use generics for passing the typesupport, but lets try this until we hit some wall.
    public sealed class @(type_name) : global::ROS2.IRosServiceDefinition<
        global::@(request_type_name),
        global::@(response_type_name)>
    {
        private static readonly DllLoadUtils dllLoadUtils;

        private @(type_name)()
        {
        }

        static @(type_name)()
        {
            dllLoadUtils = DllLoadUtilsFactory.GetDllLoadUtils();
            IntPtr nativelibrary = dllLoadUtils.LoadLibrary("@(package_name)__dotnetext");

            IntPtr native_get_typesupport_ptr = dllLoadUtils.GetProcAddress(nativelibrary, "@(srv_typename)__get_typesupport");

            @(type_name).native_get_typesupport = (NativeGetTypeSupportType)Marshal.GetDelegateForFunctionPointer(
                native_get_typesupport_ptr, typeof(NativeGetTypeSupportType));
        }

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate IntPtr NativeGetTypeSupportType();

        private static NativeGetTypeSupportType native_get_typesupport = null;

@# This method gets called via reflection as static abstract interface members are not supported yet.
        [global::System.ComponentModel.EditorBrowsable(global::System.ComponentModel.EditorBrowsableState.Never)]
        public static IntPtr __GetTypeSupport() {
            return native_get_typesupport();
        }
    }
}
