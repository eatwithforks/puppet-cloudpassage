# Cloud Passage module for Puppet

## Description
A Puppet module for managing CloudPassage

## Requirements
This module requires a Puppet master of 2.6 or better.
By default data comes from extlookup which was likely to
support more users.

## Usage

### setup
You'll need to plug in your values in cloudpassage/manifests/data.pp
The module will plug those values in as needed

### include cloudpassage
installs and starts cphalod

### include cloudpassage::service::disable
installs, but stops the service

### apt
You may need to modify to use *your* apt update process
I didn't add one because it's likely to cause more problems
than it solves.

<!---
#CPTAGS:community-unsupported automation deployment
-->
