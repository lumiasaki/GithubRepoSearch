# GithubRepoSearch

__If dear reviewers have any questions on the submission, you can create 'issue's on this repository to discuss the details with me if you would like to.__

Tested on XCode 14.0.1.

First of all, thanks for giving this take home coding assignment to me, it is a really great one to evaluate the performance and skill of candidates.

All features follow Pull Request development principle, I used `Liner` tool to help me managing all features and it was embedded in Github so you can see the `Liner` bot in the pull requests, you can just ignore it.

## Token issue

Because in fact, all strings can be found in binary packages, it is difficult to completely hide the text token in the binary package. One way to hide is that we can make the token into a binary file and disguise it as a common file format, and how to decode this binary only maintainers know how to get the token from it. In this way, we can store tokens more safely.

However, because this assignment is a limited-time assignment, and it may not be the focus of evaluation, I didn't put much priority on it. I only use base64 for simple encoding (in fact, it is not a safe way), but if necessary, a safer token storage method can be implemented according to the above-mentioned idea.

## Details of submission

Since we can not use any third party frameworks, I created a set of foundation components to drive this assignment.

We use UISearchController as the tool for search results, RepositoryListViewController as the display page for the results, and HomeViewController as a fake home page only.

Combine framework is used as the framework for data binding. It also enabled throttle function of keyword typing.

When user type keyword in, the request will be emitted incrementally, the result will be also displayed on the list incrementally. The list supports multi-page loading, when the list reached end of the list, the next page request will be emitted automatically.

The repository cell displayed some basic information of the repository, such as title, owner, description, stars and language. You can tap on the cell to browse the detail of the repository.

Since the requirement was not too complicate, we made some basic unit tests for the view model to validate the correctness.
