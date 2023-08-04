# Git Commit History Standard

To maintain a clear and orderly Git commit history, we have established the following Git commit standards. All team members should comply.

Commit Message Structure

Each commit message should include two parts: a header and a body. The header should be brief and clear, no more than 50 characters. The body part is a detailed description of the changes, which can be divided into multiple lines, each no more than 72 characters.

Here is an example of a commit message:

<type>: <subject>
<body>

Here, <type>, <subject>, and <body> need to be replaced with actual content.

Type

Commit types include the following:

feat: new feature
fix: fix a bug
docs: documentation
style: formatting (changes that do not affect how the code runs)
refactor: refactoring (neither a new feature nor a bug fix)
test: adding tests
chore: changes in build process or auxiliary tools

If the type is feat and fix, then the commit will appear in the Change log. Whether to include other situations (docs, chore, style, refactor, test) in the Change log is up to you.

Subject

The <subject> is a brief description of the changes, no more than 50 characters.

Here are some rules:
- Start with a verb, use the first person present tense, like "change", instead of "changed" or "changes".
- The first letter should be lowercase.
- No full stop (.) at the end.

Body

The <body> is a detailed description of the changes, which can be divided into multiple lines.

Here are some rules:
- Use the first person present tense, like "change", instead of "changed" or "changes".
- Explain the motivation for the code changes, as well as a comparison with previous behavior.

Pull Request Workflow

Submit a Pull Request to the main repository on GitHub. After code review, your modifications are accepted and merged into the main repository.

Git Merge Workflow

To merge the code of the remote dev_ydj branch into the remote main branch, you can follow these steps:

Make sure you are currently in the main branch of your local repository (usually the main branch). If not, switch to the main branch:
```bash
git checkout main
```
Pull the latest code from the remote main branch to ensure your local main branch is up-to-date:
```bash
git pull origin main
```
Merge the code from the remote dev_ydj branch into the local main branch. Use the following command to merge the remote dev_ydj branch into the local main branch:
```bash
git merge dev_ydj
```
If there are conflicts, resolve them and commit the changes.

Push the changes of the local main branch to the remote main branch:
```bash
git push origin main
```
This way, the code from your remote dev_ydj branch will be merged into the remote main branch.

Please note, the above steps assume that you have added the remote repository as "origin". If your remote repository name is not "origin", please replace "origin" in the commands with the corresponding remote repository name. Also, make sure to back up important code before performing these operations.
