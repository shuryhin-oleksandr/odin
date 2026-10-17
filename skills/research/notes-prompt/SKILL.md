---
name: notes-prompt
description: Original prompt the notes skill was generated from, kept verbatim to compare against /notes. Run manually as /notes-prompt <source>.
disable-model-invocation: true
---

Source: $ARGUMENTS

Read source end to end. 

Create a summary and write to md file.
File name should be: `<name of source>, <author>.md`.
AskUserQuestion to confirm file name before writing.

Sections in article should become headers in file. 
For each header - write main thoughts in bullet points.
