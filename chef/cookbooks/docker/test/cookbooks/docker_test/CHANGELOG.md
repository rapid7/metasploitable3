# CHANGELOG for docker_test

This file is used to list changes made in each version of docker_test.

## 0.5.1:

* Bugfix: Test docker_image :build for both file and directory source

## 0.5.0:

* Bugfix: Switch docker@0.25.0 deprecated dockerfile container LWRP attribute to source

## 0.4.0:

* Bugfix: Remove deprecated public_port in container_lwrp
* Bugfix: Add `init_type false` for busybox test containers
* Enhancement: Add tduffield/testcontainerd image, container, and tests

## 0.3.0:

* Enhancement: Change Dockerfile FROM to already downloaded busybox image instead of ubuntu

## 0.2.0:

* Added container_lwrp recipe
* Removed default recipe from image_lwrp recipe

## 0.1.0:

* Initial release of docker_test

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
