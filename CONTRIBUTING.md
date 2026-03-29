# Contributing

We welcome all contributions to this project! Please read on for steps on how to contribute based on your relationship to this project.

## Reporting Bugs or Requesting Features

If you notice a bug, or have a feature request, please open up an issue [here](https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-5/issues). When opening an issue, please provide as much detail as possible, including steps to reproduce the bug if possible/applicable.

## Core Team Members

Core team members should follow a GitHub Flow branching workflow directly within the main repository:

1. Make sure your local `main` branch is up to date:
   ```bash
   git checkout main
   git pull origin main
   ```
2. Create a new branch for your feature or fix, using a descriptive name:
   ```bash
   git checkout -b your-branch-name
   ```
3. Make your changes and commit them with a clear, descriptive commit message:
   ```bash
   git add .
   git commit -m "Short description of your changes"
   ```
4. Push your branch to the repository:
   ```bash
   git push origin your-branch-name
   ```
5. Open a pull request against `main` on GitHub. Pull requests will be reviewed within **7 days**.
6. Once approved, your branch will be merged and can then be deleted.

## Arms-Length Contributors

If you are not a core team member, please contribute via a fork:

1. Fork the repository using the **Fork** button on GitHub.
2. Clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/dsci-310-group-5.git
   cd dsci-310-group-5
   ```
3. Create a new branch for your changes:
   ```bash
   git checkout -b your-branch-name
   ```
4. Make your changes and commit them with a clear, descriptive commit message:
   ```bash
   git add .
   git commit -m "Short description of your changes"
   ```
5. Push to your fork:
   ```bash
   git push origin your-branch-name
   ```
6. Open a pull request against the `main` branch of the original repository. Pull requests will be reviewed within **7 days**.

## Code of Conduct

All contributors must abide by our [code of conduct](CODE_OF_CONDUCT.md).

---

Template for contributing guidelines adapted from:
- [DSCI 310 Milestone 1 CONTRIBUTING.md template](https://ubc-dsci.github.io/dsci-310-student/project/m1.html)
