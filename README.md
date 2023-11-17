# reaper_api_template
REAPER C++ extension template using premake5

## Dependencies
- [premake](https://premake.github.io/) - If the installer doesn't do it for you, ensure that **premake** is added to your system's PATH environment variable

## Cloning
- Open a command line and clone this repository, making sure to include submodules. For example, using the GitHub CLI:
```
gh repo clone acendan/reaper_api_template -- --recurse-submodules
```
_Yes, the extra set of "--" is necessary for passing git clone flags to gh..._

## Generating Project Files
- Open **./premake5.lua** in a text editor and add your user-specific settings to the `users` table.
  - The key with your username should be the same as your USERNAME (Windows) or USER (Mac, Linux) environment variable. You can check this in a command line with `echo %USERNAME%` on Windows or `echo $USER` on Mac and Linux.

- Navigate to the root **reaper_api_template** folder in a command line. Then run the following command depending on your OS:
  - Windows
    ```
    premake5 vs2022
    ```
  - Mac
    ```
    premake5 xcode4
    ```
  - Linux
    ```
    premake5 gmake2
    ```
    
- If all goes well, you should be able to find and open the generated project file in the **reaper_api_template/build** folder!

### CLion Projects
- If using CLion, the .idea folder at the root of this repo is set up to build Debug and Release configs
- When running `premake5 gmake2` on Linux, the script should automatically update the `.idea/workspace.xml` file's `PROJECT_NAME`, `RUN_PATH`, and `PROGRAM_PARAMS` variables accordingly

## Building & Debugging
- This will vary greatly depending on OS, but by using premake, you should be able to build and debug using the toolset provided by your given IDE.
- There is a post build step that copies the generated library to your local **REAPER/UserPlugins** folder. You will need to have REAPER closed for this step to work, as the copy command will fail if the library is actively being used by REAPER.

### MacOS Universal Binaries
- Universal binaries run natively on both Apple Silicon (M-series chips) and Intel CPUs
- Ensure you are building universal binaries in XCode by going to the project settings > Build Settings > Architectures > Standard Architectures (Apple Silicon, Intel)
- After building, ensure that the built binary supports both x86_64 and arm64 by running the following command in a Terminal:
```
lipo -archs ./bin/macosx/release/reaper_api_template.dylib
```

## GitHub Releases
- Replace <0.1.0> in the following command with the new version tag for your release!
```
gh release create 0.1.0 ./bin/linux/release/reaper_api_template.so ./bin/windows/release/reaper_api_template.dll ./bin/macosx/release/reaper_api_template.dylib  
```

- To download the latest (from anywhere on your filesystem), run:
```
gh release download --repo acendan/reaper_api_template --pattern '*'
```
