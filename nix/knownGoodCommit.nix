{repoName, knownGood ? ./scripts/known_good.json}:
let 
   config = builtins.readJson knownGood;
in (head (filter (e : e.name == repoName) config."repos")).commit