Thanks!

Splunk Nova wouldn't be what it is without your help. Thanks for contributing.
Please make your contributions as pull requests via GitHub. [See](#its-my-first-time-on-github-ever-what-do-i-do).

# Submitting a Pull Request

## Before You Start!

- Fork the repository. If you have an existing fork, please make sure it's up to date by syncing the repo. See the [Fork A Repo](https://help.github.com/articles/fork-a-repo) article.

- Create a branch before you start working. Name this branch for what you plan to change such as `fix-typo-in-readme`. To created a local brach, you can use `git checkout -b new-branch-name`.

## Before Submitting, run Tests

- Please run `bundle exec rake test ` from the terminal before you submit. It runs our test suite.

```
$ bundle install --path vendor/bundle
$ bundle exec rake test
```

- Push to a branch on GitHub. Just like you developed in a local branch, you should push to a branch of your repo on GitHub. To push to a branch,
  if your branch is named "fix-typo-in-readme", use `git push origin fix-typo-in-readme`.

## Submitting a Pull Request

- Read the GitHub Guide on [Forking](https://guides.github.com/activities/forking/), especially the part about
  [Pull Requests](https://guides.github.com/activities/forking/#making-a-pull-request).

- Remember, pull requests are submitted *from* your repo, but show up on the *upstream* repo.

## Discussion and Waiting On a Merge

- Every pull request will receive a response from the team.
- Not every pull request will be merged as is.
- Not every pull request will be merged at all.
- If a pull request falls significantly behind master, we may ask that you close
  it, rebase your changes off of master, and submit a new pull request.
- Feel free to "ping" the team by adding a short comment to your pull request
  if it's been more than a week with no reply

## After your merge has been accepted

- keep your fork up to date

```
git checkout master
git pull upstream master
git push origin master
```
- Delete your topic branch if you like

```
git branch -dr fix-typo-in-readme
```
