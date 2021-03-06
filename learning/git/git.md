# GIT

**Set SSH-Key**

    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    xclip -sel clip < ~/.ssh/id_rsa.pub

**Show Branches**

    git branch -a

**Create new branch**

    git checkout -b <branch-name>

**Ignore Local changes - git pull**

    git fetch --all
    git reset --hard origin/master

    git reset --hard origin/<branch_name>

    git checkout master
    git pull --all

**Retrieve the remote git address of a repo**

    git config --get remote.origin.url
    git remote show origin

**Change git access to SSH for repo**

    https://help.github.com/articles/changing-a-remote-s-url/

    git remote set-url origin git@github.com:username/repo-name.git