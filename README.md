teacher-mitArchive-git
======================
1. files
courses.txt : a list of all courses. Each course takes 5 lines: 1-course number, 2-course name, 
  3-the semester in which being taught, 4-level(Undergraduate/graduate), 5-relative path on web
missingZip.list: a list of 10 courses that I could not find "material.zip" online.

2. directories
The materials of each course is located at $git_root/$courseName($semester)/material/*/contents/
Typical contents include: lecture-notes, assignments, syllabus, readings etc.
All the pdf's are changed into text, named .pdftxt. All htm's are changed into .htmtxt.
The pdf's are removed.
Other file types including .m, .mat, .M, .py, .dat, .py, .srt are remained.

3. remaining problems
Text files are NOT tokenized or stemmed.
There are possible spaces inside words, due to pdf2txt.
Some files (not uploaded to git) are in other zips (e.g. homework1.zip includes homework1.pdf).

-- Wanli
