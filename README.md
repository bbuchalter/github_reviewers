Ever wanted to see who's been reviewing someone's PRs?

Usage

```
git clone git@github.com:bbuchalter/github_reviewers.git
cd github_reviewers
bundle install
bin/github_reviewers.rb gusto bbuchalter 2021-09-01
```

Results

```
Searching for PRs with the following criteria: is:pull-request org:gusto author:bbuchalter created:>2021-04-01
Found 5 PRs.
Collecting data about reviewers for PRs............done.
{"amanda-mitchell"=>{"APPROVED"=>2},
 "pbomb"=>{"APPROVED"=>2},
 "grxy"=>{"APPROVED"=>2},
 "Pchao93"=>{"APPROVED"=>1},
 "lewhit"=>{"COMMENTED"=>3, "APPROVED"=>1},
 "ansonlc"=>{"COMMENTED"=>1}}
```

Assumptions

- You've got an environment variable `GITHUB_TOKEN` with a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) that has permissions for `repo` and whatever org you've specified.
- Ruby 3.0.2 installed
