# Release Notes Retiever

[![Release](https://img.shields.io/github/v/release/ttldtor/ReleaseNotesRetiever)](https://github.com/ttldtor/ReleaseNotesRetiever/releases/latest)
[![License](https://img.shields.io/badge/license-Unlicense-orange)](https://github.com/ttldtor/ReleaseNotesRetiever/blob/master/LICENSE)

**A utility that helps retrieve lines from Release Notes that refer to the latest version of an application or 
library mentioned there, or to a specified version.**

Key features:

- receives on stdin a stream of lines from the ReleaseNotes file
- according to the pattern specified in the environment variable, determines what is information about the version of the application
- according to the specified version in the environment variable, finds information about this version
- if the version is not specified, then finds information about the latest version
- output to stdout a stream of lines related to the application version

Possible environment variables:

|Name|Description|Default Value|Example|
|----|-----------|-------------|-------|
|RELEASE_NOTES_VERSION_PATTERN|Template for version matching. Specified as RegExp|`^v[0-9]+\.[0-9]+\.[0-9]+.*$`|`^[0-9]+\.[0-9]+\.[0-9]+.*$`|
|RELEASE_NOTES_VERSION_TO_RETRIEVE|The version of the application or library for which you want to find information in the ReleaseNotes||`v2.0.0`|

## Examples

Possible ReleaseNotes format:

```txt
<Some header that will not be included in the output>
<An empty string that will not be included in the output>
<Version with pattern `^v[0-9]+\.[0-9]+\.[0-9]+.*$` for example>
<An empty string that will not be included in the output>
<Text describing changes related to any version. This text will be taken into account in the output>
<An empty string that will be included in the output>
<Text describing changes related to any version. This text will be taken into account in the output>
<An empty string that will not be included in the output>
<Version with pattern `^v[0-9]+\.[0-9]+\.[0-9]+.*$` for example>
<An empty string that will not be included in the output>
<Text describing changes related to any version. This text will be taken into account in the output>
<Text describing changes related to any version. This text will be taken into account in the output>
```

Example:

```md
Release Notes
==

v2.0.0

- Fixed something

- Added some changes

v1.0.0

- Implemented something
- Init release
```

Example of usage #1:

```powershell
Get-Content "C:\Project\ReleaseNotes.md" | & rdmd ./rnr.d
```

Example of output #1:

```powershell
- Fixed something

- Added some changes
```

Example of usage #2:

```powershell
$env:RELEASE_NOTES_VERSION_TO_RETRIEVE = 'v1.0.0'
Get-Content "C:\Project\ReleaseNotes.md" | & rdmd ./rnr.d
```

Example of output #2:

```powershell
- Implemented something
- Init release
```

Example of usage #3:

```bash
export RELEASE_NOTES_VERSION_PATTERN='v[0-9]+\.[0-9]+\.[0-9]+.*$'
export RELEASE_NOTES_VERSION_TO_RETRIEVE='v1.0.0'
cat ~/Project/ReleaseNotes.md | rdmd ./rnr.d
```

Example of output #3:

```powershell
- Implemented something
- Init release
```
