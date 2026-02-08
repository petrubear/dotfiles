function jarscan --description 'Scan JAR files for classes'
    set jar_path ~/Tools/Java/Jarscan/jarscan.jar
    
    if not test -f $jar_path
        echo "Error: jarscan.jar not found at $jar_path" >&2
        return 1
    end
    
    if test (count $argv) -eq 0
        echo "Usage: jarscan <classname>" >&2
        return 1
    end
    
    echo "Scanning on: $PWD"
    java -jar $jar_path -dir $PWD -class $argv
end
