function add_path -d "add path if exists"
for p in $argv[-1..1]
    if test -d $p
      set -x PATH $p $PATH
    end
  end
end
