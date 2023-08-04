# Git Commit Message Guidelines

We've established these guidelines to ensure Git commit records are clear and orderly. All team members should follow them.

### Commit Message Structure

Each commit message should have a header and a body. The header should be brief and clear, not exceeding 50 characters. The body provides a detailed description of changes and can span multiple lines, each under 72 characters.

Example of a commit message:

<type>: <subject>

<body>

Replace `<type>`, `<subject>`, and `<body>` with your content.

### Type

Commit types include:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Format changes (do not affect code execution)
- `refactor`: Refactor (code changes not related to new features or bug fixes)
- `test`: Added tests
- `chore`: Build process or auxiliary tool changes

If `type` is `feat` or `fix`, the commit appears in the Change log. For other types, it's your decision to include them in the Change log.

### Subject

`<subject>` is a brief change description, under 50 characters.

Rules:

- Start with a verb in the first person present tense, e.g., `change`, not `changed` or `changes`
- Begin with a lowercase letter
- Don't end with a period

### Body

`<body>` is a detailed change description and can span multiple lines.

Rules:

- Use the first person present tense, e.g., `change`, not `changed` or `changes`
- Explain the reason for the code changes and compare with the previous behavior

# Pull Request Process

1. Submit a Pull Request to the main repository on GitHub.
2. After code review, your changes are accepted and merged into the main repository.

# Git Merge Process

To merge code from the remote `dev_ydj` branch into the remote `main` branch, follow these steps:

1. Ensure you're on the main branch of the local repository. If not, switch to it:

    ```
    git checkout main
    ```
    
2. Pull the latest code from the remote `main` branch to ensure your local branch is updated:

    ```
    git pull origin main
    ```
    
3. Merge the remote `dev_ydj` branch code into the local main branch:

    ```
    git merge dev_ydj
    ```
    
4. If there are conflicts, resolve them and commit the changes.
5. Push the changes of the local main branch to the remote `main` branch:

    ```
    git push origin main
    ```
    

This merges the code from your remote `dev_ydj` branch into the remote `main` branch.

Note: The steps above assume you've added the remote repository as `origin`. If not, replace `origin` in the commands with your remote repository name. Always backup important code before these operations.
