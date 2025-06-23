========================================
You just installed `DllMain`.
This package allows you to define a `DllMain` function for your NativeAOT library in plain C.
========================================

To get started:
- Create a `.c` file in your project,
- Define a `DllMain` function in that file,
- Add `<DllMainSourceFile>YourCFile.c</DllMainSourceFile>` to your `.csproj` file.

Here's what your `DllMain` function might look like - feel free to copy.

```
#include <windows.h>

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    DisableThreadLibraryCalls(hinstDLL);
    if (fdwReason == DLL_PROCESS_ATTACH) {
        // Your code here
    }
    return TRUE;
}
```

Tips:

- To call methods from your .NET code, mark them with `UnmanagedCallersOnlyAttribute` and specify the entry point.
  You can then declare the same function in your C code as external, and call it as needed.
  C#: `[UnmanagedCallersOnly(CallConvs = [typeof(CallConvStdcall)], EntryPoint = "HookedMethod")] public static void HookedMethod() { }`
  C: `void __stdcall HookedMethod();`

- Remember that any code directly inside `DllMain` will run under a loader lock.
  Here's a list of do-s and don't-s for your code: https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-best-practices#general-best-practices

- Remember that your first call to any .NET method will force NativeAOT runtime initialization to occur before your code runs.
  The NativeAOT runtime does not support initialization under loader lock.
  Do not call your .NET method inside `DllMain`. Instead, inject it via a hook, or create a new thread.
