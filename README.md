Taskly
======

**A simple tasks app for Ubuntu Touch.**

This is based on my original [Tasks](https://github.com/sonrisesoftware/tasks-app) app that I wrote for the 2013 Ubuntu App Showdown, but written from the ground up using the latest and greatest Ubuntu technologies and designs, and using my powerful [uData](https://github.com/sonrisesoftware/udata) data persistence framework.

Developed by Michael Spencer for Sonrise Software.

### Dependencies ###

Other than the Ubuntu SDK, Taskly requires several of my GitHub libraries, which are referenced as Git Submodules. If you're unfamiliar with how submodules work, check out [the chapter of the Git book on submodules](http://git-scm.com/book/en/Git-Tools-Submodules). Basically, check out the Taskly repository, then run

    git submodule init

Now, any time you do a `git pull` in the Taskly repository, and you see a change to the files `udata`, `qml-extras`, or `ubuntu-ui-extras`, that means the versions of those submodules have been changed. Now, you need to update the submodules using this command:

    git submodule update

### Licensing ###

Taskly is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
