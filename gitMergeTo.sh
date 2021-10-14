 #!/bin/bash

 cb=$(git branch --show-current)
 git checkout $1
 git pull
 git merge $cb -m "merge ${cb}"
 git push
 git checkout $cb
