## DllMain

This appropriately named package allows you to **safely** define a `DllMain` function for your NativeAOT library in plain C.

### Getting started

Add the [DllMain](https://www.nuget.org/packages/DllMain) NuGet package to your project, then follow the instructions from [readme.txt](readme.txt).

### How this works

The NativeAOT toolchain declares multiple MSBuild targets to build/link the NativeAOT library. Among other things, it injects an [object file](https://github.com/dotnet/runtime/blob/main/src/coreclr/nativeaot/Bootstrap/dllmain/dllmain.cpp) that defines an empty `DllMain` function, in an effort to avoid user-defined `DllMain` .NET implementations, since the NativeAOT runtime doesn't support initialization under `DllMain`'s loader lock.

This package declares another target that gets injected between [SetupOSSpecificProps](https://github.com/dotnet/runtime/blob/main/src/coreclr/nativeaot/BuildIntegration/Microsoft.NETCore.Native.Windows.targets) (which builds `LinkerArg`) and [LinkNative](https://github.com/dotnet/runtime/blob/main/src/coreclr/nativeaot/BuildIntegration/Microsoft.NETCore.Native.targets) (which calls the linker with those arguments). This target:
- Builds the user-defined `.c` file,
- Removes the toolchain-defined object file with an empty `DllMain` from linker arguments,
- Adds compiled user-defined C code to linker arguments.

As long as the user doesn't call managed code from their `DllMain` function, the resulting library should not break any rules imposed by the OS or the NativeAOT runtime/toolchain.
