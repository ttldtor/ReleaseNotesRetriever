import std.stdio;
import std.file;
import std.regex;
import std.process;
import std.range;

void main() {
    immutable releaseNotesVersionPattern = environment.get("RELEASE_NOTES_VERSION_PATTERN", 
    `^v[0-9]+\.[0-9]+\.[0-9]+.*$`);
    immutable releaseNotesVersionToRetrieve = environment.get("RELEASE_NOTES_VERSION_TO_RETRIEVE", ``);

    auto versionFirstMet = false;
    auto probablyEmptyLinesInReleaseNotesTextNumber = 0;
    auto wasReleaseNotesText = false;

    foreach(i, line; stdin.byLine.enumerate) {
        if (!releaseNotesVersionToRetrieve.empty && !versionFirstMet) {
            if (line == releaseNotesVersionToRetrieve) {
                versionFirstMet = true;
            }

            continue;
        }

        if (versionFirstMet) {
            if (line.empty) {
                if (wasReleaseNotesText) {
                    probablyEmptyLinesInReleaseNotesTextNumber++;
                }
            } else if (line.matchFirst(releaseNotesVersionPattern)) {
                break;
            } else {
                wasReleaseNotesText = true;

                if (probablyEmptyLinesInReleaseNotesTextNumber > 0) {
                    foreach (j; 0 .. probablyEmptyLinesInReleaseNotesTextNumber) {
                        writeln;
                    }

                    probablyEmptyLinesInReleaseNotesTextNumber = 0;
                }
            
                writeln(line);
            }
        } else {
            if (!releaseNotesVersionToRetrieve.empty && !versionFirstMet) {
                if (line == releaseNotesVersionToRetrieve) {
                    versionFirstMet = true;
                }

                continue;
            }
            if (line.matchFirst(releaseNotesVersionPattern)) {
                versionFirstMet = true;
            }
        }
    }
}