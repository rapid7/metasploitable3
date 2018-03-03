# build_cookbook

A build cookbook for running the parent project through Chef Delivery

This build cookbook should be customized to suit the needs of the parent project. Using this cookbook can be done outside of Chef Delivery, too. If the parent project is a Chef cookbook, we've detected that and "wrapped" [delivery-truck](https://github.com/chef-cookbooks/delivery-truck). That means it is a dependency, and each of its pipeline phase recipes is included in the appropriate phase recipes in this cookbook. If the parent project is not a cookbook, it's left as an exercise to the reader to customize the recipes as needed for each phase in the pipeline.

## .delivery/config.json

In the parent directory to this build_cookbook, the `config.json` can be modified as necessary. For example, phases can be skipped, publishing information can be added, and so on. Refer to customer support or the Chef Delivery documentation for assistance on what options are available for this configuration.

## Test Kitchen - Local Verify Testing

This cookbook also has a `.kitchen.yml` which can be used to create local build nodes with Test Kitchen to perform the verification phases, `unit`, `syntax`, and `lint`. When running `kitchen converge`, the instances will be set up like Chef Delivery "build nodes" with the [delivery_build cookbook](https://github.com/chef-cookbooks/delivery_build). The reason for this is to make sure that the same exact kind of nodes are used by this build cookbook are run on the local workstation as would run Delivery. It will run `delivery job verify PHASE` for the parent project.

Modify the `.kitchen.yml` if necessary to change the platforms or other configuration to run the verify phases. After making changes in the parent project, `cd` into this directory (`.delivery/build_cookbook`), and run:

```
kitchen test
```

## Recipes

Each of the recipes in this build_cookbook are run in the named phase during the Chef Delivery pipeline. The `unit`, `syntax`, and `lint` recipes are additionally run when using Test Kitchen for local testing as noted in the above section.

## Making Changes - Cookbook Example

When making changes in the parent project (that which lives in `../..` from this directory), or in the recipes in this build cookbook, there is a bespoke workflow for Chef Delivery. As an example, we'll discuss a Chef Cookbook as the parent.

First, create a new branch for the changes.

```
git checkout -b testing-build-cookbook
```

Next, increment the version in the metadata.rb. This should be in the _parent_, not in this, the build_cookbook. If this is not done, the verify phase will fail.

```
% git diff
<SNIP>
-version '0.1.0'
+version '0.1.1'
```

The change we'll use for an example is to install the `zsh` package. Write a failing ChefSpec in the cookbook project's `spec/unit/recipes/default_spec.rb`.

```ruby
require 'spec_helper'

describe 'godzilla::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'installs zsh' do
      expect(chef_run).to install_package('zsh')
    end
  end
end
```

Commit the local changes as work in progress. The `delivery job` expects to use a clean git repository.

```
git add ../..
git commit -m 'WIP: Testing changes'
```

From _this_ directory (`.delivery/build_cookbook`, relative to the parent cookbook project), run

```
cd .delivery/build_cookbook
kitchen converge
```

This will take some time at first, because the VMs need to be created, Chef installed, the Delivery CLI installed, etc. Later runs will be faster until they are destroyed. It will also fail on the first VM, as expected, because we wrote the test first. Now edit the parent cookbook project's default recipe to install `zsh`.

```
cd ../../
$EDITOR/recipes/default.rb
```

It should look like this:

```
package 'zsh'
```

Create another commit.

```
git add .
git commit -m 'WIP: Install zsh in default recipe'
```

Now rerun kitchen from the build_cookbook.

```
cd .delivery/build_cookbook
kitchen converge
```

This will take awhile because it will now pass on the first VM, and then create the second VM. We should have warned you this was a good time for a coffee break.

```
Recipe: test::default

- execute HOME=/home/vagrant delivery job verify unit --server localhost --ent test --org kitchen
  * execute[HOME=/home/vagrant delivery job verify lint --server localhost --ent test --org kitchen] action run
    - execute HOME=/home/vagrant delivery job verify lint --server localhost --ent test --org kitchen

    - execute HOME=/home/vagrant delivery job verify syntax --server localhost --ent test --org kitchen

Running handlers:
Running handlers complete
Chef Client finished, 3/32 resources updated in 54.665445968 seconds
Finished converging <default-centos-71> (1m26.83s).
```

Victory is ours! Our verify phase passed on the build nodes.

We are ready to run this through our Delivery pipeline. Simply run `delivery review` on the local system from the parent project, and it will open a browser window up to the change we just added.

```
cd ../..
delivery review
```

## FAQ

### Why don't I just run rspec and foodcritic/rubocop on my local system?

An objection to the Test Kitchen approach is that it is much faster to run the unit, lint, and syntax commands for the project on the local system. That is totally true, and also totally valid. Do that for the really fast feedback loop. However, the dance we do with Test Kitchen brings a much higher degree of confidence in the changes we're making, that everything will run on the build nodes in Chef Delivery. We strongly encourage this approach before actually pushing the changes to Delivery.

### Why do I have to make a commit every time?

When running `delivery job`, it expects to merge the commit for the changeset against the clean master branch. If we don't save our progress by making a commit, our local changes aren't run through `delivery job` in the Test Kitchen build instances. We can always perform an interactive rebase, and modify the original changeset message in Delivery with `delivery review --edit`. The latter won't modify the git commits, only the changeset in Delivery.

### What do I do next?

Make changes in the cookbook project as required for organizational goals and needs. Modify the `build_cookbook` as necessary for the pipeline phases that the cookbook should go through.

### What if I get stuck?

Contact Chef Support, or your Chef Customer Success team and they will help you get unstuck.
