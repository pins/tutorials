<!--
Copyright 2019-present Open Networking Foundation

SPDX-License-Identifier: Apache-2.0
-->

# How to Contribute

We'd love to accept your patches and contributions to this project. There are
just a few small guidelines you need to follow.

## Contributor License Agreement

Contributions to this project must be accompanied by a Contributor License
Agreement. You (or your employer) retain the copyright to your contribution,
this simply gives us permission to use and redistribute your contributions as
part of the project. Head over to <https://cla.opennetworking.org/> to see
your current agreements on file or to sign a new one.

You generally only need to submit a CLA once, so if you've already submitted one
(even if it was for a different project), you probably don't need to do it
again.

## Guides, Rules and Best Practices

Feel free to directly contribute corrections or tips to the tutorial.

If you'd like to contribute something more substantial (e.g. a new exercise), we
would encourage you to first open up a new issue to discuss your proposal.

### Steps to successful PRs

1. Fork Stratum into your personal or organization account via the fork button
   on GitHub.

1. Make your changes.

1. Run the Markdown linter and fix any issues:

   ```
   docker run -v $PWD:/workdir ghcr.io/igorshubovych/markdownlint-cli:latest **/*.md
   ```

1. Create a [Pull Request](https://github.com/stratum/stratum/compare). Consider
   [allowing maintainers](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch-created-from-a-fork)
   to make changes if you want direct assistance from maintainers.

1. Await review. Everyone can comment on code changes, but only Collaborators
   and above can give final review approval. **All changes must get at least one
   approval**. Join one of the [communication channels](https://wiki.opennetworking.org/display/COM/Stratum+Wiki+Home+Page)
   to request a review or to bring additional attention to your PR.

### VSCode tips

There are two plugins that will help you keep your Markdown compliant:

* [Reflow Markdown](https://marketplace.visualstudio.com/items?itemName=marvhen.reflow-markdown)
    * Press Alt-Q to reform a line, or Ctrl-A (select all) then Alt-Q to
      reformat the whole file)
* [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
    * Markdown errors are underlined in yellow in realtime
    * Check out the "Problems" panel at the bottom to see Markdown errors
    * Press Shift-Alt-F to fix some style issues

## Community Guidelines

This project follows [Google's Open Source Community Guidelines](https://opensource.google.com/conduct/)
and ONF's [Code of Conduct](CODE_OF_CONDUCT.md).
