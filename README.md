sudo chmod o-w <directory>
sudo chmod -R o-w /myfolder

o-w in symbolic mode is equivalent to subtracting 2 (write permission) from "others" in numeric mode.
If a directory had permissions like 777 (rwxrwxrwx), removing o-w makes it 775 (rwxrwxr-x).
