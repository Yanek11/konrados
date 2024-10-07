### VARIABLES ###
$var1="variable 1"
${my var }="hello"
${my var }
Write-Output   $var1
Write-Output   ${my var }
${my var }


# strongly type a variable. determining data type for the variable
# 
[string]$Myname="jason"
[int]$Ooops="jason"
# casting data type to a variable value
## option 1  - you only want to have a variable as Integer and can assign other type of data
$x=[int]"1"
$x="text"
$x

# option 2 - you force a type of data on the variable ex. Integer. you cannot assign a variable of different type like text
[int]$x="1"
$x

[int]$computername=Read-Host "Enter Computer name" # only Integer values allowed
[string]$computername=Read-Host "Enter Computer name" # only String values allowed

# only values from a list are allowed
[validateset("a","b","c")][string]$x="a"
    #MetadataError: The variable cannot be validated because the value 1 is not a valid value for the x variable.

# Subexpressions
    $Service=get-service -name bits
    $msg="service name is $($Service.name.toupper())"

# Multiple objects
$services=get-service
$services[1..5] # several objects in array
$services[1..5].name
$services[-1] # last one
"Service name is $($services[3].DisplayName)"
$services.Count

# range operator
$services[1..5] # several objects in array
$services[5..1]|gm # same as above but backwards