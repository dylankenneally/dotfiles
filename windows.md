# Windows development machine setup notes

## Utils I use heavily
Download the following to a utils folder, and update the `PATH` environment variable to point to that folder
- [7-zip](https://www.7-zip.org/download.html)
- [curl](https://curl.haxx.se/windows/)
- [Dependency Walker](http://www.dependencywalker.com/)
- [Process Explorer](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- [Cpp Check](http://cppcheck.sourceforge.net/)
- [WinDiff / WinMerge](https://portableapps.com/apps/utilities/winmerge_portable)
  - Note that this comes as `WinMergePortable.exe`, to use as `windiff` create a batch file with the following content in the same directory as the executable, `%*` passes all arguments given to `windiff.cmd` to `WinMergePortable`
```bash
WinMergePortable %*
```
