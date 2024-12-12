function ls -d "ls"
  switch (uname)
    case Darwin FreeBSD NetBSD DragonFly
      command ls -G -w $argv
    case Linux
      command ls --color $argv
    case '*'
      command ls $argv
  end
end
