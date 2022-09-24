write-host 'Number of arguments was :' ($args.length)
write-output 'and they were :'
foreach($arg in $args)
{
    write-output $arg
}