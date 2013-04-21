# Daily CloudFoundry releases

Task to create final BOSH releases of cf-release for everyone to use.

Currently, the `cf-release` project is not publishing final releases for updated Cloud Foundry v1 nor v2 components. This means you can only build a Cloud Foundry deployment based on the HEAD commit of the `master` or `release-candidates` branch and you have to create a development release rather than use a much faster final release.

Hopefully they start cutting final releases soon; but in the meantime this project acts as a stopgap (assuming its finished and running before the create something similar - hurray; that would be perfect by me!)

Historically, the final releases in `cf-release` were to indicate "this is what is running on http://cloudfoundry.com". To my mind, that piece of metadata does not belong within `cf-release` repository. It is entirely up to each operator of each Cloud Foundry deployment (production, staging, test, etc) to determine which final release they choose to deploy. Final release can be cut all day long; it is up to Cloud Foundry operators/admins to choose whether they wish to upgrade to any specific final release that is available. The community and/or Pivotal itself can educate and indicate which final releases work better than others. Someone might even start writing release notes between these "good" final releases.

Final releases are a very useful concept in BOSH. They are a frozen snapshot of jobs and packages. For any given final release you can upload them (or not) to one of your BOSHes and then you can deploy them (or not). There is nothing about a final release that is special.

## Plan for implementation

My thinking at the moment is to have a `rake release` task that is run via Travis or Jenkins whenever the [release-candidate](https://github.com/cloudfoundry/cf-release/commits/release-candidate) branch of the BOSH [cf-release](https://github.com/cloudfoundry/cf-release/) is updated. This will probably require a github hook added with Pivotal's permission.

### How we create a final release of someone else's BOSH release repository

Currently, only the owner of a BOSH release can create final releases. Specifically, anyone with the `config/private.yml` file.

Only Pivotal employees have write-access credentials to their ATMOS blobstore (the `config/private.yml` file) so we have to work around this. But these same idea could be used to create final releases for anyone's BOSH release where you don't have the private blobstore credentials.

Specially, the `rake release` task performs the following sequence:

1. Clone or update the `cf-release` repository.
2. Rename the following folders related to releases: `.final_builds`, `config`, and `releases`.
3. Copy into `cf-release` our own `.final_builds`, `config`, and `releases` folders.
4. Create a final release: `bosh create release --final`.
5. Copy our own `.final_builds`, `config`, and `releases` folders back into this repository.

That is, this repository only contains the release parts of `cf-release` and not the source parts (`src`, `blobs`, `jobs`, and `packages` folders).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
