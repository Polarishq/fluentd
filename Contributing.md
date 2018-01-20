# Contributing to Splunk Nova

[Splunk Nova][splunknova] wouldn't be what it is without your help. Having trouble working with the plugin? Found a typo in the documentation?
Interested in adding a feature or [fixing a bug](https://github.com/splunknova/fluentd/issues)?
Then [submit an issue](https://github.com/splunknova/fluentd/issues/new)
or [pull request](https://help.github.com/articles/using-pull-requests/). Thanks for contributing!

## Submit a Pull Request

Please make your contributions as pull requests via GitHub.
See [Creating a pull request][pr]. Contributing is a great way to learn more about new technologies and how to create helpful bug reports, feature requests and a good, clean pull request.

- Read the GitHub Guide on [Forking](https://guides.github.com/activities/forking/), especially the part about
  [Pull Requests](https://guides.github.com/activities/forking/#making-a-pull-request).
- Remember, pull requests are submitted *from* your repo, but show up on the *upstream* repo.

### Before You Start

- First, create a fork, or copy, of the repository. If you have an existing fork, please make sure it's up to date by syncing the repo. See [Fork a repo](https://help.github.com/articles/fork-a-repo) and [Syncing a fork](https://help.github.com/articles/syncing-a-fork) articles for more information.

- Create a branch off of `master` before you start working, and give it a meaningful name such as what you plan to change. For example: `fix-typo-in-readme` or `my-new-feature`.
- To create a local branch, you can use `git checkout -b fix-typo-in-readme`.

### Before Submitting, run Tests

To set up your environment to develop this plugin, you'll first need to run tests.

1. Install the related libraries:

   ```bash
   bundle install --path vendor/bundle
   ```

1. Run the tests:

   ```bash
   bundle exec rake test
   ```

This starts a server using the in the `test_out_nova.rb` file.

1. Open your browser and verify `http://localhost:0000/test/`.

As modifications are made to the plugin and test site, it will regenerate and you should see the changes in the browser after a refresh.

- Push to a branch on GitHub. Just like you developed in a local branch, you should push to a branch of your repo on GitHub. To push to a branch,
  if your branch is named `fix-typo-in-readme`, use `git push origin fix-typo-in-readme`.


### Discussion and Waiting On a Merge

- Every pull request will receive a response from the team.
- Not every pull request will be merged as is.
- Not every pull request will be merged at all.
- If a pull request falls significantly behind the master branch, we may ask that you close it, rebase your changes off of `master`, and submit a new pull request.
- Feel free to "ping" the [Splunk Nova team][slacknova] on :slack: or :github: by adding a short comment to your pull request if it's been more than a week with no reply.

### After your merge has been accepted

Keep your fork up to date

```bash
git checkout master
git pull upstream master
git push origin master
```

Delete your topic branch if you like

```bash
git branch -dr fix-typo-in-readme
```

[pr]: https://help.github.com/articles/creating-a-pull-request/
[slacknova]: https://splunknova.slack.com/
[splunknova]: https://splunknova.com/
