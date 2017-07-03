# example usage:  ./transform.sh src/test/resources/platform.xml html/platform.html
java -cp target/*:target/dependency/* -Dlog4j.configuration=file:src/test/resources/log4j.properties org.appng.xml.transformation.Transformer src/main/resources $1 $2
