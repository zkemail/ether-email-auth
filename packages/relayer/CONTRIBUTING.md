# Contributing to Relayer

Thank you for considering contributing to our project! We welcome contributions of all kinds, including code, documentation, bug reports, feature requests, and more. This document outlines the process for contributing to this project.

## Table of Contents
- [Contributing to Relayer](#contributing-to-relayer)
  - [Table of Contents](#table-of-contents)
  - [1. Code of Conduct](#1-code-of-conduct)
  - [2. Getting Started](#2-getting-started)
  - [3. Coding Guidelines](#3-coding-guidelines)
  - [4. Testing](#4-testing)
  - [5. Commit Messages](#5-commit-messages)
  - [6. Pull Request Process](#6-pull-request-process)
  - [7. Contact](#7-contact)

## 1. Code of Conduct
We are committed to providing a welcoming and inspiring community for all and expect our Code of Conduct to be honored. Anyone who violates this code of conduct may be banned from the community.

Our community strives to:

- **Be friendly and patient.**
- **Be welcoming**: We strive to be a community that welcomes and supports people of all backgrounds and identities.
- **Be considerate**: Your work will be used by other people, and you in turn will depend on the work of others.
- **Be respectful**: Not all of us will agree all the time, but disagreement is no excuse for poor behavior and poor manners.
- **Be careful in the words that you choose**: We are a community of professionals, and we conduct ourselves professionally.
- **Be kind to others**: Do not insult or put down other participants. Harassment and other exclusionary behavior aren't acceptable.

This includes, but is not limited to:

- Violent threats or language directed against another person.
- Discriminatory jokes and language.
- Posting sexually explicit or violent material.
- Posting (or threatening to post) other people's personally identifying information ("doxing").
- Personal insults, especially those using racist or sexist terms.
- Unwelcome sexual attention.
- Advocating for, or encouraging, any of the above behavior.
- Repeated harassment of others. In general, if someone asks you to stop, then stop.

Moderation

These are the policies for upholding our community’s standards of conduct. If you feel that a thread needs moderation, please contact the community team at [paradox@pse.dev](mailto:paradox@pse.dev).

1. **Remarks that violate the Relayer Utils standards of conduct, including hateful, hurtful, oppressive, or exclusionary remarks, are not allowed.** (Cursing is allowed, but never targeting another user, and never in a hateful manner.)
2. **Remarks that moderators find inappropriate, whether listed in the code of conduct or not, are also not allowed.**
3. **Moderators will first respond to such remarks with a warning.**
4. **If the warning is unheeded, the user will be “kicked,” i.e., temporarily banned from the community.**
5. **If the user comes back and continues to make trouble, they will be banned permanently from the community.**
6. **Moderators may choose at their discretion to un-ban the user if it was a first offense and they offer the offended party a genuine apology.**
7. **If a moderator bans someone and you think it was unjustified, please take it up with that moderator, or with a different moderator, in a private discussion.**

**Please try to emulate these behaviors, especially when debating the merits of different options.**

Thank you for helping make this a welcoming, friendly community for all.

This Code of Conduct is adapted from the [Contributor Covenant](https://www.contributor-covenant.org), version 1.4, available at [https://www.contributor-covenant.org/version/1/4/code-of-conduct.html](https://www.contributor-covenant.org/version/1/4/code-of-conduct.html)


## 2. Getting Started
To start contributing, follow these steps:

1. Fork the repository.
2. Clone your fork to your local machine:
    ```bash
    git clone https://github.com/zkemail/relayer-utils.git
    ```
3.	Create a new branch for your feature or bugfix:
    ```bash
    git checkout -b feat/your-feature-name
    ```
4.	Install the necessary dependencies:
    ```bash
    cargo build
    ```
5.	Make your changes.

## 3. Coding Guidelines

Please follow the coding guidelines in [CODING_GUIDELINES.md](CODING_GUIDELINES.md) when contributing to this project.

## 4. Testing

Please write tests for your contributions. We aim for high test coverage.

	•	Unit Tests: Place unit tests in the same file as the code they are testing.
	•	Integration Tests: Place integration tests in the tests/ directory.

Run all tests before submitting your code with cargo test.

Run all tests before submitting your code with cargo test.

## 5. Commit Messages

Use conventional commit messages for your commits. This helps us automatically generate the changelog and follow semantic versioning.

    •	Format: `<type>: <description>`
    •	Example: `feat: add new feature`

For more information, see [Conventional Commits](https://www.conventionalcommits.org/).

## 6. Pull Request Process

	1.	Ensure your branch is up-to-date with the main branch:
	•	git fetch origin
	•	git checkout main
	•	git merge origin/main
	2.	Push your branch to your fork:
	•	git push origin feature/your-feature-name
	3.	Open a pull request from your branch to the main branch of the original repository.
	4.	Ensure that your pull request passes all checks (e.g., CI tests).
	5.	A reviewer will review your pull request. Be prepared to make adjustments based on feedback.

## 7. Contact

If you have any questions or need further assistance, feel free to open an issue or contact us at [paradox@pse.dev](mailto:paradox@pse.dev).

Thank you for your contributions!